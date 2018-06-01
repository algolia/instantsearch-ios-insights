//
//  LocalStorage.swift
//  Insights
//
//  Created by Robert Mogos on 01/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation

func filePathFor(_ index: String) -> String? {
  let filename = "algolia-\(index)"
  let manager = FileManager.default
  
  #if os(iOS)
    let url = manager.urls(for: .libraryDirectory, in: .userDomainMask).last
  #else
  let url = manager.urls(for: .cachesDirectory, in: .userDomainMask).last
  #endif // os(iOS)
  
  guard let urlUnwrapped = url?.appendingPathComponent(filename).path else {
    return nil
  }
  return urlUnwrapped
}
