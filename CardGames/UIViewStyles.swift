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
  // - MARK: - Attributes

  var bgColor: UIColor
  var borderColor: UIColor
  var borderWidth: CGFloat
  

  // - MARK: - Initializers
  
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

// - MARK: -

struct UIFontStyle {
  // - MARK: - Attributes
  
  var fontName: String
  var baseSize: CGFloat
  var color: UIColor
  
  var font: UIFont {
    return UIFont(name: self.fontName, size: self.baseSize)!
  }
  
  // - MARK: - Initializers

  
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
}