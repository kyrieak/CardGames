//
//  MatchingGame.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 1/29/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation

class MatchingGameScorer {
  var score: Int = 0
  var currentTurn: Turn
  var viewedCards: [TrumpCard?]
  var lastIsRepeat: Bool = false
  
  init(cardCount: Int, cardsPerTurn: Int) {
    viewedCards = [TrumpCard?](count: cardCount, repeatedValue: nil)
    currentTurn = Turn(cardsPerTurn: cardsPerTurn)
  }
  
  func nextRound(cardCount: Int) {
    viewedCards = [TrumpCard?](count: cardCount, repeatedValue: nil)
    currentTurn.reset()
  }
  
  func updateTurn(cardIdx: Int, card: TrumpCard) -> String {
    if (currentTurn.done()) {
      currentTurn.reset()
    }
    
    lastIsRepeat = (viewedCards[cardIdx] != nil)
    
    if (!lastIsRepeat) { viewedCards[cardIdx] = card }
    
    currentTurn.addCard(cardIdx)
    
    var (turnScore, status) = getTurnStatus(currentTurn)
    
    if (currentTurn.done()) { score += turnScore }
    
    return status
  }
  
  func getScore() -> Int {
    return score
  }
  
  func getTurnStatus(turn: Turn) -> (Int, String) {
    var cards = cardsFromTurn(currentTurn)
    
    if (cards.count == 1) {
      return (0, "\(cards[0].label())")
    } else if (cards.count > 1) {
      var mv = matchValueForCards(cards)
      
      if (mv > 0) {
        return (mv, MatchingGameScorer.matchMsg(cards, matchValue: mv))
      } else {
        if (turn.done()) {
          return (mv, MatchingGameScorer.mismatchMsg(cards, penaltyValue: mv))
        } else {
          return (0, "\(cards[0].label()), \(cards[1].label())")
        }
      }
    } else {
      return (0, "")
    }
  }
  
  private func cardsFromTurn(turn: Turn) -> [TrumpCard] {
    var cards = turn.cardIndexes.map{
      (var i) -> TrumpCard in
      return self.viewedCards[i]!
    }
    
    return cards
  }
  
  func matchValue(cardA: TrumpCard, cardB: TrumpCard) -> Int {
    if (cardA.rank != cardB.rank) {
      return 0
    } else if (cardA.color() == cardB.color()) {
      return MatchingGameScorer.baseMatchValue() * 2
    } else {
      return MatchingGameScorer.baseMatchValue()
    }
  }
  
  func matchValueForCards(var cards: [TrumpCard]) -> Int {
    var matchVal = 0
    
    if (cards.count == 2) {
      matchVal = matchValue(cards[0], cardB: cards[1])
    } else if (cards.count == 3) {
      cards.sort({ $0.rank < $1.rank })
      
      for (idxA, idxB) in [(0, 1), (0, 2), (1, 2)] {
        var mv = {(a: TrumpCard, b: TrumpCard) -> Int in
          return self.matchValue(a, cardB: b)
          }(cards[idxA], cards[idxB])
        
        if (mv > matchVal) { matchVal = mv }
      }
      
      if (cards[0].rank == cards[2].rank) { matchVal *= 2 }
    }
    
    return matchVal
  }

  
  // == Class Methods ===================================================
  
  
  class func defaultPenalty() -> Int {
    return -1
  }
  
  class func baseMatchValue() -> Int {
    return 2
  }
  
  class func matchMsg(cards: [TrumpCard], matchValue: Int) -> String {
    var statusMsg = "Matched "
    
    if (cards.count == 2) {
      statusMsg += "\(cards[0].label()) and \(cards[1].label())"
    } else if (cards.count == 3) {
      statusMsg += "\(cards[0].label()), \(cards[1].label()), and \(cards[2].label())"
    }
    
    statusMsg += " for \(matchValue) Points!"
    
    return statusMsg
  }
  
  class func mismatchMsg(cards: [TrumpCard], penaltyValue: Int) -> String {
    var statusMsg = ""
    
    if (cards.count == 2) {
      statusMsg = "\(cards[0].label()) and \(cards[1].label()) do not match."
    } else if (cards.count == 3) {
      statusMsg = "\(cards[0].label()), \(cards[1].label()), and \(cards[2].label()) do not match."
    }
    
    if (penaltyValue == 0) {
      return statusMsg + " No penalty"
    } else {
      return statusMsg + " \(abs(penaltyValue)) point penalty :("
    }
  }
}

struct Turn {
  let maxCards: Int
  var cardIndexes: [Int]
  
  init(cardsPerTurn: Int) {
    maxCards = cardsPerTurn
    cardIndexes = []
  }
  
  mutating func addCard(cardIdx: Int) {
    cardIndexes.append(cardIdx)
  }
  
  mutating func reset() {
    cardIndexes = []
  }
  
  func done() -> Bool {
    return !(cardIndexes.count < maxCards)
  }
}