//
//  MatchingGame.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 1/29/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation

class MatchingGame {
  let scorer = MatchingGameScorer()
  var score: Int = 0
  var currentTurn: Turn
  var viewedCards: [TrumpCard?]
  
  init(cardCount: Int, cardsPerTurn: Int) {
    viewedCards = [TrumpCard?](count: cardCount, repeatedValue: nil)
    currentTurn = Turn(cardsPerTurn: cardsPerTurn)
  }
  
  func nextRound(cardCount: Int) {
    viewedCards = [TrumpCard?](count: cardCount, repeatedValue: nil)
    currentTurn.reset()
  }
  
  func updateTurn(cardIdx: Int, card: TrumpCard) -> (Bool, String) {
    if (currentTurn.done()) {
      currentTurn.reset()
    }

    currentTurn.lastIsRepeat = (viewedCards[cardIdx] != nil)
    
    if (!currentTurn.lastIsRepeat) { viewedCards[cardIdx] = card }
    
    currentTurn.addCard(cardIdx)
    
    var (turnScore, status) = getTurnStatus(currentTurn)
    
    if (currentTurn.done()) { score += turnScore }
    
    return ((turnScore > 0), status)
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
        return (mv, MatchingGame.matchMsg(cards, matchValue: mv))
      } else {
        if (turn.done()) {
          if (turn.lastIsRepeat) {
            mv = scorer.PenaltyPoints
          }
          return (mv, MatchingGame.mismatchMsg(cards, penaltyValue: mv))
        } else {
          return (0, "\(cards[0].label()), \(cards[1].label())")
        }
      }
    } else {
      return (0, "")
    }
  }
  
  func hasUnviewedCards() -> Bool {
    for card in viewedCards {
      if (card == nil) {
        NSLog("\(viewedCards)")
        return true }
    }
    
    return false
  }
  
  private func cardsFromTurn(turn: Turn) -> [TrumpCard] {
    var cards = turn.cardIndexes.map{
      (var i) -> TrumpCard in
      return self.viewedCards[i]!
    }
    
    return cards
  }
  
  private func matchValue(cardA: TrumpCard, cardB: TrumpCard) -> Int {
    if (!MatchingGame.isMatch(cardA, b: cardB)) {
      return 0
    } else if (MatchingGame.isBonusMatch(cardA, b: cardB)) {
      return (scorer.MatchPoints + scorer.BonusPoints)
    } else {
      return scorer.MatchPoints
    }
  }
  
  private func matchValueForCards(var cards: [TrumpCard]) -> Int {
    var matchVal = 0
    
    if (cards.count == 2) {
      matchVal = matchValue(cards[0], cardB: cards[1])
    } else if (cards.count == 3) {
      var tripleMatch = true
      
      for (idxA, idxB) in [(0, 1), (0, 2), (1, 2)] {
        var mv = self.matchValue(cards[idxA], cardB: cards[idxB])
        
        if (mv > matchVal) {
          matchVal = mv
        } else if (mv < 1) {
          tripleMatch = false
        }
      }
      
      if (tripleMatch) { matchVal *= scorer.BonusMultiplier }
    }
    
    return matchVal
  }
  
  // == Class Methods ===================================================
  
  class func isMatch(a: TrumpCard, b: TrumpCard) -> Bool {
    return a.rank == b.rank
  }
  
  class func isBonusMatch(a: TrumpCard, b: TrumpCard) -> Bool {
    return a.color() == b.color()
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

// == Struct Definitions ===================================================

struct Turn {
  var lastIsRepeat: Bool = false
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

struct MatchingGameScorer {
  let PenaltyPoints = -1
  let MatchPoints = 2
  let BonusPoints = 2
  let BonusMultiplier = 2
}