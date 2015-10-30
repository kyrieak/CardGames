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
  let cardBackImage = UIImage(named: "card_back")!
  let cardBackPattern = UIColor(patternImage: UIImage(named: "card_back")!)
  
  // - MARK: - Properties

  var themeID: Int? { return self.theme.id }
  
  private(set) var theme: Theme
  
  private var titleFS  = UIFontStyle(fontName: "Palatino-BoldItalic", baseSize: 48)
  private var menuFS   = UIFontStyle(fontName: "Palatino", baseSize: 18)
  private var statusFS = UIFontStyle(fontName: "Arial", baseSize: 18)
  
  // - MARK: - Initializers
  

  required init(theme: Theme) {
    self.theme = theme
    self.screenDims = deviceInfo.screenDims

    setFontSizes(screenDims.min)
  }
  
  
  init(theme: Theme, screenSize: CGSize) {
    self.theme = theme
    self.screenDims = screenSize.getMinMaxDims()
  }
  
  
  // - MARK: - StyleGuide Protocol Functions
  
  
  func setFontSizes(_minScreenDim: CGFloat) {
    switch(_minScreenDim) {
      case _ where (_minScreenDim < 350):
        titleFS.baseSize  = 36
        statusFS.baseSize = 12
        menuFS.baseSize   = 20
      case _ where (_minScreenDim > 700):
        titleFS.baseSize  = 64
        statusFS.baseSize = 24
        menuFS.baseSize   = 32
      default:
        titleFS.baseSize  = 48
        statusFS.baseSize = 36
        menuFS.baseSize   = 24
    }
  }
  
  
  func setTheme(theme: Theme) {
    self.theme = theme
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
    case .HeadTitle, .Status, .FooterUIBtn, .HomeMenuItem:
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
      return titleFontStyle()
    case .Status:
      return statusFontStyle()
    case .FooterUIBtn:
      return playerBtnFontStyle()
    case .HomeMenuItem:
      return menuFS
    default:
      return nil
    }
  }
  
  
  func applyLayerStyle(sel: ViewSelector, views: [UIView]) {
    if (hasLayerStyle(sel)) {
      let style = layerStyle(sel)!
      
      for v in views {
        if (v.backgroundColor != style.bgColor) {
          v.backgroundColor = style.bgColor
        }
        
        v.layer.borderColor     = style.borderColor.CGColor
        v.layer.borderWidth     = style.borderWidth
      }
    }
  }
  
    
  func applyFontStyle(sel: ViewSelector, views: [UILabel]) {
    if (hasFontStyle(sel)) {
      let style = fontStyle(sel)!
      
      for v in views {
        v.font = style.font
        v.textColor = style.color
      }
    }
  }
    
  func applyBtnFontStyle(sel: ViewSelector, views: [UIButton]) {
    if (hasFontStyle(sel)) {
      let style = fontStyle(sel)!
      
      for btn in views {
        btn.titleLabel?.font = style.font
        btn.setTitleColor(style.color, forState: UIControlState.Normal)
//        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
      }
    }
  }
  
  
  // - MARK: - Private Helper Functions
  
  private func headerLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor2,
                          borderWidth: CGFloat(1),
                            borderColor: theme.bgColor2.getShade(-0.15))
//    return UILayerStyle(bgColor: theme.bgColor2,
//      borderWidth: CGFloat(1),
//      borderColor: UIColor(white: 0.8, alpha: 1.0))
  }
  
  
//  private func homeMenuFont() -> UIFontStyle {
//    return UIFontStyle(fontName: titleFS.fontName, baseSize: )
//  }
  
  class func statusLayerStyle(inout style: UILayerStyle, theme: Theme) {
    
  }
  
  private func statusLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor3,
      borderWidth: CGFloat(1),
      borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
  
  
  private func contentLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor1)
  }
  
  
  private func cardBackLayerStyle() -> UILayerStyle {
    let cardBg: UIColor = ((theme.patternColor == nil) ? cardBackPattern : theme.patternColor!)
    
    return UILayerStyle(bgColor: cardBg,
                          borderWidth: CGFloat(1),
                            borderColor: UIColor(white: 0.4, alpha: 0.2))
  }

  
  private func cardFrontLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: UIColor.whiteColor(),
                        borderWidth: CGFloat(1),
                        borderColor: UIColor(white: 0.9, alpha: 1.0))
  }
  
  
  private func playerBtnLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor1,
      borderWidth: CGFloat(1), borderColor: theme.bgColor1.getShade(-0.15))
  }

  private func playerBtnFontStyle() -> UIFontStyle {
    var fs = statusFS
    
    fs.color = theme.fontColor4
    fs.baseSize = 22
    
    return fs
  }
  
  private func titleFontStyle() -> UIFontStyle {
    if (screenDims.min < 400) {
      titleFS.baseSize = 40
    } else if (screenDims.min > 500) {
      titleFS.baseSize = 64
    }
    titleFS.color = theme.fontColor2
    
    return titleFS
  }
  
  
  private func statusFontStyle() -> UIFontStyle {
    statusFS.color = theme.fontColor3
    
    return statusFS
  }
}