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
  let number: Int
  let shape: SGShape
  let color: SGColor
  let shading: SGShading

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
  
  func toString() -> String {
    let str = "\(number) \(color.toString) \(shading.toString) \(shape.toString)"

    return ((number > 1) ? (str + "s") : str)
  }
  
  func toString(options: GameOptions) -> String{
    let opt = options
    var text: String
    
    if (opt.colorsOn && opt.shadingOn && opt.shapesOn) {
      text = toString()
    } else {
      text = "\(number)"
      
      if (opt.colorsOn) {
        text += " \(color.toString)"
      }
      
      if (opt.shadingOn) {
        text += " \(shading.toString)"
      }
      
      text += " \(shape.toString)"
      
      if (number > 1) {
        text += "s"
      }
    }
    
    return text
  }
}



enum SGColor {
  case Red
  case Yellow
  case Blue
  
  var toString: String {
    switch(self) {
      case .Red:
        return "Red"
      case .Yellow:
        return "Yellow"
      case .Blue:
        return "Blue"
    }
  }
}

enum SGShading {
  case Open
  case Spotted
  case Solid

  var toString: String {
    switch(self) {
      case .Open:
        return "Open"
      case .Spotted:
        return "Spotted"
      case .Solid:
        return "Solid"
    }
  }
}

enum SGShape {
  case Cloud
  case Sun
  case Moon

  var toString: String {
    switch(self) {
      case .Cloud:
        return "Cloud"
      case .Sun:
        return "Sun"
      case .Moon:
        return "Moon"
    }
  }
}