////
////  MemoryGame.swift
////  CardGames
////
////  Created by Kyrie Kopczynski on 1/29/15.
////  Copyright (c) 2015 Kyrie. All rights reserved.
////
//
//import Foundation
//
//class MemoryGame: CardGame {
//  let scorer = MemoryGameScorer()
//  var scores: [String: Int] = [String: Int]()
//  var currentTurn: MemoryTurn
//  var viewedCards: [TrumpCard?]
//  var turnKeeper: MemoryTurnKeeper
//  
//  required init(players: [String]) {
//    for (idx, name) in enumerate(players) {
//      scores[name + " \(idx + 1)"] = 0
//    }
//    
//    turnKeeper = MemoryTurnKeeper(playerKeys: players)
//    currentTurn = turnKeeper.currentTurn
//  }
//  
//  init(cardCount: Int, cardsPerTurn: Int) {
//    viewedCards = [TrumpCard?](count: cardCount, repeatedValue: nil)
//    currentTurn = MemoryTurn(cardsPerTurn: cardsPerTurn)
//  }
//  
//  func nextRound(cardCount: Int) {
//    viewedCards = [TrumpCard?](count: cardCount, repeatedValue: nil)
//    currentTurn.reset()
//  }
//  
//  func updateTurn(turn: MemoryTurn) {
//    turnKeeper.currentTurn = turn
//  }
//  
//  func startNewTurn() -> MemoryTurn {
//    turnKeeper.startNextTurn()
//    
//    return turnKeeper.currentTurn
//  }
//  
//  func updateTurn(cardIdx: Int, card: TrumpCard) -> (Bool, String) {
//    if (currentTurn.done()) {
//      currentTurn.reset()
//    }
//
////    currentTurn.lastIsRepeat = (viewedCards[cardIdx] != nil)
////    
////    if (!currentTurn.lastIsRepeat) { viewedCards[cardIdx] = card }
//    
//    currentTurn.addCard(cardIdx)
//    
//    var (turnScore, status) = getTurnStatus(currentTurn)
//    
//    turnKeeper.updateTurn(currentTurn)
//    
////    if (currentTurn.done()) { score += turnScore }
//    
//    return ((turnScore > 0), status)
//  }
//  
//  func evaluateMatchScore() -> Int {
//    var cards = currentTurn.cardIndexes.map({ (idx) -> TrumpCard in
//      return self.viewedCards[idx]!
//    })
//    
//    return 0
//  }
//  
//
//  
//  func evaluateTurnScore() -> Int {
//    var cards = turnKeeper.currentTurn.cardIndexes
//    
//    return 0
//  }
//  
//  
//  func getScore() -> Int {
//    return scores[turnKeeper.currentPlayer]!
//  }
//  
//  func getTurnStatus(turn: Turn) -> (Int, String) {
//    var cards = cardsFromTurn(currentTurn)
//    
//    if (cards.count == 1) {
//      return (0, "\(cards[0].label())")
//    } else if (cards.count > 1) {
//      var mv = matchValueForCards(cards)
//      
//      if (mv > 0) {
//        return (mv, MemoryGame.matchMsg(cards, matchValue: mv))
//      } else {
//        if (turn.done()) {
//          if (turn.lastIsRepeat) {
//            mv = scorer.PenaltyPoints
//          }
//          return (mv, MemoryGame.mismatchMsg(cards, penaltyValue: mv))
//        } else {
//          return (0, "\(cards[0].label()), \(cards[1].label())")
//        }
//      }
//    } else {
//      return (0, "")
//    }
//  }
//  
//  func hasUnviewedCards() -> Bool {
//    for card in viewedCards {
//      if (card == nil) {
//        NSLog("\(viewedCards)")
//        return true }
//    }
//    
//    return false
//  }
//  
//  private func cardsFromTurn(turn: Turn) -> [TrumpCard] {
//    var cards = turn.cardIndexes.map{
//      (var i) -> TrumpCard in
//      return self.viewedCards[i]!
//    }
//    
//    return cards
//  }
//  
//  private func matchValue(cardA: TrumpCard, cardB: TrumpCard) -> Int {
//    if (!MemoryGame.isMatch(cardA, b: cardB)) {
//      return 0
//    } else if (MemoryGame.isBonusMatch(cardA, b: cardB)) {
//      return (scorer.MatchPoints + scorer.BonusPoints)
//    } else {
//      return scorer.MatchPoints
//    }
//  }
//  
//  private func matchValueForCards(var cards: [TrumpCard]) -> Int {
//    var matchVal = 0
//    
//    if (cards.count == 2) {
//      matchVal = matchValue(cards[0], cardB: cards[1])
//    } else if (cards.count == 3) {
//      var tripleMatch = true
//      
//      for (idxA, idxB) in [(0, 1), (0, 2), (1, 2)] {
//        var mv = self.matchValue(cards[idxA], cardB: cards[idxB])
//        
//        if (mv > matchVal) {
//          matchVal = mv
//        } else if (mv < 1) {
//          tripleMatch = false
//        }
//      }
//      
//      if (tripleMatch) { matchVal *= scorer.BonusMultiplier }
//    }
//    
//    return matchVal
//  }
//  
//  // == Class Methods ===================================================
//  
//  class func isMatch(a: TrumpCard, b: TrumpCard) -> Bool {
//    return a.rank == b.rank
//  }
//  
//  class func isBonusMatch(a: TrumpCard, b: TrumpCard) -> Bool {
//    return a.color() == b.color()
//  }
//  
//  class func matchMsg(cards: [TrumpCard], matchValue: Int) -> String {
//    var statusMsg = "Matched "
//    
//    if (cards.count == 2) {
//      statusMsg += "\(cards[0].label()) and \(cards[1].label())"
//    } else if (cards.count == 3) {
//      statusMsg += "\(cards[0].label()), \(cards[1].label()), and \(cards[2].label())"
//    }
//    
//    statusMsg += " for \(matchValue) Points!"
//    
//    return statusMsg
//  }
//  
//  class func mismatchMsg(cards: [TrumpCard], penaltyValue: Int) -> String {
//    var statusMsg = ""
//    
//    if (cards.count == 2) {
//      statusMsg = "\(cards[0].label()) and \(cards[1].label()) do not match."
//    } else if (cards.count == 3) {
//      statusMsg = "\(cards[0].label()), \(cards[1].label()), and \(cards[2].label()) do not match."
//    }
//    
//    if (penaltyValue == 0) {
//      return statusMsg + " No penalty"
//    } else {
//      return statusMsg + " \(abs(penaltyValue)) point penalty :("
//    }
//  }
//}
//
////// == Struct Definitions ===================================================
////
//
//
//struct MemoryGameScorer {
//  let PenaltyPoints = -1
//  let MatchPoints = 2
//  let BonusPoints = 2
//  let BonusMultiplier = 2
//}
//
//
//class MemoryTurnKeeper: TurnKeeper {
//  var currentTurn: MemoryTurn
//  
//  override init(playerKeys: [String]) {
//    currentTurn = MemoryTurn()
//    
//    super.init(playerKeys: playerKeys)
//  }
//  
//  init(playerKeys: [String], cardsPerTurn: Int) {
//    currentTurn = MemoryTurn(cardsPerTurn: cardsPerTurn)
//    
//    super.init(playerKeys: playerKeys)
//  }
//  
//  override func startNextTurn() {
//    super.startNextTurn()
//    
//    currentTurn.reset()
//  }
//}
//
//
//struct MemoryTurn: Turn {
//  let maxCards: Int
//  
//  var cardIndexes: [Int] = []
//  var hasEnded: Bool = false
//  
//  init() {
//    maxCards = 2
//  }
//  
//  init(cardsPerTurn: Int) {
//    maxCards = cardsPerTurn
//  }
//  
//  func done() -> Bool {
//    return !(cardIndexes.count < maxCards)
//  }
//  
//  mutating func addCard(cardIdx: Int) {
//    cardIndexes.append(cardIdx)
//  }
//  
//  mutating func endTurn() {
//    hasEnded = true
//  }
//  
//  mutating func reset() {
//    hasEnded = false
//    cardIndexes = []
//  }
//}
//
//
