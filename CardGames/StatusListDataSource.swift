//
//  StatusListDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 5/20/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class StatusListDataSource: NSObject, UITableViewDataSource {
  var statuses: [String] = []
  
  func update(gameKey: String, statuses: [String]) {
    self.statuses += statuses
  }
  
  // required
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return statuses.count
  }
  
  // required
  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let count = statuses.count
      
      var cell = tableView.dequeueReusableCellWithIdentifier("status_row", forIndexPath: indexPath) as! UITableViewCell
      
      var label = cell.viewWithTag(1) as! UILabel
      label.text = statuses[count - 1 - indexPath.item]
      
      return cell
  }
}