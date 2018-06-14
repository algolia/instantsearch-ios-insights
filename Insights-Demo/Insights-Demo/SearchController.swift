//
//  SearchController.swift
//  Insights-Demo
//
//  Created by Robert Mogos on 14/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit
import InstantSearchInsights

class SearchController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  @IBAction func sendView(_ sender: Any) {
    Insights.shared(index: "rmogos")?.click(params: [
      "queryID": "74e382ecaf889f9f2a3df0d4a9742dfb",
      "objectID":"85725102",
      "position": 1
      ])
  }
  
  @IBAction func sendClick(_ sender: Any) {
    Insights.shared(index: "rmogos")?.conversion(params: [
      "queryID": "74e382ecaf889f9f2a3df0d4a9742dfb",
      "objectID":"85725102"
      ])
  }
}
