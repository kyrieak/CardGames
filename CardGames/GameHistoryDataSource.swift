//
//  GameHistoryDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/14/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class GameHistoryDataSource: NSObject, UITableViewDataSource {
  let keys = ["Memory": 0, "Set": 1]
  var history: Dictionary<String, [String]> = ["Memory": [], "Set": []]
  
  func update(gameKey: String, statuses: [String]) {
    history[gameKey]! += statuses
  }
  
  // required
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      let key = sectionWithIdx(section).title
      
      return history[key]!.count
  }
  
  // required
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let key = sectionWithIdx(indexPath.section).title
      let count = history[key]!.count
      
      var cell = tableView.dequeueReusableCellWithIdentifier("status_row", forIndexPath: indexPath) as! UITableViewCell
      var tv = UITableView(frame: CGRectZero)
      tv.dataSource = StatusListDataSource()
      var label = cell.viewWithTag(1) as! UILabel
      label.text = history[key]![count - 1 - indexPath.item]
      
      return cell
  }


  
  func sectionWithIdx(idx: Int) -> (idx: Int, title: String) {
    switch(idx) {
    case 0:
      return (idx: 0, title: "Memory")
    default:
      return (idx: 1, title: "Set")
    }
  }
}