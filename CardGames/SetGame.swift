//
//  SetGame.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

//struct Player: Hashable {
//  let key: Int
//  let name: String
//  let hashValue: Int
//  
//  init(key: Int, name: String) {
//    self.key = key
//    self.name = name
//    self.hashValue = key
//  }
//}
//
//func ==(lhs: Player, rhs: Player) -> Bool {
//  return lhs.key == rhs.key
//}


class SetGame: CardGame {
  typealias turnType = SetTurn
  
  private var turnKeeper: SetTurnKeeper
  private var cardsInPlay: [SetCard?] = []
  private var deck: Deck<SetCard>     = SetGame.standardDeck()
  private var scores: [Player: Int]   = [Player: Int]()
  var isOver: Bool = false
  
  required init(players: [String]) {
    turnKeeper = SetTurnKeeper(playerNames: players)
    
    for player in turnKeeper.players {
      scores[player] = 0
    }
    
    startNewRound(15)
  }
  
  convenience init(numPlayers: Int) {
    var playerNames = (1...numPlayers).map({(num: Int) -> String in
      return "Player \(num)"
    })
    
    self.init(players: playerNames)
  }
  
  
  class func standardDeck() -> Deck<SetCard> {
    var deck = Deck<SetCard>()
    
    for i in 0...9 {
      for shape in ["▲", "●", "■"] {
        deck.addCard(SetCard(shape: shape, color: UIColor.redColor()))
        deck.addCard(SetCard(shape: shape, color: UIColor.blueColor()))
        deck.addCard(SetCard(shape: shape, color: UIColor.greenColor()))
      }
    }
    
    deck.shuffle()
    
    return deck
  }
  
  
  func startNewRound(numCards: Int) {
    cardsInPlay = []
    
    if (deck.cards.count < 3) {
      endGame()
    } else if (numCards > deck.cards.count) {
      while (deck.cards.count > 0) {
        cardsInPlay.append(deck.removeTopCard())
      }
    } else {
      for i in 1...numCards {
        cardsInPlay.append(deck.removeTopCard())
      }
    }
  }
  
  
  func endGame() {
    isOver = true
  }
  
  
  func startNewTurn() {
    turnKeeper.startNewTurn()
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
        cardsInPlay[idx] = nil
      }
    }

    turnKeeper.endTurn()
  }
  
  
  func currentTurn() -> SetTurn {
    return turnKeeper.currentTurn
  }
  
  
  func waitingNextTurn() -> Bool {
    let turn = currentTurn()
    
    return (turn.done() && !turn.hasEnded)
  }

  
  func currentPlayer() -> Player {
    return turnKeeper.currentPlayer
  }
  
  
  func nextPlayer() -> Player {
    return turnKeeper.nextPlayer()
  }

  
  func isSinglePlayer() -> Bool {
    return turnKeeper.singlePlayer
  }

  
  func isMultiPlayer() -> Bool {
    return !turnKeeper.singlePlayer
  }
  
  
  func getScoreForPlayer(p: Player) -> Int {
    return scores[p]!
  }
  
  
  func getScoreForCurrentPlayer() -> Int {
    return getScoreForPlayer(currentPlayer())
  }

  
  func getCardAt(idx: Int) -> SetCard? {
    return cardsInPlay[idx]
  }

  
  func hasCardAt(idx: Int) -> Bool {
    return getCardAt(idx) != nil
  }
  
  
  func getSelectedCards() -> [SetCard] {
    let cards = currentTurn().cardIndexes.map({(idx: Int) -> SetCard in
      return self.cardsInPlay[idx]!
    })
    
    return cards
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
  
  
  func numberOfCardPositions() -> Int {
    return cardsInPlay.count
  }
  


  
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
}


// =============================================================

class SetTurnKeeper: TurnKeeper {
  var currentTurn: SetTurn
  
  override init(playerNames: [String]) {
    currentTurn = SetTurn()
    
    super.init(playerNames: playerNames)
  }
  
  
  override func startNewTurn() {
    super.startNewTurn()
    
    currentTurn.reset()
  }
  
  
  func endTurn() {
    currentTurn.endTurn()
  }

  
  func updateTurn(cardIdx: Int) {
    currentTurn.addCardIdx(cardIdx)
  }
  
  func updateTurn(isSet: Bool, setValue: Int) {
    currentTurn.didMakeSet = isSet
    currentTurn.setValue = setValue
  }
}


// =============================================================


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