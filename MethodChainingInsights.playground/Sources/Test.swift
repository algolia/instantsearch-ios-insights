import Foundation

class EventProcessor: EventProcessable {
    
    var isActive: Bool = true
    
    func process(_ event: Event) {
        print("process \(event)")
    }
    
}

public struct Insights {
    
    var eventProcessor: EventProcessable
    let userToken: String?
    
    public init(appId: String,
                apiKey: String,
                userToken: String? = .none) {
        eventProcessor = EventProcessor()
        self.userToken = userToken
    }
    
    public func click(indexName: String, userToken: String? = .none, timeStamp: Int64? = .none) -> ClickEventGenerator {
        let eventTemplate = EventTemplate(type: .click, indexName: indexName, userToken: userToken, timestamp: timeStamp)
        return ClickEventGenerator(eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }

    public func view(indexName: String, userToken: String? = .none, timeStamp: Int64? = .none) -> ViewEventGenerator {
        let eventTemplate = EventTemplate(type: .view, indexName: indexName, userToken: userToken, timestamp: timeStamp)
        return ViewEventGenerator(eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }

    public func conversion(indexName: String, userToken: String? = .none, timeStamp: Int64? = .none) -> ConversionEventGenerator {
        let eventTemplate = EventTemplate(type: .conversion, indexName: indexName, userToken: userToken, timestamp: timeStamp)
        return ConversionEventGenerator(eventTemplate: eventTemplate, eventProcessor: eventProcessor)
    }
    
}
