//
//  EventsProcessor.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class EventsProcessor: EventProcessable {
    
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
    var isActive: Bool = true
    private let region: Region?
    private let dispatchQueue: DispatchQueue
    private let localStorageFileName: String
    private weak var flushTimer: Timer?
    
    init(credentials: Credentials,
         webService: WebService,
         region: Region?,
         flushDelay: TimeInterval,
         logger: Logger,
         dispatchQueue: DispatchQueue = .init(label: "insights.events", qos: .background)) {
        self.eventsPackages = []
        self.credentials = credentials
        self.logger = logger
        self.webservice = webService
        self.region = region
        self.dispatchQueue = dispatchQueue
        self.localStorageFileName = "\(credentials.appId).events"
        let flushTimer = Timer.scheduledTimer(timeInterval: flushDelay,
                                                    target: self,
                                                  selector: #selector(flushEventsPackages),
                                                  userInfo: nil,
                                                   repeats: true)
        self.flushTimer = flushTimer

        RunLoop.main.add(flushTimer, forMode: .default)
        readEventPackagesFromDisk()
    }
    
    @objc func flushEventsPackages() {
        if eventsPackages.isEmpty {
            logger.debug(message: "No pending event packages")
        } else {
            logger.debug(message: "Flushing pending event packages")
            eventsPackages.forEach(sync)
        }
    }
    
    func process(_ event: Event) {
        guard isActive else {
            logger.debug(message: "Event tracking is desactivated. This event will be ignored. You can reactivate tracking by setting `Insights.shared(appId: \(credentials.appId))`.isActive = true`")
            return
        }
        
        dispatchQueue.async { [weak self] in
            self?.syncProcess(event)
        }
    }
    
    private func syncProcess(_ event: Event) {
        let wrappedEvent = EventWrapper(event)
        let eventsPackage: EventsPackage
        
        if let lastEventsPackage = eventsPackages.last, !lastEventsPackage.isFull {
            eventsPackage = (try? eventsPackages.removeLast().appending(wrappedEvent)) ?? EventsPackage(event: wrappedEvent, region: region)
        } else {
            eventsPackage = EventsPackage(event: wrappedEvent, region: region)
        }
        
        eventsPackages.append(eventsPackage)
        storeEventPackagesOnDisk()
    }
    
    private func remove(_ eventsPackage: EventsPackage) {
        eventsPackages.removeAll(where: { $0.id == eventsPackage.id })
        storeEventPackagesOnDisk()
    }
    
    private func sync(_ eventsPackage: EventsPackage) {
        logger.debug(message: "Syncing \(eventsPackage)")
        webservice.sync(eventsPackage) { [weak self] err in
            
            // If there is no error or the error is from the Analytics we should remove it.
            // In case of a WebserviceError the package was wronlgy constructed
            if err == nil || err is WebserviceError {
                self?.remove(eventsPackage)
            }
            
        }
    }
    
    private func storeEventPackagesOnDisk() {
        guard isLocalStorageEnabled else { return }
        
        guard let file = Storage.filePath(for: localStorageFileName) else {
            logger.debug(message: "Error creating a file for \(localStorageFileName)")
            return
        }
        
        Storage.serialize(eventsPackages, file: file)
    }
    
    private func readEventPackagesFromDisk() {
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
