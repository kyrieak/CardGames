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
  
  let cardBackImage = UIImage(named: "card_back")!
  let cardBackPattern = UIColor(patternImage: UIImage(named: "card_back")!)
  
  // - MARK: - Properties

  private(set) var themeID: Int
  private(set) var theme: Theme
  
  private var titleFS = UIFontStyle(fontName: "Palatino-BoldItalic", baseSize: 48)
  private var statusFS = UIFontStyle(fontName: "Arial", baseSize: 12)
  
  
  // - MARK: - Initializers
  
  
  required init(theme: Theme) {
    self.themeID = 1
    self.theme = theme
  }
  
  
  // - MARK: - StyleGuide Protocol Functions
  
  
  func setTheme(theme: Theme) {
    self.theme = theme
    self.themeID += 1
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
    case .HeadTitle, .Status, .FooterUIBtn:
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
    default:
      return nil
    }
  }
  
  
  func applyLayerStyle(sel: ViewSelector, views: [UIView]) {
    if (hasLayerStyle(sel)) {
      let style = layerStyle(sel)!
      
      for v in views {
        v.layer.backgroundColor = style.bgColor.CGColor
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
  
  
  // - MARK: - Private Helper Functions
  
  private func headerLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor2,
      borderWidth: CGFloat(1),
      borderColor: UIColor(white: 0.4, alpha: 0.2))
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
    return UILayerStyle(bgColor: cardBackPattern,
      borderWidth: CGFloat(1),
      borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
  
  
  private func cardFrontLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: UIColor.whiteColor(),
      borderWidth: CGFloat(1),
      borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
  
  private func playerBtnLayerStyle() -> UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor4,
      borderWidth: CGFloat(1), borderColor: UIColor.blackColor())
  }

  private func playerBtnFontStyle() -> UIFontStyle {
    var fs = statusFS
    
    fs.color = theme.fontColor4
    
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