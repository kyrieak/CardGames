//
//  HistoryViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/13/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController, UITableViewDelegate {
  
  func update(gameKey: String, statuses: [String]) {
    let ds = tableView.dataSource! as! GameHistoryDataSource

    ds.update(gameKey, statuses: statuses)

    tableView.reloadData()
  }
  
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tag = section
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("toggleSection:")))
  }
  
  
  func rowsInSection(section: Int) -> [UITableViewCell] {
    let rect = tableView.rectForSection(section)
    let indexPaths = tableView.indexPathsForRowsInRect(rect)
    
    return indexPaths.map({(var path) -> UITableViewCell in
      return self.tableView.cellForRowAtIndexPath(path as! NSIndexPath)!
    })
  }
  
  @IBAction func toggleSection(sender: UITapGestureRecognizer) {
    let headerView = sender.view
    
    if (headerView != nil) {
      let section = headerView!.tag
      let rows = rowsInSection(section)
      
      for r in rows {
        r.hidden = !r.hidden
      }
    }
  }
  
  override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    NSLog("\(indexPath.row), \(indexPath.item)")
//    if (indexPath.item == 0) {
//      let rows = rowsInSection(indexPath.row)
//      
//      for row in rows {
//        row.hidden = true
//      }
//    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    NSLog("\(indexPath.row), \(indexPath.item)")
//    if (indexPath.item == 0) {
//      let rows = rowsInSection(indexPath.row)
//      
//      for row in rows {
//        row.hidden = false
//      }
//    }
  }
}