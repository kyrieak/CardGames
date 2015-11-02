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

  lazy var contentView:     UIView    = { return self.view.viewWithTag(1)! }()
  lazy var colorSwitch:     UISwitch  = { return self.view.viewWithTag(11)! as! UISwitch }()
  lazy var shapeSwitch:     UISwitch  = { return self.view.viewWithTag(12)! as! UISwitch }()
  lazy var shadingSwitch:   UISwitch  = { return self.view.viewWithTag(13)! as! UISwitch }()
  lazy var playerCtStepper: UIStepper = { return self.view.viewWithTag(14)! as! UIStepper }()
  lazy var playerCtLabel :  UILabel   = { return self.view.viewWithTag(15)! as! UILabel }()
  /*
  @IBOutlet var contentView: UIView!
  @IBOutlet var colorSwitch: UISwitch!
  @IBOutlet var shapeSwitch: UISwitch!
  @IBOutlet var shadingSwitch: UISwitch!
  @IBOutlet var playerCtStepper: UIStepper!
  @IBOutlet var playerCtLabel: UILabel!
*/
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "modalToPlayers") {
      let dvc = segue.destinationViewController as! PlayerSettingController
      let numPlayers = Int(playerCtStepper.value)
    
      if (appGlobals.gameSettings.numPlayers != numPlayers) {
        NSLog("did get here \(numPlayers)")
        dvc.newGameSettings.players = Player.makeNumberedPlayers(numPlayers)
      }
      
      dvc.newGameSettings.options = options
    }
  }
  
  override func viewDidLoad() {
    colorSwitch.setOn(options.colorsOn, animated: false)
    shapeSwitch.setOn(options.shapesOn, animated: false)
    shadingSwitch.setOn(options.shadingOn, animated: false)
    
    playerCtLabel.text    = "\(appGlobals.numPlayers)"
    playerCtStepper.value = Double(appGlobals.numPlayers)
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
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  @IBAction func prepareBackUnwind(segue: UIStoryboardSegue) {
    NSLog("Game Settings Controller is prepareForBackUnwinding")
  }
}