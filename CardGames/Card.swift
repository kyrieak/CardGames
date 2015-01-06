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
    self.faceUp = false
  }
  
  init(isFaceUp: Bool) {
    self.faceUp = isFaceUp
  }
  
  func initCopy() -> Card {
    return Card.init(isFaceUp: self.faceUp)
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