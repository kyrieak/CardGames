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
  
  init(shape: String, color: UIColor, shading: String) {
    self.shape = shape
    self.color = color
    self.shading = shading

    super.init()
  }
  
  convenience init(shape: String, color: UIColor) {
    self.init(shape: shape, color: color, shading: "solid")
  }  
}