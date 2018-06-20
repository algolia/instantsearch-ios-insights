//
//  SearchController.swift
//  Insights-Demo
//
//  Created by Robert Mogos on 14/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit
import InstantSearchInsights
import InstantSearchClient
import CFNotify
import Nuke

class SearchController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

  struct Algolia {
    struct Config {
      static let appID = "latency"
      static let apiKey = "afc3dd66dd1293e2e2736a5a51b05c0a"
      static let indexName = "bestbuy"
    }
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  var algoliaIndex: Index!

  var searchResult: SearchResults?

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "hitCell")

    // Register Algolia Index
    let client = Client(appID: Algolia.Config.appID,
                        apiKey: Algolia.Config.apiKey)
    algoliaIndex = client.index(withName: Algolia.Config.indexName)

    // Registering the app for Insights
    Insights.register(appId: Algolia.Config.appID,
                      apiKey: Algolia.Config.apiKey,
                      indexName: Algolia.Config.indexName)

    Insights.shared(index: Algolia.Config.indexName)?.loggingEnabled = true
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let searchResult = searchResult else {
      return 0
    }
    return searchResult.allHits.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let searchResult = searchResult else {
      fatalError("Should not be here")
    }
    let hit = searchResult.allHits[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
    cell.textLabel?.text = hit["name"] as? String
    cell.textLabel?.highlightedTextColor = UIColor.black
    cell.imageView?.image = #imageLiteral(resourceName: "placeholder")

    let addToCartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    addToCartButton.backgroundColor = .red

    addToCartButton.setTitle("Buy", for: .normal)
    addToCartButton.action = { [weak self] in
      self?.sendConversion(hit)
    }
    cell.accessoryView = addToCartButton

    if let image = hit["image"] as? String, let imageUrl = URL(string: image) {
      cell.imageView?.contentMode = .scaleAspectFit
      Nuke.loadImage(
        with: imageUrl,
        options: ImageLoadingOptions(
          placeholder: #imageLiteral(resourceName: "placeholder"),
          transition: .fadeIn(duration: 0.33)
        ),
        into: cell.imageView!
      )
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let searchResult = searchResult else {
      return
    }
    let hit = searchResult.allHits[indexPath.row]
    if let queryID = searchResult.queryID, let objectID = hit["objectID"] as? String {
      Insights.shared(index: Algolia.Config.indexName)?.click(params: [
        "queryID": queryID,
        "objectID": objectID,
        // This is very important: The position must be a strictly positive number
        // This means, the position 0 needs to be reported as 1, 1 as 2, etc ...
        "position": indexPath.row
        ])
      showAlert(title: "Click event sent", message: "🚀")
    }
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let query = Query(query: searchBar.text)

    // !!! This is important to set up so we can get back the queryID !!!
    query.clickAnalytics = true

    algoliaIndex.search(query, completionHandler: {[weak self] (content, error) in
      if let content = content {
        do {
          self?.searchResult = try SearchResults(content: content, disjunctiveFacets: [])
        } catch _ {
          self?.searchResult = nil
        }
      } else {
        self?.searchResult = nil
      }
      self?.tableView.reloadData()
    })
  }

  func showAlert(title: String, message: String) {
    let notificationView = CFNotifyView.cyberWith(title: title,
                                                  body: message,
                                                  theme: .success(.dark))
    CFNotify.present(view: notificationView)
  }

  func sendConversion(_ hit:[String: Any]) {
    if let queryID = searchResult?.queryID, let objectID = hit["objectID"] as? String {
      Insights.shared(index: Algolia.Config.indexName)?.conversion(params: [
        "queryID": queryID,
        "objectID": objectID
        ])
      showAlert(title: "Conversion event sent", message: "🚀")
    }
  }
}
