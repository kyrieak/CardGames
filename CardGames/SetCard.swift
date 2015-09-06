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
  let shape: SGShape
  let color: SGColor
  let shading: SGShading
  let number: Int
  
  init(shape: SGShape, color: SGColor, shading: SGShading, number: Int) {
    self.shape = shape
    self.color = color
    self.shading = shading
    self.number = number

    super.init()
  }
  
  func attributes() -> SetCardAttrs {
    return SetCardAttrs(card: self)
  }
  
  convenience init(shape: SGShape, color: SGColor) {
    self.init(shape: shape, color: color, shading: SGShading.Solid, number: 1)
  }
}

struct SetCardAttrs {
  let shape: SGShape
  let color: SGColor
  let shading: SGShading
  let number: Int

  init(number: Int, shape: SGShape, shading: SGShading, color: SGColor) {
    self.number = number
    self.shape = shape
    self.shading = shading
    self.color = color
  }
  
  init(card: SetCard) {
    self.number = card.number
    self.shape = card.shape
    self.shading = card.shading
    self.color = card.color
  }
}


//  static func rgbColor(color: UIColor) -> [CGFloat] {
//    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
//
//    color.getRed(&r, green: &g, blue: &b, alpha: &a)
//
//    return [r, g, b, a]
//  }


enum SGColor {
  case Red
  case Green
  case Purple
}

enum SGShading {
  case Open
  case Striped
  case Solid
}

enum SGShape {
  case Diamond
  case Oval
  case Squiggle
}