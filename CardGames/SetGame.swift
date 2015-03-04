//
//  SetGame.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGame: CardGame {
  typealias turnType = SetTurn
  
  private var turnKeeper: SetTurnKeeper
  
  private var cardsInPlay: [SetCard?] = []
  private var cardsInDeck: [SetCard]  = SetGame.standardDeck()
  private var scores: [String: Int]   = [String: Int]()
  
  required init(players: [String]) {
    for (idx, name) in enumerate(players) {
      var key = name + " \(idx + 1)"
      
      scores[key] = 0
    }
    
    turnKeeper = SetTurnKeeper(playerKeys: scores.keys.array)
    startNewRound(15)
  }
  
  convenience init(numPlayers: Int) {
    var playerNames = (1...numPlayers).map({(num: Int) -> String in
      return "Player"
    })
    
    self.init(players: playerNames)
  }
  
  
  func updateTurn(cardIdx: Int) {
    if (!currentTurn().done()) {
      turnKeeper.updateTurn(cardIdx)
    }
    
    if (currentTurn().done()) {
      let (isSet, setValue) = evaluateSet(getSelectedCards())

      turnKeeper.updateTurn(isSet, setValue: setValue)

      scores[currentPlayer()]! += setValue
    }
  }
  
  func endTurn() {
    if (currentTurn().didMakeSet) {
      for idx in currentTurn().cardIndexes {
        NSLog("will set index: \(idx) to nil here")
        cardsInPlay[idx] = nil
      }
    }

    turnKeeper.endTurn()
  }
  
  func startNewRound(numCards: Int) {
    if (numCards > cardsInDeck.count) {
      cardsInPlay = cardsInDeck
      cardsInDeck = []
    } else {
      cardsInPlay = []
      
      for i in 1...numCards {
        cardsInPlay.append(cardsInDeck.removeLast())
      }
    }
  }

  
  func startNewTurn() {
    turnKeeper.startNewTurn()
  }
  
  
  func currentTurn() -> SetTurn {
    return turnKeeper.currentTurn
  }
  
  
  func waitingNextTurn() -> Bool {
    return turnKeeper.waitingNextTurn()
  }

  
  func currentPlayer() -> String {
    return turnKeeper.currentPlayer
  }
  
  
  func nextPlayer() -> String {
    return turnKeeper.nextPlayer()
  }

  
  func isSinglePlayer() -> Bool {
    return turnKeeper.singlePlayer
  }

  
  func isMultiPlayer() -> Bool {
    return !turnKeeper.singlePlayer
  }
  
  
  func getCurrentPlayerScore() -> Int {
    return scores[currentPlayer()]!
  }

  
  func getCardsInPlay() -> [SetCard?] {
    return cardsInPlay
  }
  
  
  func getCardAt(idx: Int) -> SetCard? {
    return cardsInPlay[idx]
  }
  
  func getCardsAt(indexes: [Int]) -> [SetCard?] {
    let cards = indexes.map({(idx: Int) -> SetCard? in
      return self.cardsInPlay[idx]
    })
    
    return cards
  }
  
  func getSelectedCards() -> [SetCard] {
    NSLog("\(currentTurn().cardIndexes)")
    let cards = currentTurn().cardIndexes.map({(idx: Int) -> SetCard in
      NSLog("idx: \(idx)")
      NSLog("card count is ========= \(self.cardsInPlay.count)")
      return self.cardsInPlay[idx]!
    })
    
    return cards
  }
  
  
  func getTurnScore() -> Int {
    return currentTurn().setValue
  }
  
  
  func evaluateSet(cards: [SetCard]) -> (Bool, Int) {
    if (cards.count != 3) {
      return (false, 0)
    } else {
      let (cardA, cardB, cardC) = (cards[0], cards[1], cards[2])
      
      let shapeSet = isSameOrUnique(cards.map({(card: SetCard) -> String in
        return card.shape
      }))
      
      let colorSet = isSameOrUnique(cards.map({(card: SetCard) -> UIColor in
        return card.color
      }))
      
      if (shapeSet && colorSet) {
        return (true, 6)
      } else {
        return (false, 0)
      }      
    }
  }
  
//  private func isSameOrUnique(values: [String]) -> Bool {
//    if (values.count != 3) {
//      return false
//    } else {
//      let (v1, v2, v3) = (values[0], values[1], values[2])
//
//      if ((v1 == v2) && (v1 == v3)) {
//        return true
//      } else if ((v1 != v2) && (v1 != v3) && (v2 != v3)) {
//        return true
//      } else {
//        return false
//      }
//    }
//  }

  
  private func isSameOrUnique(values: [UIColor]) -> Bool {
    if (values.count != 3) {
      return false
    } else {
      let (v1, v2, v3) = (values[0], values[1], values[2])
      
      if ((v1 == v2) && (v1 == v3)) {
        return true
      } else if ((v1 != v2) && (v1 != v3) && (v2 != v3)) {
        return true
      } else {
        return false
      }
    }
  }

  
  private func isSameOrUnique(values: [String]) -> Bool {
    if (values.count != 3) {
      return false
    } else {
      let (v1, v2, v3) = (values[0], values[1], values[2])
      
      if ((v1 == v2) && (v1 == v3)) {
        return true
      } else if ((v1 != v2) && (v1 != v3) && (v2 != v3)) {
        return true
      } else {
        return false
      }
    }
  }

  
  class func standardDeck() -> [SetCard] {
    var deck: [SetCard] = []
    for i in 0...9 {
      for shape in ["▲", "●", "■"] {
        deck.append(SetCard(shape: shape, color: UIColor.redColor()))
        deck.append(SetCard(shape: shape, color: UIColor.blueColor()))
        deck.append(SetCard(shape: shape, color: UIColor.greenColor()))
      }
    }
    
    return deck
  }
}


class SetTurnKeeper: TurnKeeper {
  var currentTurn: SetTurn
  
  override init(playerKeys: [String]) {
    currentTurn = SetTurn()
    
    super.init(playerKeys: playerKeys)
  }
  
  
  override func startNewTurn() {
    super.startNewTurn()
    
    currentTurn.reset()
  }
  
  
  func endTurn() {
    currentTurn.endTurn()
  }

  
  func waitingNextTurn() -> Bool {
    return (currentTurn.done() && !currentTurn.hasEnded)
  }

  func updateTurn(cardIdx: Int) {
    currentTurn.addCardIdx(cardIdx)
  }
  
  func updateTurn(isSet: Bool, setValue: Int) {
    currentTurn.didMakeSet = isSet
    currentTurn.setValue = setValue
  }
}


struct SetTurn: Turn {
  var hasEnded: Bool
  var didMakeSet: Bool
  var setValue: Int
  var cardIndexes: [Int]
 
  let maxCards: Int = 3
  
  init() {
    hasEnded    = false
    didMakeSet  = false
    setValue    = 0
    cardIndexes = []
  }
  
  mutating func addCardIdx(idx: Int) {
    cardIndexes.append(idx)
  }

  mutating func reset() {
    didMakeSet = false
    setValue = 0
    hasEnded = false
    cardIndexes = []
  }
  
  mutating func endTurn() {
    hasEnded = true
  }

  func done() -> Bool {
    return !(cardIndexes.count < maxCards)
  }
}