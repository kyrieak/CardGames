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
  private(set) var settings: GameSettings
  private var scores: [Player: Int]

  private var deck: Deck<SetCard>     = SetGame.standardDeck()
  private(set) var cardsInPlay: [SetCard?] = []
  private(set) var currentMove: SGMove
  
  var players: [Player] {
    return settings.players
  }
  
  var options: GameOptions {
    return settings.options
  }
  
  
  required init(settings: GameSettings) {
    self.settings    = settings
    self.deck        = SetGame.customDeck(settings.options)
    self.scores      = SetGame.startingScores(settings.players)
    self.currentMove = SGMove()
    
    startNewRound(16)
  }
  
  class func customDeck(options: GameOptions) -> Deck<SetCard> {
    let deck = Deck<SetCard>()
    
    let shapeSet: [SGShape]     = (options.shapesOn ? SetGame.standardShapes() : [.Diamond, .Diamond, .Diamond])
    let colorSet: [SGColor]     = (options.colorsOn ? SetGame.standardColors() : [.Red, .Red, .Red])
    let shadingSet: [SGShading] = (options.shadingOn ? SetGame.standardShading() : [.Solid, .Solid, .Solid])
    
    for shape in shapeSet {
      for color in colorSet {
        for shading in shadingSet {
          for number in SetGame.standardNumbers() {
            deck.addCard(SetCard(number: number, shape: shape, color: color, shading: shading))
          }
        }
      }
    }
    
    deck.shuffle()

    return deck
  }
  
  
  class func startingScores(_players: [Player]) -> [Player: Int] {
    var _scores = [Player: Int]()
    
    for player in _players {
      _scores[player] = 0
    }
    
    return _scores
  }
  
  class func standardDeck() -> Deck<SetCard> {
    let deck = Deck<SetCard>()
    
    for shape in SetGame.standardShapes() {
      for color in SetGame.standardColors() {
        for shading in SetGame.standardShading() {
          for number in SetGame.standardNumbers() {
            deck.addCard(SetCard(number: number, shape: shape, color: color, shading: shading))
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
    return [.Diamond, .Oval, .Squiggle]
  }

  class func standardShading() -> [SGShading] {
    return [.Solid, .Striped, .Open]
  }
  
  class func standardColors() -> [SGColor] {
    return [.Red, .Green, .Purple]
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
      for _ in 1...numCards {
        cardsInPlay.append(deck.removeTopCard())
      }
    }
  }
  
  
  func endGame() {
    isOver = true
  }
  
  
  func makeMove(cardIndexes: [Int], playerKey: Int) {
    let player = getPlayer(playerKey)

    if (player != nil) {
      makeMove(cardIndexes, _player: player!)
    }
  }
  
  func getPlayer(key: Int) -> Player? {
    for p in players {
      NSLog("\(p.hashValue) hash and key \(key)")
      if (p.hashValue == key) {
        return p
      }
    }

    return nil
  }
  
  func makeMove(cardIndexes: [Int], _player: Player) {
    NSLog("here in make move for _player")
    var cardPositions = [Int: SetCard]()
    
    for index in cardIndexes {
      let cardAtIndex = cardsInPlay[index]!
      
      cardPositions[index] = cardAtIndex
    }
    
    currentMove.setCardPositions(cardPositions)
    
    if (currentMove.done) {
      updateScore(_player)
    }
  }
  
  
  func currentMoveIsASet() -> Bool {
    return moveIsASet(currentMove)
  }
  
  
  func moveIsASet(move: SGMove) -> Bool {
    if (move.done) {
      var _isASet = true
      
      if (options.shapesOn) {
        _isASet = (_isASet && move.isSameOrUniqueShape())
      }
      
      if (options.colorsOn) {
        _isASet = (_isASet && move.isSameOrUniqueColor())
      }
      
      if (options.shadingOn) {
        _isASet = (_isASet && move.isSameOrUniqueShading())
      }
      
      return _isASet
    } else {
      return false
    }
  }
  
  
  private func updateScore(_player: Player) {
    if (moveIsASet(currentMove)) {
        scores[_player]! += 5 // arbit
    } else {
        scores[_player]! -= 1 // arbit
    }
  }
  
  func endMove() {
    if (moveIsASet(currentMove)) {
      var indexes = Array(currentMove.cardPositions.keys)
      
      while (indexes.count > 0) {
        let idx = indexes[0]
        
        if (deck.cards.count > 0) {
          cardsInPlay[idx] = deck.removeTopCard()
        } else {
          cardsInPlay.removeAtIndex(idx)
        }
        indexes.removeFirst()
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
    return Array(currentMove.cardPositions.values)
  }
  
  func numberOfCardPositions() -> Int {
    return cardsInPlay.count
  }
  
}
// =============================================================


class SGMove {
//  private(set) var isASet: Bool = false
  private(set) var cardPositions: [Int: SetCard]
  
  var cards: [SetCard] {
    return Array(cardPositions.values)
  }

  var done: Bool {
    NSLog("cardPositions.count: \(cardPositions.count) cards")
    return cardPositions.count == 3
  }

  let maxCards: Int = 3
  
  init() {
    cardPositions = [Int: SetCard]()
  }
  
  init(_player: Player) {
    cardPositions = [Int: SetCard]()
  }

  func setCardPositions(_cardPositions: [Int: SetCard]) {
    if ((cardPositions.count == 0) &&
         (_cardPositions.count == 3)) {

          cardPositions = _cardPositions
          
          if (done) {
//            updateIsASet()
          }
    }
  }
  
  func reset() {
    cardPositions.removeAll(keepCapacity: true)
  }
  
  
  func isSameOrUniqueNumber() -> Bool {
    let nums = cards.map{(card: SetCard) -> Int in
      return card.number
    }
    
    return isSameOrUnique(nums)
  }
  
  
  func isSameOrUniqueShape() -> Bool {
    let shapes = cards.map{(card: SetCard) -> SGShape in
      return card.shape
    }
    
    return isSameOrUnique(shapes)
  }

  
  func isSameOrUniqueColor() -> Bool {
    let colors = cards.map{(card: SetCard) -> SGColor in
      return card.color
    }
    
    return isSameOrUnique(colors)
  }
  
  
  func isSameOrUniqueShading() -> Bool {
    let shadings = cards.map{(card: SetCard) -> SGShading in
      return card.shading
    }
    
    return isSameOrUnique(shadings)
  }
  
  
//  private func updateIsASet() {
//    if (cardPositions.count == 3) {
//      let cards = Array(cardPositions.values)
//      
//      var numbers: [Int]       = []
//      var colors: [SGColor]    = []
//      var shading: [SGShading] = []
//      var shapes: [SGShape]    = []
//      
//      for card in cards {
//        numbers.append(card.number)
//        colors.append(card.color)
//        shading.append(card.shading)
//        shapes.append(card.shape)
//      }
//      
//      isASet = (isSameOrUnique(colors) &&
//              isSameOrUnique(shading) &&
//              isSameOrUnique(shapes) &&
//              isSameOrUnique(numbers))
//    } else {
//      isASet = false
//    }
//  }
  
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


struct GameOptions {
  var colorsOn, shapesOn, shadingOn: Bool
  
  init(shapesOn: Bool, colorsOn: Bool, shadingOn: Bool) {
    self.shapesOn   = shapesOn
    self.colorsOn   = colorsOn
    self.shadingOn  = shadingOn
  }
  
  static func defaultOptions() -> GameOptions {
    return GameOptions(shapesOn: true, colorsOn: true, shadingOn: true)
  }
}


class GameSettings {
  var players: [Player]
  var options: GameOptions
  
  var numPlayers: Int {
    return players.count
  }
  
  init(players: [Player], options: GameOptions) {
    self.players = players
    self.options = options
  }
  
  convenience init(players: [Player]) {
    self.init(players: players, options: GameOptions.defaultOptions())
  }
}

//    let red = UIColor(red: 0.875, green: 0.259, blue: 0.302, alpha: 2.0)
//    let green = UIColor(red: 0.102, green: 0.694, blue: 0.365, alpha: 2.0)
//    let purple = UIColor(red: 0.286, green: 0.2, blue: 0.565, alpha: 2.0)
//
