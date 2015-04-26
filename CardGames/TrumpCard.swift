//
//  TrampCard.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import Foundation
import UIKit

enum NamedSuit {
  case Hearts, Spades, Diamonds, Clubs
}

enum NamedColor {
  case Red, Black
}

class TrumpCard:Card, Comparable {
  var suit: NamedSuit
  var rank:Int
  
  init(rank:Int, suit: NamedSuit) {
    self.suit = suit
    self.rank = rank
    
    super.init()
  }
  
  override func initCopy() -> TrumpCard {
    return TrumpCard.init(rank: self.rank, suit: self.suit)
  }
  
  func label() -> String {
    return rankAbbv() + suitSymbol()
  }
  
  private func rankAbbv() -> String {
    switch (rank) {
      case 1:
        return "A"
      case 11:
        return "J"
      case 12:
        return "Q"
      case 13:
        return "K"
      default:
        return "\(rank)"
    }
    //  switch (rank) {
    //    case 1:
    //      return "🔵"
    //    case 11:
    //      return "🐸"
    //    case 12:
    //      return "🐴👀🐴"
    //    case 13:
    //      return "🐰"
    //    default:
    //      return "\(self.rank)"
    //  }
  }
  
  private func suitSymbol() -> String {
    switch(suit) {
      case .Hearts:
        return "♥︎"
      case .Spades:
        return "♠︎"
      case .Diamonds:
        return "♦︎"
      case .Clubs:
        return "♣︎"
    }
  }
  
  func name() -> String {
    return rankName() + " of " + suitName()
  }
  
  private func rankName() -> String {
    switch (rank) {
      case 1:
        return "Ace"
      case 11:
        return "Jack"
      case 12:
        return "Queen"
      case 13:
        return "King"
      default:
        return "\(rank)"
    }
    
    //  switch (rank) {
    //    case 1:
    //      return "Meep"
    //    case 11:
    //      return "Carrot Master"
    //    case 12:
    //      return "Romulebie"
    //    case 13:
    //      return "Bunny"
    //    default:
    //      return "\(self.rank)"
    //  }
  }
  
  private func suitName() -> String {
    switch(suit) {
      case .Hearts:
        return "Hearts"
      case .Diamonds:
        return "Diamonds"
      case .Spades:
        return "Spades"
      case .Clubs:
        return "Clubs"
    }
  }
  
  func color() -> NamedColor {
    switch(suit) {
      case .Hearts, .Diamonds:
        return NamedColor.Red
      case .Spades, .Clubs:
        return NamedColor.Black
    }
  }
  
  func attributes() -> TrumpCardAttributes {
    return TrumpCardAttributes(rank: self.rank, suit: self.suit)
  }
  
  class func standardSet() -> NSDictionary {
    var obj = [NSMutableSet]()
    var keys = [Int]()
    
    for i in 1...13 {
      var set = NSMutableSet()
      
      set.addObject(TrumpCard(rank: i, suit: NamedSuit.Diamonds))
      set.addObject(TrumpCard(rank: i, suit: NamedSuit.Spades))
      set.addObject(TrumpCard(rank: i, suit: NamedSuit.Hearts))
      set.addObject(TrumpCard(rank: i, suit: NamedSuit.Clubs))
      
      obj.append(set)
      keys.append(i)
    }

    return NSDictionary(objects: obj, forKeys: keys)
  }

  class func standardDeck() -> Deck<TrumpCard> {
    var deck = Deck<TrumpCard>()

    for i in 1...13 {
      deck.addCard(TrumpCard(rank: i, suit: NamedSuit.Diamonds))
      deck.addCard(TrumpCard(rank: i, suit: NamedSuit.Spades))
      deck.addCard(TrumpCard(rank: i, suit: NamedSuit.Hearts))
      deck.addCard(TrumpCard(rank: i, suit: NamedSuit.Clubs))
    }
    
    return deck
  }
}


func ==(lhs:TrumpCard, rhs:TrumpCard) -> Bool {
  return ((lhs.suit == rhs.suit) && (lhs.rank == rhs.rank))
}

func <(lhs:TrumpCard, rhs:TrumpCard) -> Bool {
  return lhs.rank < rhs.rank
}

struct TrumpCardAttributes {
  let rank: Int
  let suit: NamedSuit
  
  init(card: TrumpCard) {
    self.rank = card.rank
    self.suit = card.suit
  }
  
  init(rank: Int, suit: NamedSuit) {
    self.rank = rank
    self.suit = suit
  }  
}