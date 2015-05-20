////
////  MemoryGame.swift
////  CardGames
////
////  Created by Kyrie Kopczynski on 1/29/15.
////  Copyright (c) 2015 Kyrie. All rights reserved.
////

import Foundation

class MemoryGame: CardGame {
  typealias turnType = MemoryTurn
  
  let scorer = MGScorer()
  
  private var turnKeeper: MemoryTurnKeeper
  private var cardsInPlay: [MGPosition]
  private var deck: Deck<TrumpCard> = MemoryGame.standardDeck()
  private var scores: [Player: Int] = [Player: Int]()
  var isOver: Bool = false
  
  required init(players: [String]) {
    turnKeeper = MemoryTurnKeeper(playerNames: players, cardsPerTurn: 2)
    
    for player in turnKeeper.players {
      scores[player] = 0
    }

    cardsInPlay = []
    startNewRound(10)
  }
  
  convenience init() {
    self.init(players: ["Player"])
  }
  
  // == UNIMPLEMENTED ================================================
  
  func currentPlayer() -> Player {
    return turnKeeper.currentPlayer
  }
  
  
  func nextPlayer() -> Player {
    return turnKeeper.nextPlayer()
  }
  
  
  func currentTurn() -> MemoryTurn {
    return turnKeeper.currentTurn
  }
  
  
  func startNewTurn() {
    turnKeeper.startNewTurn()
  }
  

  func updateTurn(idx: Int) {
    if (!currentTurn().done()) {
//      cardsInPlay[idx].hasBeenViewed = true
      
      turnKeeper.updateTurn(idx)
    }
    
    if (currentTurn().done()) {
      var indexes = currentTurn().cardIndexes
      var (mv, pv): (Int, Int)
      
      if (currentTurn().cardsPerTurn == 3) {
        (mv, pv) = evaluateThreeMatch(getSelectedPositions())
      } else {
        (mv, pv) = evaluateMatch(getSelectedPositions())
      }
      
      turnKeeper.updateTurn(mv, penaltyValue: pv)
      
      scores[currentPlayer()]! += (mv + pv)
    }
  }
  
  
  func endTurn() {
    let matched = currentTurn().didMatch
    
    for idx in currentTurn().cardIndexes {
      cardsInPlay[idx].hasBeenViewed = true

      if (matched) {
        cardsInPlay[idx].card = nil
      }
    }

    turnKeeper.endTurn()
  }
  
  
  func waitingNextTurn() -> Bool {
    return (currentTurn().done() && !currentTurn().hasEnded)
  }
  
  
  func getScoreForCurrentPlayer() -> Int {
    return scores[currentPlayer()]!
  }

  
  func getScoreForPlayer(player: Player) -> Int {
    return scores[player]!
  }

