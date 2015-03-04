//
//  Deck.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import Foundation

class Deck<T: Card> {
  var cards: [T];
  
  init() {
    cards = []
  }
  
  func isEmpty() -> Bool {
    return (cards.count == 0)
  }
  
  func addCard(card:T) {
    self.cards.append(card);
  }
  
  func removeTopCard() -> T {
    return self.cards.removeAtIndex(0);
  }
  
  func removeCard(pos:Int) -> T {
    return self.cards.removeAtIndex(pos)
  }
  
  func moveCard(posA:Int, posB:Int) {
    self.cards.insert(self.removeCard(posA), atIndex: posB)
  }
  
  func cut(pos:Int) {
    for i in 0...pos {
      self.moveCard(0, posB:self.cards.count)
    }
  }
  
  func shuffle() {
    var j: Int
    var temp: T

    var count = cards.count
    
    for i in (0..<count) {
      j = Int(arc4random_uniform(UInt32(count - 1)))
      
      temp = self.cards[i]
      self.cards[i] = self.cards[j]
      self.cards[j] = temp
    }
  }
}