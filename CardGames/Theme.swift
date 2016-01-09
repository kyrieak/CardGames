//
//  Theme.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/12/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class Theme {
  // - MARK: - Properties

  private(set) var id: Int?
  
  var name: String?
  
  var bgBase, bgColor2, bgColor3: UIColor
  var fontColor1, fontColor2, fontColor3: UIColor
  var bgLight: UIColor = UIColor.whiteColor()

  var shadeAlpha = CGFloat(0.2)
  var shadeWidth = CGFloat(0.5)
  
  var shadeColor1 = UIColor(white: 0.8, alpha: 1.0)
  
  private(set) var patternColor: UIColor?

  
  // - MARK: - Initializer
  
  init() {
    bgBase   = UIColor.whiteColor()
    bgColor2 = bgBase
    bgColor3 = bgBase
    
    fontColor1 = UIColor.blackColor()
    fontColor2 = UIColor.blackColor()
    fontColor3 = UIColor.blackColor()
    
  }
  
  convenience init(name: String) {
    self.init()
    
    self.name = name
  }
    
  // - MARK: - Public
  
  func thumbnail() -> [UIColor] {
    return [bgBase, bgColor2, bgColor3, fontColor3]
  }
  
  func setUniqueID(id: Int) {
    self.id = id
  }
  
  func setPattern(imgName: String) {
    let patternImg = UIImage(named: imgName)
    
    self.patternColor = ((patternImg != nil) ? UIColor(patternImage: patternImg!) : nil)
  }
  
  
  // - MARK: - Static Functions
  

  class func honeydew() -> Theme {
    let theme = Theme(name: "Honeydew Green")

    theme.setUniqueID(1)
    
    theme.bgBase     = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    theme.bgLight    = UIColor(red: 0.97, green: 1.00, blue: 0.97, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.73, alpha: 1.0)

//    theme.fontColor  = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)
    theme.fontColor1 = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)
    theme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    theme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)

    theme.setPattern("cb_1")
    
    return theme
  }

  
  class func grayscale() -> Theme {
    let theme = Theme(name: "Grayscale")
    
    theme.setUniqueID(2)

    theme.bgBase     = UIColor(white: 0.95, alpha: 1.0)
    theme.bgLight    = UIColor(white: 0.98, alpha: 1.0)
    theme.bgColor2   = UIColor(white: 0.85, alpha: 1.0)
    theme.bgColor3   = UIColor(white: 0.75, alpha: 1.0)
    
    theme.fontColor2 = UIColor(white: 0.2, alpha: 1.0)

    theme.setPattern("cb_2")
    theme.shadeColor1 = UIColor(white: 0.7, alpha: 1.0)
    theme.shadeAlpha = 0.5
    
    return theme
  }

  
  class func sea() -> Theme {
    let theme = Theme(name: "Cool Breeze")
    
    theme.setUniqueID(3)
    
    theme.bgBase     = UIColor(red: 0.79, green: 0.90, blue: 0.88, alpha: 1.0)
    theme.bgLight    = UIColor(red: 0.92, green: 0.96, blue: 0.95, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.68, green: 0.80, blue: 0.80, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.98, green: 0.80, blue: 0.66, alpha: 1.0)

    theme.fontColor1 = UIColor(red: 0.43, green: 0.23, blue: 0.17, alpha: 1.0)
    theme.fontColor2 = UIColor(red: 0.39, green: 0.50, blue: 0.48, alpha: 1.0)
    theme.fontColor3 = theme.fontColor1
    
    theme.setPattern("cb_3")
    
    return theme
  }
  
  class func victoria1() -> Theme {
    let theme = Theme(name: "Victoria I")
    
    theme.setUniqueID(4)
    
    theme.bgBase     = UIColor(red: 0.86, green: 0.61, blue: 0.36, alpha: 1.0) // #DB9B5D
    theme.bgLight    = theme.bgBase.getShade(0.2)
    theme.bgColor2   = UIColor(red: 0.16, green: 0.31, blue: 0.43, alpha: 1.0) // #2A506D
    theme.bgColor3   = UIColor(red: 0.54, green: 0.65, blue: 0.84, alpha: 1.0) // #8AA6D6
    theme.fontColor1 = UIColor(red: 0.45, green: 0.14, blue: 0.15, alpha: 1.0) // #732426
    theme.fontColor2 = theme.bgColor2.getShade(0.15) // #4f7594
    theme.fontColor3 = theme.bgColor3.getShade(-0.6)
    theme.shadeAlpha = 0.5
    theme.shadeWidth = 2.0
    theme.shadeColor1 = UIColor(red: 0.76, green: 0.51, blue: 0.26, alpha: 1.0)

    theme.setPattern("cb_v1")
    
    return theme
  }
}

