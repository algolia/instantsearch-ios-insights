//
//  EventsController.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class EventsController: EventProcessor {
    
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
    private let dispatchQueue: DispatchQueue
    private let localStorageFileName: String
    private weak var flushTimer: Timer?
    
    init(credentials: Credentials,
         webService: WebService,
         flushDelay: TimeInterval,
         logger: Logger,
         dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {
        self.eventsPackages = []
        self.credentials = credentials
        self.logger = logger
        self.webservice = webService
        self.dispatchQueue = dispatchQueue
        self.localStorageFileName = "\(credentials.appId).events"
        let flushTimer = Timer.scheduledTimer(timeInterval: flushDelay,
                                                    target: self,
                                                  selector: #selector(flushEvents),
                                                  userInfo: nil,
                                                   repeats: true)
        self.flushTimer = flushTimer

        RunLoop.main.add(flushTimer, forMode: .default)
        deserialize()
    }
    
    func process(_ event: Event) {
        dispatchQueue.async { [weak self] in
            self?.syncProcess(event)
        }
    }
    
    private func syncProcess(_ event: Event) {
        let wrappedEvent = EventWrapper(event)
        let eventsPackage: EventsPackage
        
        if let lastEventsPackage = eventsPackages.last, !lastEventsPackage.isFull {
            eventsPackage = (try? eventsPackages.removeLast().appending(wrappedEvent)) ?? EventsPackage(event: wrappedEvent)
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
        logger.debug(message: "Flushing pending packages")
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
        flushTimer?.invalidate()
    }
    
}
