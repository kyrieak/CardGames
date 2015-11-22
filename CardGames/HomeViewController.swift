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
  typealias sg = SGStyleGuide
  
  lazy var headerView: UIView = { return self.view.viewWithTag(1)! }()
  lazy var menuView:   UIView = { return self.view.viewWithTag(2)! }()
  lazy var footerView: UIView = { return self.view.viewWithTag(3)! }()
  lazy var backBtn:  UIButton = { return self.view.viewWithTag(12)! as! UIButton }()
  lazy var playBtn:  UIButton = { return self.view.viewWithTag(24)! as! UIButton }()
  lazy var ackBtn: UIButton   = { return self.footerView.viewWithTag(31)! as! UIButton }()

  var styleGuide: SGStyleGuide = appGlobals.styleGuide
  var themeID: Int?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
  }

  
  @IBAction func prepareUnwind(segue: UIStoryboardSegue) {
    backBtn.hidden = !appGlobals.gameIsActive

    if (themeID != styleGuide.themeID) {
      applyStyleToViews()
    }
  }
  
  
  override func viewDidLayoutSubviews() {
    if (themeID != styleGuide.themeID) {
      applyStyleToViews()
    }
    
    if (!backBtn.hidden) {
      backBtn.hidden = !appGlobals.gameIsActive
    }
  }
  
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Portrait
  }
  
  func setBtnBorder(sender: UIButton) {
    backBtn.layer.borderColor = styleGuide.theme.bgColor2.getShade(0.05).CGColor
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
    let titleTag = 11
    
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
  
  
  func viewsForBtnStyle(sel: ViewSelector) -> [UIButton] {
    return []
  }
  
  
  func getMenuItems() -> [UIButton] {
    return menuView.subviews as! [UIButton]
  }
  
  
  func adjustMenuItemSpacing() {
  }
  
  
  
  func applyStyleToViews() {
    let layerSelectors: [ViewSelector] = [.MainContent, .Header, .Footer, .Status]
    let textSelectors: [ViewSelector] = [.HomeMenuItem, .HeadTitle]
    
    for sel in textSelectors {
      styleGuide.applyFontStyle(sel, views: viewsForFontStyle(sel))
    }
    
    for sel in layerSelectors {
      styleGuide.applyLayerStyle(sel, views: viewsForLayerStyle(sel))
    }

    styleGuide.applyBtnStyle(.NavPill, views: [backBtn])

    backBtn.setTitleShadowColor(styleGuide.theme.shadeColor1, forState: .Normal)
    ackBtn.setTitleColor(styleGuide.theme.fontColor2, forState: .Normal)
    
    menuView.backgroundColor = styleGuide.theme.bgLight
    themeID = styleGuide.themeID
  }
  
  
  @IBAction func respondToSwipe(gesture: UISwipeGestureRecognizer) {    
    self.returnToGame()
  }
  
  @IBAction func returnToGame() {
    if (appGlobals.gameIsActive) {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}