//
//  HistoryViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/13/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController, UITableViewDataSource {
  var history: Dictionary<String, [String]> = ["Memory": [], "Set": []]
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    NSLog("\(sender)")
    super.prepareForSegue(segue, sender: sender)
  }
  
  func update(gameKey: String, statuses: [String]) {
    NSLog("here in update historyvc \(statuses)")
    history[gameKey]! += statuses

    tableView.reloadData()
  }
  
  // required
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      let key = sectionWithIdx(section).title
      
      return history[key]!.count
  }

  // required
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let key = sectionWithIdx(indexPath.section).title
      let count = history[key]!.count
      
      var cell = tableView.dequeueReusableCellWithIdentifier("status_row", forIndexPath: indexPath) as UITableViewCell
      
      var label = cell.viewWithTag(1) as UILabel
      label.text = history[key]![count - 1 - indexPath.item]
      
      return cell
  }
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    return 2
  }
  
  override func tableView(tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      
      return sectionWithIdx(section).title
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