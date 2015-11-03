//
//  SGSettingsController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/9/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class GameSettingsController: UIViewController {
  var options = appGlobals.gameOptions

  lazy var contentView:   UIView    = { return self.view.viewWithTag(1)! }()
  lazy var playerCtLabel: UILabel   = { return self.view.viewWithTag(15)! as! UILabel }()
  lazy var playerStepper: UIStepper = { return self.view.viewWithTag(14)! as! UIStepper }()
  
  var header:  UIView { return self.view.viewWithTag(10)! }
  var saveBtn: UIView { return self.view.viewWithTag(30)! }

  var colorSwitch:   UISwitch { return self.view.viewWithTag(11)! as! UISwitch }
  var shapeSwitch:   UISwitch { return self.view.viewWithTag(12)! as! UISwitch }
  var shadingSwitch: UISwitch { return self.view.viewWithTag(13)! as! UISwitch }
  
  
  var numPlayers: Int { return Int(playerStepper.value) }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
  }

  override func viewDidLoad() {
    setOptions(appGlobals.gameOptions)
    setPlayerCt(appGlobals.numPlayers)
    
    setBorderAttributes()
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "modalToPlayers") {
      let dvc = segue.destinationViewController as! PlayerSettingController
      
      if (appGlobals.gameSettings.numPlayers != numPlayers) {
        dvc.newGameSettings.players = Player.makeNumberedPlayers(numPlayers)
      }
      
      dvc.newGameSettings.options = options
    }
  }
  
  

  @IBAction func colorSwitchAction(sender: UISwitch) {
    options.colorsOn = sender.on
  }

  
  @IBAction func shapeSwitchAction(sender: UISwitch) {
    options.shapesOn = sender.on
  }
  
  
  @IBAction func patternSwitchAction(sender: UISwitch) {
    options.shadingOn = sender.on
  }
  
  
  @IBAction func stepperTapAction(sender: UIStepper) {
    playerCtLabel.text = "\(Int(sender.value))"
  }
  
  
  @IBAction func respondToTap(sender: UITapGestureRecognizer) {
    let pt = sender.locationInView(nil)
    
    if (!CGRectContainsPoint(contentView.frame, pt)) {
      self.performSegueWithIdentifier("unwindBack", sender: self)
    }
  }
  
  func setBorderAttributes() {
//    playerStepper.layer.cornerRadius = 4

    contentView.layer.borderWidth   = 0.8
    header.layer.borderWidth        = 1
    playerStepper.layer.borderWidth = 1
    saveBtn.layer.borderWidth       = 1
    
    contentView.layer.borderColor   = UIColor(white: 0.8, alpha: 1.0).CGColor
    header.layer.borderColor        = contentView.layer.borderColor
    playerStepper.layer.borderColor = UIColor(white: 0.7, alpha: 1.0).CGColor
    saveBtn.layer.borderColor       = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0).CGColor
  }
  
  func setOptions(opt: GameOptions) {
    colorSwitch.setOn(opt.colorsOn, animated: false)
    shapeSwitch.setOn(opt.shapesOn, animated: false)
    shadingSwitch.setOn(opt.shadingOn, animated: false)
  }
  
  func setPlayerCt(num: Int) {
    playerCtLabel.text  = "\(num)"
    playerStepper.value = Double(num)
  }
}