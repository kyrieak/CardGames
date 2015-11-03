//
//  ScoresController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 11/2/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class ScoresController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var stats = [Player: (set: Int, miss: Int, score: Int)]()
  var tableView: UITableView?

  var players: [Player] {
    return appGlobals.gameSettings.players
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.tableView = tableView
    let computedHeight = tableView.rowHeight * CGFloat(players.count) + 28
    
    tableView.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(1), constant: computedHeight))
    
    return players.count
  }
  
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return tableView.dequeueReusableCellWithIdentifier("scoreHeader")
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    let player = players[indexPath.item]
    let pStats = stats[player]!
    NSLog("player \(player) \(pStats)")
    
    (cell.viewWithTag(1)! as! UILabel).text = player.label
    (cell.viewWithTag(2)! as! UILabel).text = player.name
    (cell.viewWithTag(3)! as! UILabel).text = "\(pStats.set)"
    (cell.viewWithTag(4)! as! UILabel).text = "\(pStats.miss)"
    (cell.viewWithTag(5)! as! UILabel).text = "\(pStats.score)"
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("scoreRow")!
  }
  
  @IBAction func closeScores(sender: UITapGestureRecognizer) {
    let pt = sender.locationInView(nil)
    
    if (!CGRectContainsPoint(tableView!.frame, pt)) {
      self.performSegueWithIdentifier("unwindToGame", sender: self)
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}