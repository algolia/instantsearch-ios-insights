//
//  EventsSynchronizer.swift
//  Insights
//
//  Created by Vladislav Fitc on 06/11/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

class EventsSynchronizer: EventProcessor {
    
    let credentials: Credentials
    var eventsPackages: [EventsPackage]
    let webservice: WebService
    let logger: Logger
    private var flushTimer: Timer!
    
    init(credentials: Credentials,
         webService: WebService,
         flushDelay: TimeInterval,
         logger: Logger) {
        self.eventsPackages = []
        self.credentials = credentials
        self.logger = logger
        self.webservice = webService
        self.flushTimer = Timer.scheduledTimer(timeInterval: flushDelay, target: self, selector: #selector(flushEvents), userInfo: nil, repeats: true)
        deserialize()
    }
    
    func process(_ event: Event) {
        
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
    
    @objc func flushEvents() {
        flush(eventsPackages)
    }
    
    private func flush(_ eventsPackages: [EventsPackage]) {
        logger.debug(message: "Flushing remaining events")
        eventsPackages.forEach(sync)
    }
    
    private func sync(eventsPackage: EventsPackage) {
        logger.debug(message: "Syncing \(eventsPackage)")
        webservice.sync(event: eventsPackage) {[weak self] err in
            
            // If there is no error or the error is from the Analytics we should remove it. In case of a WebserviceError the event was wronlgy constructed
            if err == nil || err is WebserviceError {
                self?.remove(eventsPackage: eventsPackage)
            }
        }
    }
    
    private func remove(eventsPackage: EventsPackage) {
        eventsPackages.removeAll(where: { $0.id == eventsPackage.id })
        serialize()
    }
    
    let localStorageFileName = "events.com.agolia.insights"
    
    private func serialize() {
        if let file = LocalStorage<[EventsPackage]>.filePath(for: localStorageFileName) {
            LocalStorage<[EventsPackage]>.serialize(eventsPackages, file: file)
        } else {
            logger.debug(message: "Error creating a file for \(localStorageFileName)")
        }
    }
    
    private func deserialize() {
        guard let filePath = LocalStorage<[EventsPackage]>.filePath(for: localStorageFileName) else {
            logger.debug(message: "Error reading a file for \(localStorageFileName)")
            return
        }
        self.eventsPackages = LocalStorage<[EventsPackage]>.deserialize(filePath) ?? []
    }
    
    deinit {
        flushTimer.invalidate()
    }
    
}