  // == endof UNIMPLEMENTED ================================================

  
  func numberOfCardPositions() -> Int {
    return cardsInPlay.count
  }
  
  
  func getCardAt(idx: Int) -> TrumpCard? {
    return cardsInPlay[idx].card
  }
  
  
  func hasCardAt(idx: Int) -> Bool {
    return (cardsInPlay[idx].card != nil)
  }

  
  func startNewRound(numCards: Int) {
    cardsInPlay = []
    
    if (deck.cards.count < 3) {
      endGame()
    } else if (numCards > deck.cards.count) {
      while (deck.cards.count > 0) {
        cardsInPlay.append(MGPosition(card: deck.removeTopCard()))
      }
    } else {
      for i in 1...numCards {
        cardsInPlay.append(MGPosition(card: deck.removeTopCard()))
      }
    }
    
    turnKeeper.startNewTurn()
  }
  
  
  func endGame() {
    isOver = true
  }
  
  
  func isMultiPlayer() -> Bool {
    return !isSinglePlayer()
  }
  
  
  func isSinglePlayer() -> Bool {
    return turnKeeper.players.count < 2
  }
  
  
  func getSelectedCards() -> [TrumpCard] {
    return currentTurn().cardIndexes.map({(idx: Int) -> TrumpCard in
      return self.cardsInPlay[idx].card!
    })
  }

  
  func evaluateMatch(positions: [MGPosition]) -> (matchValue: Int, penaltyValue: Int) {
    let (posA, posB) = (positions[0], positions[1])
    let (rankMatch, colorMatch) = match(posA.card!, cardB: posB.card!)

    var (mval, pval) = (0, 0)
    
    if (rankMatch) {
      mval = scorer.MatchPoints

      if (colorMatch) { mval += scorer.BonusPoints }
      
    } else if (posB.hasBeenViewed) {
      pval = scorer.PenaltyPoints
    }
    
    return (matchValue: mval, penaltyValue: pval)
  }
  
  
  func evaluateThreeMatch(positions: [MGPosition]) -> (matchValue: Int, penaltyValue: Int) {
    let (posA, posB, posC) = (positions[0], positions[1], positions[2])
    
    let (rankMatch, colorMatch, threeMatch) = matchThree(posA.card!, cardB: posB.card!, cardC: posC.card!)

    var (mval, pval) = (0, 0)
    
    if (rankMatch) {
      mval = scorer.MatchPoints
      
      if (colorMatch) { mval += scorer.BonusPoints }
      if (threeMatch) { mval *= scorer.BonusMultiplier }
      
    } else if (posC.hasBeenViewed) {
      pval = scorer.PenaltyPoints
    }

    return (matchValue: mval, penaltyValue: pval)
  }
  
  
  private func getSelectedPositions() -> [MGPosition] {
    return currentTurn().cardIndexes.map({(idx: Int) -> MGPosition in
      return self.cardsInPlay[idx]
    })
  }

  
  private func match(cardA: TrumpCard, cardB: TrumpCard) -> (rankMatch: Bool, colorMatch: Bool) {
    return ((cardA.rank == cardB.rank), (cardA.color() == cardB.color()))
  }
  
  
  private func matchThree(cardA: TrumpCard, cardB: TrumpCard, cardC: TrumpCard) -> (rankMatch: Bool, colorMatch: Bool, threeMatch: Bool) {
    
    var colorMatch = (cardA.color() == cardB.color()) && (cardB.color() == cardC.color())
    
    var m1 = (cardA.rank == cardB.rank)
    var m2 = (cardB.rank == cardC.rank)
    
    var isMatch = (m1 || m2) || (cardA.rank == cardC.rank)
    
    return (isMatch, colorMatch, (m1 && m2))
  }


  // == Class Methods ==================================================

  
  class func standardDeck() -> Deck<TrumpCard> {
    var deck = TrumpCard.standardDeck()

    deck.shuffle()
    
    return deck
  }
}
//
////// == Struct Definitions ===================================================
////


struct MGScorer {
  let PenaltyPoints = -1
  let MatchPoints = 2
  let BonusPoints = 2
  let BonusMultiplier = 2
}


class MemoryTurnKeeper: TurnKeeper {
  var currentTurn: MemoryTurn
  
  override init(playerNames: [String]) {
    currentTurn = MemoryTurn()
    
    super.init(playerNames: playerNames)
  }
  
  init(playerNames: [String], cardsPerTurn: Int) {
    currentTurn = MemoryTurn(cardsPerTurn: cardsPerTurn)
    
    super.init(playerNames: playerNames)
  }
  
  override func startNewTurn() {
    super.startNewTurn()
    
    currentTurn.reset()
  }
  
  func updateTurn(idx: Int) {
    currentTurn.addCardIdx(idx)
  }
  
  func updateTurn(matchValue: Int, penaltyValue: Int) {
    currentTurn.didMatch   = (matchValue > 0)
    currentTurn.matchValue = matchValue
    currentTurn.penaltyValue = penaltyValue
  }
  
  func endTurn() {
    currentTurn.endTurn()
  }
}


struct MemoryTurn: Turn {
  let cardsPerTurn: Int

  var hasEnded: Bool     = false
  var didMatch: Bool     = false
  var matchValue: Int    = 0
  var penaltyValue: Int    = 0
  var cardIndexes: [Int] = []
  
  init() {
    cardsPerTurn = 2
  }
  
  init(cardsPerTurn: Int) {
    self.cardsPerTurn = cardsPerTurn
  }
  
  func done() -> Bool {
    return !(cardIndexes.count < cardsPerTurn)
  }
  
  mutating func addCardIdx(idx: Int) {
    cardIndexes.append(idx)
  }
  
  mutating func endTurn() {
    hasEnded = true
  }
  
  mutating func reset() {
    hasEnded = false
    cardIndexes = []
  }
}

struct MGPosition {
  var card: TrumpCard?
  var hasBeenViewed: Bool
  
  init() {
    hasBeenViewed = false
  }
  
  init(card: TrumpCard) {
    self.card = card
    hasBeenViewed = false
  }
  
  mutating func reset(replacementCard: TrumpCard?) {
    card = replacementCard
    hasBeenViewed = false
  }
}