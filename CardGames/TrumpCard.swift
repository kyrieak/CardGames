//
//  TrampCard.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import Foundation
import UIKit

struct Suit {
  let title:String
  let symbol:String
  let tier:Int
  let color:UIColor
  
  init(title:String, symbol:String, tier:Int, color:UIColor) {
    self.title  = title
    self.symbol = symbol
    self.tier   = tier
    self.color  = color
  }
}

class TrumpCard:Card, Comparable {
  var suit:Suit
  var rank:Int
  
  init(suit:Suit, rank:Int) {
    self.suit = suit
    self.rank = rank
    super.init()
  }
  
  override func initCopy() -> TrumpCard {
    return TrumpCard.init(suit: self.suit, rank: self.rank)
  }
  
  func label() -> String {
    return "\(self.rank)" + self.suit.symbol
  }
}

func ==(lhs:TrumpCard, rhs:TrumpCard) -> Bool {
  return lhs.suit.tier == rhs.suit.tier
}

func <(lhs:TrumpCard, rhs:TrumpCard) -> Bool {
  if (lhs.suit.tier == rhs.suit.tier) {
    return lhs.rank < rhs.rank
  } else {
    return lhs.suit.tier > rhs.suit.tier
  }
}