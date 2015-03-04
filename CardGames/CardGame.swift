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
  
  init(players: [String])
  
  func currentPlayer() -> String
  
  func currentTurn() -> turnType
  
  func startNewTurn()

//  func updateTurn(turn: turnType)
//  
//  func endTurn(inout turn: turnType)
  
  func getCurrentPlayerScore() -> Int
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
  let players: [String]
  var currentPlayer: String
  
  private var currentPlayerIdx: Int
  private var lastPlayerIdx: Int
  
  init(playerKeys: [String]) {
    players = playerKeys
    
    if (players.count < 2) {
      singlePlayer = true
    } else {
      singlePlayer = false
    }
    
    currentPlayer = players[0]
    
    currentPlayerIdx = 0
    lastPlayerIdx = players.count - 1
  }
  
  init() {
    singlePlayer = true
    players = ["Player"]
    
    currentPlayer = players[0]
    
    currentPlayerIdx = 0
    lastPlayerIdx = players.count - 1
  }
  
  convenience init(numPlayers: Int) {
    var defaultNames = [1...numPlayers].map({ (num) -> String in
      return "Player \(num)"
    })
    
    self.init(playerKeys: defaultNames)
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

  func nextPlayer() -> String {
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
}