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


//class ViewStyle {
//  var layerStyle: UILayerStyle
//  var textStyle: UITextStyle
//  var btnStyle: UITextStyle
//
//  init(layerStyle: UILayerStyle, textStyle: UITextStyle, btnStyle: UITextStyle) {
//    self.layerStyle = layerStyle
//    self.textStyle  = textStyle
//    self.btnStyle   = btnStyle
//  }
//  
//  private func applyLayerStyle(layer: CALayer, style: UILayerStyle) {
//    layer.borderWidth     = style.borderWidth
//    layer.borderColor     = style.borderColor.CGColor
//    layer.backgroundColor = style.bgColor.CGColor
//  }
//  
//  private func applyFontStyle(label: UILabel, style: UITextStyle) {
//    label.font      = style.font
//    label.textColor = style.fontColor
//  }
//  
//  func applyStyle(view: UIView) {
//    applyLayerStyle(view.layer, style: layerStyle)
//  }
//  
//  func applyStyle(btn: UIButton) {
//    applyLayerStyle(btn.layer, style: btnStyle.layerStyle)
//    
//    if (btn.titleLabel != nil) {
//      applyFontStyle(btn.titleLabel!, style: btnStyle)
//    }
//  }
//  
//  func applyStyle(label: UILabel) {
//    applyLayerStyle(label.layer, style: textStyle.layerStyle)
//    applyFontStyle(label, style: textStyle)
//  }
//}

class SG {
  let cardBackImage = UIImage(named: "card_back")!
  let cardBackPattern = UIColor(patternImage: UIImage(named: "card_back")!)

  var headerFontSet: UIFontSet
  var footerFontSet: UIFontSet

  var headerLayerStyle: UILayerStyle
  var contentLayerStyle: UILayerStyle
  var footerLayerStyle: UILayerStyle
  var cardBackLayerStyle: UILayerStyle
  var cardFrontLayerStyle: UILayerStyle
  
  init() {
    headerFontSet = UIFontSet(fontName: "Arial",
                                headerFontName: "Palatino-BoldItalic")
    footerFontSet = UIFontSet(fontName: "Arial")
    headerFontSet.color = UIColor(red: 0.61, green: 0.73,
                                    blue: 0.61, alpha: 1.0)
    footerFontSet.color = UIColor(red: 0.26, green: 0.19,
                                    blue: 0.11, alpha: 1.0)
    headerFontSet.setH1Size(CGFloat(48))

    
    headerLayerStyle = UILayerStyle(bgColor: UIColor(red: 0.80, green: 0.88,
                                                       blue: 0.82, alpha: 1.0),
                                      borderWidth: CGFloat(1),
                                        borderColor: UIColor(white: 0.4, alpha: 0.2))
    contentLayerStyle = UILayerStyle(bgColor: UIColor(red: 0.93, green: 0.97,
                                                        blue: 0.93, alpha: 1.0),
                                       borderWidth: CGFloat(0),
                                         borderColor: UIColor.clearColor())
    footerLayerStyle = UILayerStyle(bgColor: UIColor(red: 0.80, green: 0.76,
                                                       blue: 0.71, alpha: 1.0),
                                      borderWidth: CGFloat(1),
                                        borderColor: UIColor(white: 0.4, alpha: 0.2))
    cardBackLayerStyle = UILayerStyle(bgColor: cardBackPattern,
                                        borderWidth: CGFloat(1),
                                          borderColor: UIColor(white: 0.4, alpha: 0.2))
    cardFrontLayerStyle = UILayerStyle(bgColor: UIColor.whiteColor(),
                                         borderWidth: CGFloat(1),
                                           borderColor: UIColor(white: 0.4, alpha: 0.2))
  }
}

