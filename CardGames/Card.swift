//
//  Card.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import Foundation


class Card {
  var faceUp: Bool;
  
  init() {
    faceUp = false
  }
  
  init(faceUp: Bool) {
    self.faceUp = faceUp
  }
  
  func initCopy() -> Card {
    return Card.init(faceUp: self.faceUp)
  }
  
  func isFaceUp() -> Bool {
    return faceUp
  }
  
  func isFaceDown() -> Bool {
    return !faceUp
  }
  
  func flip() {
    faceUp = !faceUp
  }
}