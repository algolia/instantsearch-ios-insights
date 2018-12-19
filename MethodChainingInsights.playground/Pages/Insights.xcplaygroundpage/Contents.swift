
let insights = Insights(appId: "appId", apiKey: "apiKey", userToken: "user token")

insights.click(indexName: "index name").event(withName: "event name").with(objectID: "object id")
insights.click(indexName: "index name").event(withName: "event name").with(filters: ["brand:hp"])
insights.click(indexName: "index name").query(withID: "query id").with(objectID: "object id", position: 1)
insights.click(indexName: "index name").query(withID: "query id").with(objectIDsWithPositions: [("o1", 1), ("o2", 2), ("o3", 3)])

insights.conversion(indexName: "index name").event(withName: "event name").with(objectID: "object id")
insights.conversion(indexName: "index name").query(withID: "query id").with(objectIDs: ["o1", "o2"])

insights.view(indexName: "index name").event(withName: "event name").with(objectID: "o1")
