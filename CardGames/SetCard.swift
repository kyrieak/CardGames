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
  let number: Int
  let shape: SGShape
  let color: SGColor
  let shading: SGShading
  
  init(number: Int, shape: SGShape, color: SGColor, shading: SGShading) {
    self.number = number
    self.shape = shape
    self.color = color
    self.shading = shading

    super.init()
  }
  
  func attributes() -> SetCardAttrs {
    return SetCardAttrs(card: self)
  }
  
  convenience init(shape: SGShape, color: SGColor) {
    self.init(number: 1, shape: shape, color: color, shading: SGShading.Solid)
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