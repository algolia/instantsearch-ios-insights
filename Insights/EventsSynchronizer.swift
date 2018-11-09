//
//  EventsSynchronizer.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class EventsSynchronizer: EventProcessor {
    
    typealias Storage = LocalStorage<[EventsPackage]>
    
    let credentials: Credentials
    var eventsPackages: [EventsPackage]
    let webservice: WebService
    let logger: Logger
    var isLocalStorageEnabled: Bool = true {
        didSet {
            if !isLocalStorageEnabled {
                Storage.deleteFile(atPath: localStorageFileName)
            }
        }
    }
    private var flushTimer: Timer!
    private let operationQueue: OperationQueue
    private let localStorageFileName: String
    
    init(credentials: Credentials,
         webService: WebService,
         flushDelay: TimeInterval,
         logger: Logger) {
        self.eventsPackages = []
        self.credentials = credentials
        self.logger = logger
        self.webservice = webService
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .utility
        self.operationQueue = operationQueue
        self.localStorageFileName = "\(credentials.appId).events"
        self.flushTimer = .scheduledTimer(timeInterval: flushDelay, target: self, selector: #selector(flushEvents), userInfo: nil, repeats: true)
        deserialize()
    }
    
    func process(_ event: Event) {
        operationQueue.addOperation { [weak self] in
            self?.syncProcess(event)
        }
    }
    
    // Synchronous version of event processing for facilitating queuing and testing
    
    func syncProcess(_ event: Event) {
        let wrappedEvent = EventWrapper(event)
        let eventsPackage: EventsPackage
        
        if let lastEventsPackage = eventsPackages.last, !lastEventsPackage.isFull {
            // We are sure that try! will not crash, as where is "not full" check
            eventsPackage = try! eventsPackages.removeLast().appending(wrappedEvent)
        } else {
            eventsPackage = EventsPackage(event: wrappedEvent)
        }
        
        eventsPackages.append(eventsPackage)
        serialize()
    }
    
    @objc private func flushEvents() {
        flush(eventsPackages)
    }
    
    func flush(_ eventsPackages: [EventsPackage]) {
        logger.debug(message: "Flushing remaining events")
        eventsPackages.forEach(sync)
    }
    
    private func sync(eventsPackage: EventsPackage) {
        logger.debug(message: "Syncing \(eventsPackage)")
        webservice.sync(event: eventsPackage) { [weak self] err in
            
            // If there is no error or the error is from the Analytics we should remove it.
            // In case of a WebserviceError the package was wronlgy constructed
            if err == nil || err is WebserviceError {
                self?.remove(eventsPackage: eventsPackage)
            }
            
        }
    }
    
    private func remove(eventsPackage: EventsPackage) {
        eventsPackages.removeAll(where: { $0.id == eventsPackage.id })
        serialize()
    }
    
    private func serialize() {
        guard isLocalStorageEnabled else { return }
        
        if let file = Storage.filePath(for: localStorageFileName) {
            Storage.serialize(eventsPackages, file: file)
        } else {
            logger.debug(message: "Error creating a file for \(localStorageFileName)")
        }
    }
    
    private func deserialize() {
        guard isLocalStorageEnabled else { return }
        
        guard let filePath = Storage.filePath(for: localStorageFileName) else {
            logger.debug(message: "Error reading a file for \(localStorageFileName)")
            return
        }
        self.eventsPackages = Storage.deserialize(filePath) ?? []
    }
    
    deinit {
        flushTimer.invalidate()
    }
    
}
