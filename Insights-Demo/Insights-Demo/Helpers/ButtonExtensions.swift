//
//  ButtonExtensions.swift
//  Insights-Demo
//
//  Created by Robert Mogos on 15/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import Foundation
import UIKit

typealias ButtonAction = () -> Void

extension UIButton {

  private struct AssociatedKeys {
    static var ActionKey = "ActionKey"
  }

  private class ActionWrapper {
    let action: ButtonAction
    init(action: @escaping ButtonAction) {
      self.action = action
    }
  }

  var action: ButtonAction? {
    set(newValue) {
      removeTarget(self, action: #selector(performAction), for: .touchUpInside)
      var wrapper: ActionWrapper? = nil
      if let newValue = newValue {
        wrapper = ActionWrapper(action: newValue)
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
      }

      objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    get {
      guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
        return nil
      }

      return wrapper.action
    }
  }

  @objc func performAction() {
    guard let action = action else {
      return
    }

    action()
  }
}
