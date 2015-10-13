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
  var settings = GameSettings(numPlayers: 2)

  @IBOutlet var contentView: UIView!
  @IBOutlet var colorSwitch: UISwitch!
  @IBOutlet var shapeSwitch: UISwitch!
  @IBOutlet var patternSwitch: UISwitch!
  @IBOutlet var playerCountLabel: UILabel!

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    settings.colorsOn = false
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    NSLog("segue prepared")
    if ((sender as? SetGameController) != nil) {
      let vc = sender as! SetGameController
      
      settings = vc.game.settings
    }
  }
  
  override func viewWillLayoutSubviews() {
    colorSwitch.setOn(settings.colorsOn, animated: false)
    shapeSwitch.setOn(settings.shapesOn, animated: false)
    patternSwitch.setOn(settings.patternsOn, animated: false)
  }
  
  @IBAction func colorSwitchAction(sender: UISwitch) {
    settings.colorsOn = sender.on
  }

  @IBAction func shapeSwitchAction(sender: UISwitch) {
    settings.shapesOn = sender.on
  }
  
  @IBAction func patternSwitchAction(sender: UISwitch) {
    settings.patternsOn = sender.on
  }
  
  @IBAction func stepperTapAction(sender: UIStepper) {
    let m = Int(sender.value)
    
    playerCountLabel.text = "\(m)"
  }
  
  @IBAction func respondToTap(sender: UITapGestureRecognizer) {
    let pt = sender.locationInView(nil)
    let cFrame = contentView.frame
    
    if ((pt.x < cFrame.minX) || (pt.x > cFrame.maxX) ||
        (pt.y < cFrame.minY) || (pt.y > cFrame.maxY)) {

      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
}