//
//class StyleGuide {
////  var colors = ColorGuide()
////  var fonts = FontGuide()
//  let cardBgImage   = UIImage(named: "card_back")!
//  let cardBgPattern = UIColor(patternImage: UIImage(named: "card_back")!)
//  
//  var font: (header: UIFont, content: UIFont, footer: UIFont)
//  var contentStyle: ViewStyle
//  var headerStyle: ViewStyle
//  var footerStyle: ViewStyle
//  
//  init(styleSet: StyleSet) {
//    contentStyle = styleSet.contentStyle()
//    headerStyle = styleSet.headerStyle()
//    footerStyle = styleSet.footerStyle()
//  }
//  
//  init(_colorGuide: ColorGuide, _fontGuide: FontGuide) {
//    colors = _colorGuide
//    fonts  = _fontGuide
//    
//    headerStyle = ViewStyle(_layerStyle: LayerStyle(_bgColor: colors.headerBgColor),
//                              _textStyle: TextStyle(_font: fonts.headerFont,
//                                                      _color: colors.headerTextColor))
//    contentStyle = ViewStyle(_layerStyle: LayerStyle(_bgColor: colors.contentBgColor),
//                               _textStyle: TextStyle(_font: fonts.contentFont,
//                                                       _color: colors.contentTextColor))
//    footerStyle = ViewStyle(_layerStyle: LayerStyle(_bgColor: colors.footerBgColor),
//                              _textStyle: TextStyle(_font: fonts.footerFont,
//                                _color: colors.footerTextColor))
//  }
//  
//  func applyCardBg(view: UIView) {
//    view.backgroundColor = cardBgPattern
//  }
//  
//  func applyCardBg(view: UIView, withScale: CGFloat) {
//    var scaledImg = UIImage(CGImage: cardBgImage.CGImage, scale: withScale, orientation: UIImageOrientation.Up)
//    view.backgroundColor = UIColor(patternImage: scaledImg!)
//  }
//  
//  class func rgbToUIColor(r: Int, g: Int, b: Int) -> UIColor {
//    let max = CGFloat(255)
//    
//    return UIColor(red: (CGFloat(r) / max), green: (CGFloat(g) / max), blue: (CGFloat(b) / max), alpha: CGFloat(2))
//  }
//}
//
//
//struct StyleSet {
//  let headerBgColor  = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
//  let footerBgColor  = UIColor(red: 0.80, green: 0.76, blue: 0.71, alpha: 1.0)
//  let contentBgColor = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
//
//  let headerFont  = UIFont(name: "Palatino-BoldItalic", size: 48)!
//  let contentFont = UIFont(name: "Palatino", size: 12)!
//  let footerFont  = UIFont(name: "Palatino", size: 24)!
//  let clearLayerStyle = UILayerStyle(_bgColor: UIColor.clearColor(),
//                                       _borderWidth: CGFloat(0),
//                                         _borderColor: UIColor.clearColor())
//  
//  func headerLayerStyle(withBorder: Bool) -> UILayerStyle {
//    var borderWidth = (withBorder) ? CGFloat(1) : CGFloat(0)
//    var borderColor = (withBorder) ? UIColor(white: 0.4, alpha: 0.2) : headerBgColor
//    
//    return UILayerStyle(_bgColor: headerBgColor,
//                          _borderWidth: borderWidth,
//                            _borderColor: borderColor)
//  }
//  
//  func footerLayerStyle(withBorder: Bool) -> UILayerStyle {
//    var borderWidth = (withBorder) ? CGFloat(1) : CGFloat(0)
//    var borderColor = (withBorder) ? UIColor(white: 0.4, alpha: 0.2) : footerBgColor
//
//    return UILayerStyle(_bgColor: footerBgColor,
//                          _borderWidth: borderWidth,
//                            _borderColor: borderColor)
//  }
//  
//  func headerBtnStyle() -> UITextStyle {
//    let textColor = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
//
//    return UITextStyle(_layerStyle: headerLayerStyle(true),
//                         _font: contentFont,
//                           _fontColor: textColor)
//  }
//  
//  func headerTitleStyle() -> UITextStyle {
//    let textColor = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
//    
//    UITextStyle(_layerStyle: clearLayerStyle,
//                  _font: headerFont, _fontColor: textColor)
//  }
//  
//  func contentTextStyle() -> UITextStyle {
//    let textColor = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
//    
//    return UITextStyle(_layerStyle: clearLayerStyle,
//                         _font: contentFont, _fontColor: textColor)
//  }
//  
//  func headerStyle() -> ViewStyle {
//    return ViewStyle(layerStyle: headerLayerStyle(true),
//                       textStyle: headerTitleStyle(),
//                         btnStyle: headerBtnStyle())
//  }
//  
//  func getContentStyle() -> ViewStyle {
//    var lStyle = LayerStyle(_bgColor: contentBgColor)
//  }
//  
//  func getContentBtnLayerStyle() -> LayerStyle {
//    var style = LayerStyle(_bgColor: contentBtnBgColor)
//
//    style.setBorder(CGFloat(1), color: btnBorderColor)
//    
//    return style
//  }
//}
//
//struct SGColorSet {
//  var headerBgColor    = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
//  var headerTextColor  = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
//  var contentBgColor    = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
//  var contentTextColor  = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
//  var contentBtnBgColor = UIColor.whiteColor()
//  var footerBgColor    = UIColor(red: 0.80, green: 0.76, blue: 0.71, alpha: 1.0)
//  var footerTextColor  = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)
//  var btnBorderColor = UIColor(white: 0.4, alpha: 0.2)
//  var stdBorderColor = UIColor(white: 0.4, alpha: 0.2)
//}
//
//struct SGFontSet {
//  var headerFont  = UIFont(name: "Palatino-BoldItalic", size: 48)!
//  var contentFont = UIFont(name: "Palatino", size: 12)!
//  var footerFont  = UIFont(name: "Palatino", size: 24)!
//}

var styleGuide = SG()
