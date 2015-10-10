//
//  Style.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/11/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit


class UILayerStyle {
  var bgColor: UIColor
  var borderColor: UIColor
  var borderWidth: CGFloat
  
  init(bgColor: UIColor, borderWidth: CGFloat, borderColor: UIColor) {
    self.bgColor     = bgColor
    self.borderWidth = borderWidth
    self.borderColor = borderColor
  }
  
  convenience init() {
    self.init(bgColor: UIColor.clearColor(),
                borderWidth: CGFloat(0),
                  borderColor: UIColor.clearColor())
  }
  
  convenience init(bgColor: UIColor) {
    self.init(bgColor: bgColor,
                borderWidth: CGFloat(0),
                  borderColor: UIColor.clearColor())
  }
  
  func apply(view: UIView) {
    view.layer.backgroundColor = bgColor.CGColor
    view.layer.borderColor     = borderColor.CGColor
    view.layer.borderWidth     = borderWidth
  }
}

class UIBtnStyle {
  var layerStyle: UILayerStyle
  var font: UIFont
  var fontColor: UIColor
  
  var bgColor: UIColor {
    return layerStyle.bgColor
  }
  
  var borderWidth: CGFloat {
    return layerStyle.borderWidth
  }

  var borderColor: UIColor {
    return layerStyle.borderColor
  }
  
  init(layerStyle: UILayerStyle, font: UIFont, fontColor: UIColor) {
    self.layerStyle = layerStyle
    self.font       = font
    self.fontColor  = fontColor
  }
}

class UIFontSet {
  var baseFont: UIFont
  var headerFont: UIFont
  var color = UIColor.blackColor()
  
  var h1: UIFont {
    return headerFont
  }
  
  var h2: UIFont {
    return headerFont.fontWithSize(headerFont.pointSize * CGFloat(0.66))
  }
  
  init(fontName: String, headerFontName: String, baseSize: CGFloat) {
    let h1Size = baseSize * CGFloat(1.5)
    let font  = UIFont(name: fontName, size: baseSize)
    let hFont = UIFont(name: headerFontName, size: h1Size)

    self.baseFont   = (font != nil)  ? font! : UIFont.systemFontOfSize(baseSize)
    self.headerFont = (hFont != nil) ? hFont! : baseFont.fontWithSize(h1Size)
  }
  
  init() {
    let baseSize = CGFloat(12)

    self.baseFont = UIFont.systemFontOfSize(baseSize)
    self.headerFont = UIFont.systemFontOfSize(baseSize * CGFloat(2.25))
  }
  
  convenience init(fontName: String, headerFontName: String) {
    self.init(fontName: fontName,
                headerFontName: headerFontName,
                  baseSize: CGFloat(12))
  }

  convenience init(fontName: String) {
    self.init(fontName: fontName,
                headerFontName: fontName,
                  baseSize: CGFloat(12))
  }
  
  func setH1Size(size: CGFloat) {
    headerFont = headerFont.fontWithSize(size)
  }
  
  func applyFont(label: UILabel, h: Int?) {
    if (h == 1) {
      label.font = h1
    } else if (h == 2) {
      label.font = h2
    } else {
      label.font = baseFont
    }
    
    label.textColor = color
  }
}



class SG {
  var theme = Theme.green()
  let cardBackImage = UIImage(named: "card_back")!
  let cardBackPattern = UIColor(patternImage: UIImage(named: "card_back")!)
  
  let headerFontSet = UIFontSet(fontName: "Arial",
                                  headerFontName: "Palatino-BoldItalic")
  let footerFontSet = UIFontSet(fontName: "Arial")

  var headerLayerStyle: UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor2,
                          borderWidth: CGFloat(1),
                            borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
  
  var contentLayerStyle: UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor1,
                          borderWidth: CGFloat(0),
                            borderColor: UIColor.clearColor())
  }
  
  var footerLayerStyle: UILayerStyle {
    return UILayerStyle(bgColor: theme.bgColor3,
                          borderWidth: CGFloat(1),
                            borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
  
  var cardBackLayerStyle: UILayerStyle {
    return UILayerStyle(bgColor: cardBackPattern,
                          borderWidth: CGFloat(1),
                            borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
  
  var cardFrontLayerStyle = UILayerStyle(bgColor: UIColor.whiteColor(),
                                           borderWidth: CGFloat(1),
                                             borderColor: UIColor(white: 0.4, alpha: 0.2))
  
  init() {
    headerFontSet.setH1Size(CGFloat(48))
    headerFontSet.color = theme.fontColor2
    footerFontSet.color = theme.fontColor3
  }
  
  func setTheme(theme: Theme) {
    self.theme = theme
    
    contentLayerStyle.bgColor = theme.bgColor1
    headerLayerStyle.bgColor  = theme.bgColor2
    footerLayerStyle.bgColor  = theme.bgColor3
    
    headerFontSet.color = theme.fontColor2
    footerFontSet.color = theme.fontColor3
  }
}

enum ThemeLabel {
  case green, grayscale, unlabeled
}

struct Theme {
  var label: ThemeLabel
  var bgColor1, bgColor2, bgColor3: UIColor
  var fontColor2, fontColor3: UIColor
  
  init() {
    label = ThemeLabel.unlabeled
    bgColor1   = UIColor.whiteColor()
    bgColor2   = UIColor.whiteColor()
    bgColor3   = UIColor.whiteColor()
    
    fontColor2 = UIColor.blackColor()
    fontColor3 = UIColor.blackColor()
  }
  
  func thumbnail() -> [UIColor] {
    return [bgColor1, bgColor2, bgColor3, fontColor3]
  }
  
  static func grayscale() -> Theme {
    var grayTheme = Theme()
    grayTheme.label = .grayscale
    
    grayTheme.bgColor1 = UIColor(white: 0.7, alpha: 1.0)
    grayTheme.bgColor2 = UIColor(white: 0.9, alpha: 1.0)
    grayTheme.bgColor3 = UIColor(white: 0.8, alpha: 1.0)

    return grayTheme
  }
  
  static func green() -> Theme {
    var greenTheme = Theme()
    greenTheme.label = .green
    
    greenTheme.bgColor1   = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    greenTheme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    greenTheme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.71, alpha: 1.0)
    
    greenTheme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    greenTheme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)

    return greenTheme
  }
  
  static func all() -> [Theme] {
    return [Theme.green(), Theme.grayscale()]
  }
}

var styleGuide = SG()
