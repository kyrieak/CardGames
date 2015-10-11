//
//  Style.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/11/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


struct UILayerStyle {
  var bgColor: UIColor
  var borderColor: UIColor
  var borderWidth: CGFloat
  
  init(bgColor: UIColor, borderWidth: CGFloat, borderColor: UIColor) {
    self.bgColor     = bgColor
    self.borderWidth = borderWidth
    self.borderColor = borderColor
  }
  
  init() {
    self.init(bgColor: UIColor.clearColor(),
                borderWidth: CGFloat(0),
                  borderColor: UIColor.clearColor())
  }
  
  init(bgColor: UIColor) {
    self.init(bgColor: bgColor,
                borderWidth: CGFloat(0),
                  borderColor: UIColor.clearColor())
  }
}


struct UIFontStyle {
  var fontName: String
  var baseSize: CGFloat
  var color: UIColor
  
  var font: UIFont {
    return UIFont(name: self.fontName, size: self.baseSize)!
  }
  
  init(fontName: String, baseSize: CGFloat, color: UIColor) {
    self.fontName = fontName
    self.baseSize = baseSize
    self.color    = color
  }
  
  init(fontName: String, baseSize: CGFloat) {
    self.fontName = fontName
    self.baseSize = baseSize
    self.color    = UIColor.blackColor()
  }
  
  func applyStyle(view: UILabel) {
    view.font = font
    view.textColor = color
  }
}


class SG {
  private(set) var themeID: Int = 1
  private(set) var theme = Theme.grayscale()
  
  let cardBackImage = UIImage(named: "card_back")!
  let cardBackPattern = UIColor(patternImage: UIImage(named: "card_back")!)
  
  private var titleFS = UIFontStyle(fontName: "Palatino-BoldItalic", baseSize: 48)
  private var statusFS = UIFontStyle(fontName: "Arial", baseSize: 12)
  
  
  func hasLayerStyle(component: ViewElement) -> Bool {
    switch(component) {
      case .Header, .Footer, .CardFront, .CardBack, .MainContent, .Status:
        return true
      default:
        return false
    }
  }
  
  func hasFontStyle(elem: ViewElement) -> Bool {
    switch(elem) {
      case .HeadTitle, .Status:
        return true
      default:
        return false
    }
  }
  
  func layerStyle(type: ViewElement) -> UILayerStyle? {
    switch(type) {
      case .MainContent:
        return styleGuide.contentLayerStyle()
      case .Header, .Footer:
        return styleGuide.headerLayerStyle()
      case .Status:
        return styleGuide.statusLayerStyle()
      case .CardFront:
        return styleGuide.cardFrontLayerStyle()
      case .CardBack:
        return styleGuide.cardBackLayerStyle()
      default:
        return nil
    }
  }
  
  func fontStyle(elem: ViewElement) -> UIFontStyle? {
    switch(elem) {
      case .HeadTitle:
        return titleFontStyle()
      case .Status:
        return statusFontStyle()
      default:
        return nil
    }
  }

  func applyLayerStyle(elem: ViewElement, views: [UIView]) {
    if (hasLayerStyle(elem)) {
      let style = layerStyle(elem)!
      
      for v in views {
        v.layer.backgroundColor = style.bgColor.CGColor
        v.layer.borderColor     = style.borderColor.CGColor
        v.layer.borderWidth     = style.borderWidth
      }
    }
  }
  
  func applyFontStyle(elem: ViewElement, views: [UILabel]) {
    if (hasFontStyle(elem)) {
      let style = fontStyle(elem)!
      
      for v in views {
        v.font = style.font
        v.textColor = style.color
      }
    }
  }
  
  
  func setTheme(theme: Theme) {
    self.theme = theme
    self.themeID += 1
  }
  
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
    return UILayerStyle(bgColor: theme.bgColor1,
                          borderWidth: CGFloat(0),
                            borderColor: UIColor.clearColor())
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
  
  private func titleFontStyle() -> UIFontStyle {
    var style = titleFS

    style.color = theme.fontColor2

    return style
  }
  
  private func statusFontStyle() -> UIFontStyle {
    var style = statusFS

    style.color = theme.fontColor3
    
    return style
  }
}

enum ViewElement {
  case MainContent,
       Header,
       Footer,
       Status,
       CardBack,
       CardFront,
       HeadTitle
}

enum ThemeLabel {
  case green, grayscale, unlabeled
}

class Theme {
  var bgColor1, bgColor2, bgColor3: UIColor
  var fontColor2, fontColor3: UIColor
  
  init() {
    bgColor1   = UIColor.whiteColor()
    bgColor2   = UIColor.whiteColor()
    bgColor3   = UIColor.whiteColor()
    
    fontColor2 = UIColor.blackColor()
    fontColor3 = UIColor.blackColor()
  }
  
  func thumbnail() -> [UIColor] {
    return [bgColor1, bgColor2, bgColor3, fontColor3]
  }
  
  class func grayscale() -> Theme {
    let _theme = Theme()
    
    _theme.bgColor1 = UIColor(white: 0.7, alpha: 1.0)
    _theme.bgColor2 = UIColor(white: 0.9, alpha: 1.0)
    _theme.bgColor3 = UIColor(white: 0.8, alpha: 1.0)

    return _theme
  }
  
  class func green() -> Theme {
    let _theme = Theme()
    
    _theme.bgColor1   = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    _theme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    _theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.71, alpha: 1.0)
    
    _theme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    _theme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)

    return _theme
  }
  
  class func all() -> [Theme] {
    return [Theme.green(), Theme.grayscale()]
  }
}

var styleGuide = SG()
