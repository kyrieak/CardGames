//
//  Style.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/11/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Style {
  let liteShadeColor = UIColor(white: 0.1, alpha: 0.1).CGColor
  let medShadeColor = UIColor(white: 0.4, alpha: 0.1).CGColor
  let darkShadeColor = UIColor(white: 0.4, alpha: 0.2).CGColor
  let cardBgImage = UIImage(named: "card_back")!
  let cardBgPattern = UIColor(patternImage: UIImage(named: "card_back")!)
  let medGreenColor = Style.rgbToUIColor(205, g: 225 , b: 208)
//  let medGreenColor = UIColor(red: 0.49, green: 0.66, blue: 0.51, alpha: 0.35).CGColor
  let medBrownColor = UIColor(red: 0.6, green: 0.41, blue: 0.37, alpha: 0.36).CGColor

  func applyShade(layer: CALayer) {
    layer.borderColor = medShadeColor
    layer.borderWidth = 2
  }

  func applyShade(layer: CALayer, color: CGColorRef, thickness: CGFloat) {    
    layer.borderColor = color
    layer.borderWidth = thickness
  }
  
  func applyCardBg(view: UIView) {
    view.backgroundColor = cardBgPattern
  }
  
  func applyCardBg(view: UIView, withScale: CGFloat) {
    var scaledImg = UIImage(CGImage: cardBgImage.CGImage, scale: withScale, orientation: UIImageOrientation.Up)
    view.backgroundColor = UIColor(patternImage: scaledImg!)
  }
  
  static func getUIColorFor(color: NamedColor) -> UIColor {
    switch(color) {
      case .Red:
        return UIColor.redColor()
      case .Black:
        return UIColor.blackColor()
    }
  }
  
  static func rgbToUIColor(r: Int, g: Int, b: Int) -> UIColor {
    let max = CGFloat(255)
    
    return UIColor(red: (CGFloat(r) / max), green: (CGFloat(g) / max), blue: (CGFloat(b) / max), alpha: CGFloat(2))
  }
}