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
  var settings = defaultSettings

  var options: GameOptions {
    return settings.options
  }

  @IBOutlet var contentView: UIView!
  @IBOutlet var colorSwitch: UISwitch!
  @IBOutlet var shapeSwitch: UISwitch!
  @IBOutlet var shadingSwitch: UISwitch!
  @IBOutlet var playerCountLabel: UILabel!

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    NSLog("segue prepared")
    if ((sender as? SetGameController) != nil) {
      let vc = sender as! SetGameController
      
      settings = vc.game.settings
    }
  }
  
  override func viewWillLayoutSubviews() {
    colorSwitch.setOn(options.colorsOn, animated: false)
    shapeSwitch.setOn(options.shapesOn, animated: false)
    shadingSwitch.setOn(options.shadingOn, animated: false)
  }
  
  @IBAction func colorSwitchAction(sender: UISwitch) {
    settings.options.colorsOn = sender.on
  }

  @IBAction func shapeSwitchAction(sender: UISwitch) {
    settings.options.shapesOn = sender.on
  }
  
  @IBAction func patternSwitchAction(sender: UISwitch) {
    settings.options.shadingOn = sender.on
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
  
  @IBAction func prepareBackUnwind(segue: UIStoryboardSegue) {
    NSLog("back to here")
  }
  
}