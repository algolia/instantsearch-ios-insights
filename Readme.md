[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods](https://img.shields.io/cocoapods/v/AlgoliaSearch-Client-Swift.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/AlgoliaSearch-Client-Swift.svg)]()
[![](https://img.shields.io/badge/OS%20X-10.9%2B-lightgrey.svg)]()
[![](https://img.shields.io/badge/iOS-7.0%2B-lightgrey.svg)]()
[![Swift 4.2](https://img.shields.io/badge/Swift-4.0-orange.svg)]()
<a href="https://developer.apple.com/documentation/objectivec"><img src="https://img.shields.io/badge/Objective--C-compatible-blue.svg" alt="Objective-C compatible" /></a>

By [Algolia](http://algolia.com).

# Algolia InstantSearch Insights for Swift and Objective-C

**InstantSearch Insights iOS** library allows developers to capture search-related events. The events maybe related to search queries (such as click an conversion events used for Click Analytics or A/B testing). It does so by correlating events with queryIDs generated by the search API when a query parameter clickAnalytics=true is set. As well library allows to capture search-independent events which can be used for the purpose of search experience personalisation. There are three types of these events which are currently supported: click, conversion and view.

# Getting started

## Supported platforms

**InstantSearch Insights iOS** is supported on **iOS**, **macOS**, **tvOS** and **watchOS**,
and is usable from both **Swift** and **Objective-C**.

## Install

1. Add a dependency on InstantSearchInsights:
- CocoaPods: add `pod 'InstantSearchInsights', '~> 2.0.0-beta'` to your `Podfile`.
- Carthage: add `github "algolia/instantsearch-ios-insights" ~> 2.0.0-beta` to your `Cartfile`.

2. Add `import InstantSearchInsights` to your source files.

## Quick Start

### Initialize the Insights client

You first need to initialize the Insights client. For that you need your **Application ID** and **API Key**.
You can find them on [your Algolia account](https://www.algolia.com/api-keys).
Also, for the purpose of personalisation an application **User Token** can be specified via the correspponding optional parameter. In case of non-specified user token an automatically-generated application-wide user token will be used.

```swift
// Swift
Insights.register(appId: "testApp", apiKey: "testKey", userToken: "testToken")
```

```objc
// ObjC
[Insights registerWithAppId:@"testApp"
                     apiKey:@"testKey"
                  userToken:@"testToken"];
```

### Sending metrics

Once that you registered your **Application ID** and the **API Key** you can easily start sending metrics. 

```swift
// Swift
Insights.shared?.clickedAfterSearch(eventName: "click event",
                                    indexName: "index name",
                                    objectID: "object id",
                                    position: 1,
                                    queryID: "query id")

Insights.shared?.convertedAfterSearch(eventName: "conversion event",
                                      indexName: "index name",
                                      objectIDs: ["obj1", "obj2"],
                                      queryID: "query id")

Insights.shared?.viewed(eventName: "view event",
                        indexName: "index name",
                        filters: ["brand:apple"])

```

```objc
// ObjC	
[[Insights shared] clickedAfterSearchWithEventName:@"click event"
                                         indexName:@"index name"
                                          objectID:@"object id"
                                          position:1
                                           queryID:@"query id"
                                         userToken:nil];

[[Insights shared] convertedAfterSearchWithEventName:@"conversion event"
                                           indexName:@"index name"
                                            objectID:@"object id"
                                             queryID:@"query id"
                                           userToken:nil];

[[Insights shared] viewedWithEventName:@"view event"
                             indexName:@"index name"
                               filters:@[@"brand:apple"]
                             userToken:nil];
```

### Logging and debuging

In case you want to check if the metric was sent correctly, you need to enable the logging first

```swift
// Swift
Insights.shared(appId: "appId")?.isLoggingEnabled = true
```

After you enabled it, you can check the output for success messages or errors

```
// Success
[Algolia Insights - appName] Sync succeded for EventsPackage(id: "37E9A093-8F86-4049-9937-23E99E4E4B33", events: [{
    eventName = "search result click";
    eventType = click;
    index = "my index";
    objectIDs =     (
        1234567
    );
    positions =     (
        3
    );
    queryID = 08a76asda34fl30b7d06b7aa19a9e0;
    timestamp = 1545069313405;
    userToken = "C1D1322E-8CBF-432F-9875-BE3B5AFDA498";
}], region: nil)

//Error
[Algolia Insights - appName] The objectID field is missing (Code: 422)
```

### Events flush delay

By default the client transmits tracked events every 30 minutes. You can customize this delay by changing `flushDelay` value (in seconds) as follows:

```swift
// Swift
Insights.flushDelay = 60
```

```objc
// ObjC
[Insights setFlushDelay: 60]; 
```

### Setting API region

By default each analytics API call is geo-routed so that each call targets the closest API. 
Today the analytics API suports two regions: United States and Germany. You can specify the region your prefer to use as follows: 

```swift
// Swift
Insights.region = .de
```

```objc
// ObjC
[Insights setRegion: [Region de]]];
```

To get a more meaningful search experience, please follow our [Getting Started Guide](https://community.algolia.com/instantsearch-ios/getting-started.html).

## Getting Help

- **Need help**? Ask a question to the [Algolia Community](https://discourse.algolia.com/) or on [Stack Overflow](http://stackoverflow.com/questions/tagged/algolia).
- **Found a bug?** You can open a [GitHub issue](https://github.com/algolia/instantsearch-ios-insights).
- **Questions about Algolia?** You can search our [FAQ in our website](https://www.algolia.com/doc/faq/).


## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you use **InstantSearch** in your app, we would love to hear about it! Drop us a line on [discourse](https://discourse.algolia.com/) or [twitter](https://twitter.com/algolia).

# License

InstantSearch iOS Insights is [MIT licensed](LICENSE.md).

[react-instantsearch-github]: https://github.com/algolia/react-instantsearch/
[instantsearch-android-github]: https://github.com/algolia/instantsearch-android
[instantsearch-js-github]: https://github.com/algolia/instantsearch.js
