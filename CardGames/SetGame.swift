//
//  SetGame.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGame {
  var isOver: Bool = false
  
  private(set) var players: [Player]
  private var scores: [Player: Int]

  private var deck: Deck<SetCard>     = SetGame.standardDeck()
  private(set) var cardsInPlay: [SetCard?] = []
  
  private(set) var currentMove: SGMove
  
  required init(_players: [Player]) {
    players     = _players
    scores      = SetGame.startingScores(players)
    currentMove = SGMove()
    
    startNewRound(15)
  }
  
  convenience init(numPlayers: Int) {
    var numberedPlayers = (1...numPlayers).map({(num: Int) -> Player in
      return Player(key: num, name: "Player \(num)")
    })
    
    self.init(_players: numberedPlayers)
  }
  
  
  class func startingScores(_players: [Player]) -> [Player: Int] {
    var _scores = [Player: Int]()
    
    for player in _players {
      _scores[player] = 0
    }
    
    return _scores
  }
  
  class func standardDeck() -> Deck<SetCard> {
    var deck = Deck<SetCard>()
    
    for shape in SetGame.standardShapes() {
      for color in SetGame.standardColors() {
        for shading in SetGame.standardShading() {
          for number in SetGame.standardNumbers() {
            deck.addCard(SetCard(shape: shape, color: color, shading: shading, number: number))
          }
        }
      }
    }
    
    deck.shuffle()
    
    return deck
  }
  
  class func standardNumbers() -> [Int] {
    return [1, 2, 3]
  }
  
  class func standardShapes() -> [SGShape] {
    return [SGShape.Diamond, SGShape.Oval, SGShape.Squiggle]
  }

  class func standardShading() -> [SGShading] {
    return [SGShading.Solid, SGShading.Striped, SGShading.Open]
  }
  
  class func standardColors() -> [SGColor] {
    return [SGColor.Red, SGColor.Green, SGColor.Purple]
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
  
  
  func makeMove(cardIndexes: [Int], _player: Player) {
    var cardPositions = [Int: SetCard]()
    
    for index in cardIndexes {
      var cardAtIndex = cardsInPlay[index]!
      
      cardPositions[index] = cardAtIndex
    }
    
    currentMove.setCardPositions(cardPositions)
    
    if (currentMove.done) {
      updateScore(_player)
    }
  }
  
  private func updateScore(_player: Player) {
    if (currentMove.isASet) {
        scores[_player]! += 5 // arbit
    } else {
        scores[_player]! -= 1 // arbit
    }
  }
  
  func endMove() {
    if (currentMove.done && currentMove.isASet) {
      for idx in currentMove.cardPositions.keys.array {
        cardsInPlay[idx] = nil
      }
    }
    
    currentMove.reset()
  }

  
  func isSinglePlayer() -> Bool {
    return (players.count < 2)
  }

  
  func isMultiPlayer() -> Bool {
    return !isSinglePlayer()
  }
  
  
  func getScoreForPlayer(p: Player) -> Int {
    return scores[p]!
  }
  
  func getCardAt(idx: Int) -> SetCard? {
    return cardsInPlay[idx]
  }

  
  func hasCardAt(idx: Int) -> Bool {
    return getCardAt(idx) != nil
  }
  
  
  func getSelectedCards() -> [SetCard] {
    let cards = currentMove.cardPositions.values.array
    
    return cards
  }
  
  func numberOfCardPositions() -> Int {
    return cardsInPlay.count
  }
  
}
// =============================================================


class SGMove {
  private(set) var isASet: Bool = false
//  private(set) var player: Player?
  private(set) var cardPositions: [Int: SetCard]

  var done: Bool {
    NSLog("counting: \(cardPositions.count) cards")
    return cardPositions.count == 3
  }

  let maxCards: Int = 3
  
  init() {
    cardPositions = [Int: SetCard]()
  }
  
  init(_player: Player) {
//    player = _player
    cardPositions = [Int: SetCard]()
  }

//  func setPlayer(_player: Player) {
//    if (player == nil) {
//      player = _player
//    }
//  }
  
  func setCardPositions(_cardPositions: [Int: SetCard]) {
    if ((cardPositions.count == 0) &&
         (_cardPositions.count == 3)) {

          cardPositions = _cardPositions
          
          if (done) {
            updateIsASet()
          }
    }
  }
  
  func reset() {
//    player = nil
    cardPositions.removeAll(keepCapacity: true)
  }
  

  
  private func updateIsASet() {
    if (cardPositions.count == 3) {
      let cards = cardPositions.values.array
      
      var numbers: [Int]       = []
      var colors: [SGColor]    = []
      var shading: [SGShading] = []
      var shapes: [SGShape]    = []
      
      for card in cards {
        numbers.append(card.number)
        colors.append(card.color)
        shading.append(card.shading)
        shapes.append(card.shape)
      }
      
      isASet = (isSameOrUnique(colors) &&
              isSameOrUnique(shading) &&
              isSameOrUnique(shapes) &&
              isSameOrUnique(numbers))
    } else {
      isASet = false
    }
  }
  
  private func isSameOrUnique<T: Hashable>(values: [T]) -> Bool {
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

//    let red = UIColor(red: 0.875, green: 0.259, blue: 0.302, alpha: 2.0)
//    let green = UIColor(red: 0.102, green: 0.694, blue: 0.365, alpha: 2.0)
//    let purple = UIColor(red: 0.286, green: 0.2, blue: 0.565, alpha: 2.0)
//
