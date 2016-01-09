//
//  SGStyleGuide.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/12/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SGStyleGuide: StyleGuide {
  // - MARK: - Constants
  
  let screenDims: (min: CGFloat, max: CGFloat)
  let cardBackImage = UIImage(named: "cb_2")!
  let cardBackPattern = UIColor(patternImage: UIImage(named: "cb_2")!)
  
  // - MARK: - Properties

  var themeID: Int? { return self.theme.id }
  
  private(set) var theme: Theme
  
  private var titleFS     = UIFontStyle(fontName: "Palatino-BoldItalic")
  private var menuFS      = UIFontStyle(fontName: "Palatino")
  private var navPillFS   = UIFontStyle(fontName: "Palatino")
  private var statusFS    = UIFontStyle(fontName: "Arial")
  private var playerBtnFS = UIFontStyle(fontName: "Arial")
  
  // - MARK: - Initializers
  

  required init(theme: Theme) {
    self.theme = theme
    self.screenDims = deviceInfo.screenDims
    
    setFontSizes()
    setFontColors()
  }
  
  
  init(theme: Theme, screenSize: CGSize) {
    self.theme      = theme
    self.screenDims = screenSize.getMinMaxDims()
    
    setFontSizes()
    setFontColors()
  }
  
  
  // - MARK: - StyleGuide Protocol Functions
  
  
  func setTheme(theme: Theme) {
    self.theme = theme
    
    setFontColors()
  }
  
  func setFontColors() {
    menuFS.color      = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)
    playerBtnFS.color = theme.fontColor1
    titleFS.color     = theme.fontColor2
    navPillFS.color   = theme.fontColor2
    statusFS.color    = theme.fontColor3
  }
  
  
  private func setFontSizes() {
    if (deviceInfo.isTablet) {
      setFontSizesForTablet()
    } else if (screenDims.min < 350) {
      setFontSizesForSmallMobile()
    } else {
      setFontSizesForMobile()
    }
  }

  
  private func setFontSizesForSmallMobile() {
    titleFS.size     = 35
    menuFS.size      = 20
    navPillFS.size   = 20
    playerBtnFS.size = 22
    statusFS.size    = 14
  }

  
  private func setFontSizesForMobile() {
    titleFS.size     = 48
    menuFS.size      = 24
    playerBtnFS.size = 22
    navPillFS.size   = 20
    statusFS.size    = 18
  }

  
  private func setFontSizesForTablet() {
    titleFS.size     = 64
    menuFS.size      = 32
    playerBtnFS.size = 32
    statusFS.size    = 24
    navPillFS.size   = 24
  }

  
  func hasLayerStyle(sel: ViewSelector) -> Bool {
    switch(sel) {
      case .Header, .Footer, .CardFront, .CardBack, .MainContent, .Status, .FooterUIBtn:
        return true
      default:
        return false
    }
  }
  
  
  func hasFontStyle(sel: ViewSelector) -> Bool {
    switch(sel) {
      case .HeadTitle, .Status, .FooterUIBtn, .HomeMenuItem, .NavPill:
        return true
      default:
        return false
    }
  }
  
  
  func layerStyle(sel: ViewSelector) -> UILayerStyle? {
    switch(sel) {
      case .MainContent:
        return contentLayerStyle()
      case .Header, .Footer:
        return headerLayerStyle()
      case .Status:
        return statusLayerStyle()
      case .CardFront:
        return cardFrontLayerStyle()
      case .CardBack:
        return cardBackLayerStyle()
      case .FooterUIBtn:
        return playerBtnLayerStyle()
      default:
        return nil
    }
  }
  
  
  func fontStyle(sel: ViewSelector) -> UIFontStyle? {
    switch(sel) {
    case .HeadTitle:
      return titleFS
    case .NavPill:
      return navPillFS
    case .Status:
      return statusFS
    case .FooterUIBtn:
      return playerBtnFS
    case .HomeMenuItem:
      return menuFS
    default:
      return nil
    }
  }
  
  
  func applyLayerStyle(sel: ViewSelector, var view: UIView) {
    if (hasLayerStyle(sel)) {
      let style = layerStyle(sel)!

      style.applyTo(&view)
    }
  }
  
  func applyLayerStyle(sel: ViewSelector, views: [UIView]) {
    if (hasLayerStyle(sel)) {
      let style = layerStyle(sel)!
      
      for var v in views {
        style.applyTo(&v)
      }
    }
  }
  
    
  func applyFontStyle(sel: ViewSelector, views: [UILabel]) {
    if (hasFontStyle(sel)) {
      let style = fontStyle(sel)!
      
      for v in views {
        v.font      = style.font
        v.textColor = style.color
      }
    }
  }
    
  func applyBtnStyle(sel: ViewSelector, views: [UIButton]) {
    applyLayerStyle(sel, views: views)
    
    if (hasFontStyle(sel)) {
      let style = fontStyle(sel)!

      for btn in views {
        btn.titleLabel?.font = style.font
        btn.setTitleColor(style.color, forState: UIControlState.Normal)
      }
    }
  }
  
  func linkTextAttributes(link: NSURL) -> [String: AnyObject] {
    return [NSLinkAttributeName: link, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
  }
  
  
  // - MARK: - Private Helper Functions
  
  private func headerLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor2,
                          borderWidth: CGFloat(1),
                            borderColor: theme.bgColor2.getShade(-0.15))
  }
  
  
  private func statusLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor3,
      borderWidth: CGFloat(1),
      borderColor: UIColor(white: 0.4, alpha: theme.shadeAlpha))
  }
  
  
  private func contentLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgBase)
  }
  
  
  private func cardBackLayerStyle() -> UILayerStyle {
    let cardBg: UIColor = ((theme.patternColor == nil) ? cardBackPattern : theme.patternColor!)
    
    return UILayerStyle(bgColor: cardBg,
                          borderWidth: 1.0,
                            borderColor: UIColor(white: 0.4, alpha: theme.shadeAlpha))
  }

  
  private func cardFrontLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: UIColor.whiteColor(),
                        borderWidth: theme.shadeWidth,
//                        borderColor: UIColor(white: 0.8, alpha: theme.shadeAlpha))
      borderColor: theme.shadeColor1)
  }
  
  
  private func playerBtnLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgBase,
                        borderWidth: CGFloat(1),
                        borderColor: theme.bgBase.getShade(-0.15))
  }

  private func playerBtnFontStyle() -> UIFontStyle {
    var fs = playerBtnFS
    
    fs.color = theme.fontColor1
    
    return fs
  }
  
  private func titleFontStyle() -> UIFontStyle {
    titleFS.color = theme.fontColor2
    
    return titleFS
  }
  
  
  private func statusFontStyle() -> UIFontStyle {
    statusFS.color = theme.fontColor3
    
    return statusFS
  }
}