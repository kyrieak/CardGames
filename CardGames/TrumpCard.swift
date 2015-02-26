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
    return { (rank: Int) -> String in
      switch (rank) {
      case 1:
        return "🔵"
      case 11:
        return "🐸"
      case 12:
        return "🐴👀🐴"
      case 13:
        return "🐰"
      default:
        return "\(self.rank)"
      }
    }(self.rank) + self.suit.symbol
  }
  
  func color() -> UIColor {
    return suit.color
  }
  
  class func hearts() -> Suit {
    return Suit(title: "Hearts", symbol: "♥︎", tier: 1, color: UIColor.redColor())
  }
  
  class func diamonds() -> Suit {
    return Suit(title: "Diamonds", symbol: "♦︎", tier: 1, color: UIColor.redColor())
  }
  
  class func spades() -> Suit {
    return Suit(title: "Spades", symbol: "♠︎", tier: 1, color: UIColor.blackColor())
  }
  
  class func clubs() -> Suit {
    return Suit(title: "Clubs", symbol: "♣︎", tier: 1, color: UIColor.blackColor())
  }
  
//  var cardSets: NSDictionary
//  
//  init(keys: [AnyObject]) {
//
//  func addCard(card: T, key: AnyObject) {
//    if var cardSet = cardSets.objectForKey(key) as? NSMutableSet {
//      cardSet.addObject(card)
//    }
//  }

  
  class func standardSet() -> NSDictionary {
    var obj = [NSMutableSet]()
    var keys = [Int]()
    
    for i in 1...13 {
      var set = NSMutableSet()
      
      set.addObject(TrumpCard(suit: diamonds(), rank: i))
      set.addObject(TrumpCard(suit: spades(), rank: i))
      set.addObject(TrumpCard(suit: hearts(), rank: i))
      set.addObject(TrumpCard(suit: clubs(), rank: i))
      
      obj.append(set)
      keys.append(i)
    }

    return NSDictionary(objects: obj, forKeys: keys)
  }

  class func standardDeck() -> Deck<TrumpCard> {
    var deck = Deck<TrumpCard>()

    for i in 1...13 {
      deck.addCard(TrumpCard(suit: diamonds(), rank: i))
      deck.addCard(TrumpCard(suit: spades(), rank: i))
      deck.addCard(TrumpCard(suit: hearts(), rank: i))
      deck.addCard(TrumpCard(suit: clubs(), rank: i))
    }
    
    return deck
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