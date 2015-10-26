//
//  GameSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 8/31/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
  @IBOutlet var numPlayersLabel: UILabel!
  @IBOutlet var playBtn: UIButton!
  @IBOutlet var backButton: UIButton!

  var style = styleGuide
  var themeID = styleGuide.themeID

  
  override func viewDidLayoutSubviews() {
//    backButton.hidden = !gameIsActive
    backButton.layer.cornerRadius = 16
    backButton.layer.borderWidth = 2
    backButton.layer.borderColor = style.theme.bgColor2.getShade(0.05).CGColor
  }
  
  func setBtnBorder(sender: UIButton) {
    backButton.layer.borderColor = style.theme.bgColor2.getShade(0.05).CGColor
  }
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [self.view]
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    return []
  }
  
  func applyStyleToViews() {
    //
  }
  
  
  @IBAction func respondToSwipe(gesture: UISwipeGestureRecognizer) {
    NSLog("responding to swipe")
    
    self.returnToGame()
  }
  
  @IBAction func returnToGame() {
    if (gameIsActive) {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}