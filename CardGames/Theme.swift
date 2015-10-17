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
  
  // - MARK: - Properties

  var bgColor1, bgColor2, bgColor3: UIColor
  var fontColor2, fontColor3: UIColor

  var bgColor4: UIColor
  var borderColor4: UIColor
  
  var fontColor4: UIColor
  
  // - MARK: - Initializer
  
  init() {
    bgColor1   = UIColor.whiteColor()
    bgColor2   = UIColor.whiteColor()
    bgColor3   = UIColor.whiteColor()
    bgColor4   = UIColor.clearColor()

    borderColor4 = UIColor.blackColor()
    
    fontColor2 = UIColor.blackColor()
    fontColor3 = UIColor.blackColor()
    fontColor4 = UIColor.blackColor()
  }
  
  
  // - MARK: - Public
  
  func thumbnail() -> [UIColor] {
    return [bgColor1, bgColor2, bgColor3, fontColor3]
  }
  
  
  // - MARK: - Static Functions

  
  static func grayscale() -> Theme {
    var _theme = Theme()
    
    _theme.bgColor1 = UIColor(white: 0.7, alpha: 1.0)
    _theme.bgColor2 = UIColor(white: 0.9, alpha: 1.0)
    _theme.bgColor3 = UIColor(white: 0.8, alpha: 1.0)
    _theme.bgColor4 = UIColor(white: 0.4, alpha: 1.0)
    
    return _theme
  }
  
  static func green() -> Theme {
    var _theme = Theme()
    
    _theme.bgColor1   = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    _theme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    _theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.71, alpha: 1.0)
    _theme.bgColor4   = _theme.bgColor1
//    _theme.bgColor4   = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)

//    _theme.bgColor4   = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)
    _theme.borderColor4 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    
    _theme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    _theme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)
    _theme.fontColor4 = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)
    
    return _theme
  }
  
  static func all() -> [Theme] {
    return [Theme.green(), Theme.grayscale()]
  }
}

