//
//  MainController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/13/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
  var historySections: [String: [[String]]] = ["Set": []]
  
  override func viewDidLoad() {
    delegate = self
    
    super.viewDidLoad()
  }
  
  func tabBarController(tabBarController: UITabBarController,
    shouldSelectViewController viewController: UIViewController) -> Bool {
      if (selectedViewController!.isKindOfClass(SetGameController)) {
        var sgc = selectedViewController as! SetGameController
        
        var didPush = pushToHistory("Set", statuses: sgc.getGameHistory())
        
        if (didPush) {
          sgc.clearOldHistory()
        }
      } else if (selectedViewController!.isKindOfClass(MemoryGameController)) {
        var mgc = selectedViewController as! MemoryGameController
        
        var didPush = pushToHistory("Memory", statuses: mgc.getGameHistory())
        
        if (didPush) {
          mgc.clearOldHistory()
        }
      }
      
    return true
  }
  
  
  
  func pushToHistory(gameKey: String, statuses: [String]) -> Bool {
    NSLog("here in pushtohistory maincon")
    getHistoryVC()!.update(gameKey, statuses: statuses)

    return true
  }
  
  func getHistoryVC() -> HistoryViewController? {
    var historyVC: HistoryViewController? = nil
    
    for vc in viewControllers! {
      if (vc.isKindOfClass(HistoryViewController)) {
        historyVC = vc as? HistoryViewController
      }
    }
    
    return historyVC
  }
}
