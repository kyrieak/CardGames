//
//  PlayerSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/13/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class PlayerSettingController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  let labelTag: Int = 1
  let nameTag: Int  = 2
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var footerView: UIView!
  @IBOutlet var saveBtn: UIButton!

  var playerInfo: [(label: String, name: String)] = []
  var players: [Player] = []

  @IBOutlet var playerTable: UITableView!

  
  override func viewDidLoad() {
    super.viewDidLoad()

    let computedHeight = tableView.rowHeight * CGFloat(players.count)

    tableView.addConstraint(NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(1), constant: computedHeight))
  }
  
  
  override func viewDidLayoutSubviews() {
    tableView.frame.origin.y = calculateTableOriginY()
    footerView.frame.origin.y = tableView.frame.maxY
  }
  
  func calculateTableOriginY() -> CGFloat {
    let halfH = (tableView.frame.height + footerView.frame.height) * 0.5

    return view.bounds.midY - halfH
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return players.count
  }

  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    let player = players[indexPath.item]
    
    let labelField = cell.contentView.viewWithTag(labelTag)! as! UITextField
    let nameField = cell.contentView.viewWithTag(nameTag)! as! UITextField
    
    cell.contentView.tag = indexPath.item
    labelField.text      = player.label
    nameField.text       = player.name
    
    labelField.addTarget(self, action: Selector("validateInput:"), forControlEvents: UIControlEvents.EditingDidEnd)
    labelField.addTarget(self, action: Selector("updateInput:"), forControlEvents: UIControlEvents.EditingChanged)
    nameField.addTarget(self, action: Selector("validateInput:"), forControlEvents: UIControlEvents.EditingDidEnd)
    nameField.addTarget(self, action: Selector("updateInput:"), forControlEvents: UIControlEvents.EditingChanged)
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("playerCell")!
  }
  

  func updateInput(sender: UITextField) {
    let idx = sender.superview!.tag
    
    if (sender.text != nil) {
      let text = sender.text!
      
      if (sender.tag == labelTag) {
        playerInfo[idx].label = text
      } else if (sender.tag == nameTag) {
        playerInfo[idx].name = text
      }
    }
  }
  
  func validateInput(sender: UITextField) {
    let idx = sender.superview!.tag
    var invalidInput = true

    if (sender.text != nil) {
      invalidInput = (sender.text!.characters.count < 1)
    }
    
    if (invalidInput) {
      if (sender.tag == labelTag) {
        sender.text = players[idx].label
      } else if (sender.tag == nameTag) {
        sender.text = players[idx].name
      }
    }
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if (textField.text != nil) {
      if (textField.tag == labelTag) {
        return ((range.location + string.characters.count) < 3)
      } else if (textField.tag == nameTag) {
        return ((range.location + string.characters.count) < 15)
      }
    }
    
    return true
  }
  
  func save() {
    gameSettings.players = players
    
    for (idx, info) in playerInfo.enumerate() {
      let player = players[idx]

      player.setLabel(info.label)
      player.setName(info.name)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier != nil) {
      let sid = segue.identifier!

      switch(sid) {
        case "unwindToNewGame":
          self.save()
        default:
          super.prepareForSegue(segue, sender: sender)
      }
    } else {
      super.prepareForSegue(segue, sender: sender)
    }
  }
  
}