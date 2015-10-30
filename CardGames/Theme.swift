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
  
  var bgColor1, bgColor2, bgColor3, bgColor4: UIColor
  var fontColor2, fontColor3, fontColor4: UIColor
  
  private(set) var patternColor: UIColor?

  
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
  
  convenience init(name: String) {
    self.init()
    
    self.name = name
  }
    
  // - MARK: - Public
  
  func thumbnail() -> [UIColor] {
    return [bgColor1, bgColor2, bgColor3, fontColor3]
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
    
    theme.bgColor1   = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.73, alpha: 1.0)
    theme.bgColor4   = theme.bgColor1
    
    theme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    theme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)
    theme.fontColor4 = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)

    theme.setPattern("cb_1")
    
    return theme
  }

  
  class func grayscale() -> Theme {
    let theme = Theme(name: "Grayscale")
    
    theme.setUniqueID(2)

    theme.bgColor1   = UIColor(white: 0.7, alpha: 1.0)
    theme.bgColor2   = UIColor(white: 0.9, alpha: 1.0)
    theme.bgColor3   = UIColor(white: 0.8, alpha: 1.0)
    theme.bgColor4   = UIColor(white: 0.4, alpha: 1.0)
    theme.fontColor2 = UIColor(white: 0.2, alpha: 1.0)

    theme.setPattern("card_back")
    
    return theme
  }

  
  class func sea() -> Theme {
    let theme = Theme(name: "Down by the Sea")
    
    theme.setUniqueID(3)
    
    theme.bgColor1   = UIColor(red: 0.79, green: 0.90, blue: 0.88, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.68, green: 0.80, blue: 0.80, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.98, green: 0.80, blue: 0.66, alpha: 1.0)
    theme.fontColor2 = theme.bgColor1.getShade(-0.4)
    
    theme.setPattern("cb_2")
    
    return theme
  }  
}

