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
  
  var newGameSettings = GameSettings(players: appGlobals.gameSettings.players)
  
  lazy var tableView:  UITableView! = { return self.view.viewWithTag(1)! as! UITableView }()
  lazy var footerView: UIView!      = { return self.view.viewWithTag(2)! }()
  lazy var saveBtn:    UIButton!    = { return self.view.viewWithTag(21)! as! UIButton }()

  var players: [Player] { return newGameSettings.players }
  var playerInfo: [(label: String, name: String)] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playerInfo = players.map{(p: Player) -> (label: String, name: String) in
      return (label: p.label, name: p.name)
    }

    let computedHeight = tableView.rowHeight * CGFloat(players.count) + 44

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
  
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Edit Player Names Here:"
  }
  
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    
    header.textLabel?.textColor = UIColor(white: 0.3, alpha: 1.0)
    header.textLabel?.font = UIFont.systemFontOfSize(18)
    
    view.backgroundColor   = UIColor(white: 0.9, alpha: 1.0)
    view.layer.borderColor = UIColor(white: 0.8, alpha: 1.0).CGColor
    view.layer.borderWidth = 1
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
    NSLog("chekcing should change \(textField)")
    if (textField.text != nil) {
      if (textField.tag == labelTag) {
        NSLog("is label")
        return ((range.location + string.characters.count) < 3)
      } else if (textField.tag == nameTag) {
        NSLog("is name")
        return ((range.location + string.characters.count) < 15)
      }
    }
    
    return true
  }
  
  func saveSettings() {
    appGlobals.gameSettings = newGameSettings
    NSLog("\(newGameSettings.options)")
    for (idx, info) in playerInfo.enumerate() {
      let player = players[idx]

      player.setLabel(info.label)
      player.setName(info.name)
    }
  }
  
  @IBAction func respondToTap(sender: UITapGestureRecognizer) {
    let pt = sender.locationInView(nil)

    let insideTable = CGRectContainsPoint(tableView.frame, pt)
    let insideFooter = CGRectContainsPoint(footerView.frame, pt)
    
    if (!(insideTable || insideFooter)) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  @IBAction func startNewGame(sender: UIButton) {
    self.saveSettings()

    if (appGlobals.gameIsActive) {
      self.performSegueWithIdentifier("unwindToNewGame", sender: self)
    } else {
      self.performSegueWithIdentifier("segueToNewGame", sender: self)
    }
  }
}