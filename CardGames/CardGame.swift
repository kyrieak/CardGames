//
//  CardCollectionDelegate.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation

protocol CardGame {
  typealias turnType
  
  var isOver: Bool { get }
  
  init(players: [String])
  
  func currentPlayer() -> Player
  
  func currentTurn() -> turnType
  
  func startNewTurn()
  
  func getScoreForCurrentPlayer() -> Int
}


protocol GameRecorder {
  var gameHistory: [[String]] { get }

  static func recordCategory() -> String
}


protocol Turn {  
  var hasEnded: Bool { get }
  
  init()

  func done() -> Bool
  
  mutating func endTurn()
  
  mutating func reset()
}


class TurnKeeper {
  let singlePlayer: Bool
  let players: [Player]
  var currentPlayer: Player
  
  private var currentPlayerIdx: Int
  private var lastPlayerIdx: Int
  
  init(playerNames: [String]) {
    var tmp:[Player] = []
    
    for (idx, name) in enumerate(playerNames) {
      tmp.append(Player(key: idx, name: name))
    }
    
    players          = tmp
    singlePlayer     = (players.count < 2)
    currentPlayer    = players[0]
    currentPlayerIdx = 0
    lastPlayerIdx    = players.count - 1
  }

  
  init() {
    singlePlayer = true
    players = [Player(key: 0, name: "Player")]
    currentPlayer = players[0]
    currentPlayerIdx = 0
    lastPlayerIdx = players.count - 1
  }
  
  convenience init(numPlayers: Int) {
    var defaultNames = [1...numPlayers].map({ (num) -> String in
      return "Player \(num)"
    })
    
    self.init(playerNames: defaultNames)
  }
    
  func startNewTurn() {
    if (!singlePlayer) {
      if (currentPlayerIdx < lastPlayerIdx) {
        currentPlayerIdx += 1
      } else {
        currentPlayerIdx = 0
      }
      
      currentPlayer = players[currentPlayerIdx]
    }
  }

  func nextPlayer() -> Player {
    if (singlePlayer) {
      return currentPlayer
    } else {
      if (currentPlayerIdx < lastPlayerIdx) {
        return players[currentPlayerIdx + 1]
      } else {
        return players[0]
      }
    }
  }
  
  func playerWithKey(key: Int) -> String? {
    if (!((key > (players.count - 1)) || (key < 0))) {
      return players[key].name
    } else {
      return nil
    }
  }
  
  func playerKeys() -> [Int] {
    return players.map({(p: Player) -> Int in
             return p.key
           })
  }
}

struct Player: Hashable {
  let key: Int
  let name: String
  let hashValue: Int
  
  init(key: Int, name: String) {
    self.key = key
    self.name = name
    self.hashValue = key
  }
}

func ==(lhs: Player, rhs: Player) -> Bool {
  return lhs.key == rhs.key
}