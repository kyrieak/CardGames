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
  
  func applyTo(inout view: UIView) {
    view.backgroundColor   = bgColor
    view.layer.borderWidth = borderWidth
    view.layer.borderColor = borderColor.CGColor
  }
}

// - MARK: -

struct UIFontStyle {
  // - MARK: - Attributes
  
  var fontName: String
  var size: CGFloat
  var color: UIColor
  
  var font: UIFont {
    return {(font: UIFont?) -> UIFont in
              return ((font == nil) ? UIFont.systemFontOfSize(self.size) : font!)
           }(UIFont(name: self.fontName, size: self.size))
  }
  
  // - MARK: - Initializers

  
  init(fontName: String, size: CGFloat, color: UIColor) {
    self.fontName = fontName
    self.size     = size
    self.color    = color
  }
  
  init(fontName: String, size: CGFloat) {
    self.fontName = fontName
    self.size     = size
    self.color    = UIColor.blackColor()
  }

  init(fontName: String) {
    self.fontName = fontName
    self.size     = 12
    self.color    = UIColor.blackColor()
  }
}