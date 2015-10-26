//
//  Theme.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/12/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
  var name: String?
  // - MARK: - Properties

  var bgColor1, bgColor2, bgColor3, bgColor4: UIColor
  var fontColor2, fontColor3, fontColor4: UIColor
  
  // - MARK: - Initializer
  
  init() {
    bgColor1 = UIColor.whiteColor()
    bgColor2 = bgColor1
    bgColor3 = bgColor1
    bgColor4 = bgColor1
    
    fontColor2 = UIColor.blackColor()
    fontColor3 = fontColor2
    fontColor4 = fontColor2
  }
  
  init(name: String) {
    self.init()
    
    self.name = name
  }
    
  // - MARK: - Public
  
  func thumbnail() -> [UIColor] {
    return [bgColor1, bgColor2, bgColor3, fontColor3]
  }
  
  
  // - MARK: - Static Functions

  
  static func grayscale() -> Theme {
    var theme = Theme(name: "Grayscale")

    theme.bgColor1   = UIColor(white: 0.7, alpha: 1.0)
    theme.bgColor2   = UIColor(white: 0.9, alpha: 1.0)
    theme.bgColor3   = UIColor(white: 0.8, alpha: 1.0)
    theme.bgColor4   = UIColor(white: 0.4, alpha: 1.0)
    theme.fontColor2 = UIColor(white: 0.2, alpha: 1.0)
    
    return theme
  }
  
  static func honeydew() -> Theme {
    var theme = Theme(name: "Honeydew Green")
    
    theme.bgColor1   = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.73, alpha: 1.0)
    theme.bgColor4   = theme.bgColor1
    
    theme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    theme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)
    theme.fontColor4 = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)
    
    return theme
  }

  
  static func sea() -> Theme {
    var theme = Theme(name: "Down by the Sea")
    
//    theme.bgColor1   = UIColor(red: 0.74, green: 0.95, blue: 0.93, alpha: 1.0)
    theme.bgColor1   = UIColor(red: 0.79, green: 0.90, blue: 0.88, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.68, green: 0.80, blue: 0.80, alpha: 1.0)
//    theme.bgColor2   = theme.bgColor1.getShade(-0.1)
//    theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.73, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.98, green: 0.80, blue: 0.66, alpha: 1.0)
    theme.fontColor2 = theme.bgColor1.getShade(-0.4)
    
    return theme
  }
  
  //    _theme.borderColor1 = UIColor(red: 0.73, green: 0.77, blue: 0.73, alpha: 1.0)
  //    _theme.borderColor4 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
}

