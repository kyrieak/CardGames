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
  
  convenience init(shape: String, color: UIColor) {
    self.init(shape: shape, color: color, shading: "solid", number: 1)
  }
  
  class func standardAttrs() -> StandardSetAttrs {
    return StandardSetAttrs()
  }
}

struct StandardSetAttrs {
  var shapes:  [String]
  var shading: [String]
  var colors:  [UIColor]
  var numbers: [Int]
  
  init() {
    shapes  = ["diamond", "oval", "squiggle"]
    shading = ["solid", "striped", "open"]
    colors  = [UIColor.redColor(), UIColor.greenColor(), UIColor.purpleColor()]
    numbers = [1, 2, 3]
  }
  
  mutating func setShapes(shapes: [String]) {
    self.shapes = shapes
  }

  mutating func setColors(colors: [UIColor]) {
    self.colors = colors
  }
  
  mutating func setShading(shading: [String]) {
    self.shading = shading
  }
  
  mutating func setNumbers(numbers: [Int]) {
    self.numbers = numbers
  }
}