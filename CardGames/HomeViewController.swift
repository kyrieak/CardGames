//
//  GameSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 8/31/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, StyleGuideDelegate {
  let tags = HomeViewController.sectionTags()
  
  @IBOutlet var numPlayersLabel: UILabel!
  @IBOutlet var playBtn: UIButton!
  @IBOutlet var backButton: UIButton!

  var headerView: UIView! {
    return self.view.viewWithTag(tags.header)
  }
  
  var menuView: UIView! {
    return self.view.viewWithTag(tags.menu)
  }
  
  var footerView: UIView! {
    return self.view.viewWithTag(tags.footer)
  }

  var style: StyleGuide = styleGuide
  var themeID = styleGuide.themeID

  
  override func viewWillLayoutSubviews() {
  }
  
  override func viewDidLayoutSubviews() {
//    backButton.hidden = !gameIsActive
    backButton.layer.cornerRadius = 16
    backButton.layer.borderWidth = 2
    backButton.layer.borderColor = style.theme.bgColor2.getShade(0.05).CGColor
    applyStyleToViews()
  }
  
  func setBtnBorder(sender: UIButton) {
    backButton.layer.borderColor = style.theme.bgColor2.getShade(0.05).CGColor
  }
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [self.view]
      case .Header:
        return [headerView]
      case .Footer:
        return [footerView]
      case .Status:
        return [playBtn]
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    let titleTag = 10
    
    switch(sel) {
      case .HeadTitle:
        return [(headerView.viewWithTag(titleTag)! as! UILabel)]
      case .HomeMenuItem:
        return getMenuItems().map{(item: UIButton) -> UILabel in
                                   return item.titleLabel! }
      default:
        return []
    }
  }
  
  
  func getMenuItems() -> [UIButton] {
    return menuView.subviews as! [UIButton]
  }
  
  
  func adjustMenuItemSpacing() {
  }
  
  
  func applyStyleToViews() {
    let layerSelectors: [ViewSelector] = [.Header, .Footer, .Status]
    let textSelectors: [ViewSelector] = [.HomeMenuItem, .HeadTitle]
    
    for sel in textSelectors {
      styleGuide.applyFontStyle(sel, views: viewsForFontStyle(sel))
    }
    
    for sel in layerSelectors {
      styleGuide.applyLayerStyle(sel, views: viewsForLayerStyle(sel))
    }
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
  
  class func sectionTags() -> (header: Int, menu: Int, footer: Int) {
    return (header: 1, menu: 2, footer: 3)
  }
}