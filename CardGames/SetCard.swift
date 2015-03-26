//
//  SetCard.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/27/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetCard: Card {
  let shape: String
  let color: UIColor
  let shading: String
  let number: Int
  
  init(shape: String, color: UIColor, shading: String, number: Int) {
    self.shape = shape
    self.color = color
    self.shading = shading
    self.number = number

    super.init()
  }
  
  func attributes() -> SetCardAttributes {
    return SetCardAttributes(card: self)
  }
  
  convenience init(shape: String, color: UIColor) {
    self.init(shape: shape, color: color, shading: "solid", number: 1)
  }
}

struct SetCardAttributes {
  let shape: String
  let color: [CGFloat]
  let shading: String
  let number: Int
  
  init(number: Int, shape: String, shading: String, color: [CGFloat]) {
    self.number = number
    self.shape = shape
    self.shading = shading
    self.color = color
  }

  init(number: Int, shape: String, shading: String, color: UIColor) {
    self.number = number
    self.shape = shape
    self.shading = shading
    self.color = SetCardAttributes.rgbColor(color)
  }
  
  init(card: SetCard) {
    self.number = card.number
    self.shape = card.shape
    self.shading = card.shading
    self.color = SetCardAttributes.rgbColor(card.color)
  }
  
  static func rgbColor(color: UIColor) -> [CGFloat] {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return [r, g, b, a]
  }
}