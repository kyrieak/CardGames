//
//  CardCollectionDelegate.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation


struct Player: Hashable {
  let key: Int
  let name: String
  let hashValue: Int
  
  init(key: Int, name: String) {
    self.key = key
    self.name = name
    self.hashValue = key
  }
  
  static func makeNumberedPlayers(count: Int) -> [Player] {
    if (count > 0) {
      let numberedPlayers = (1...count).map({(num: Int) -> Player in
        return Player(key: num, name: "Kyrie\(num)")
      })

      return numberedPlayers
    } else {
      return []
    }
  }
}

func ==(lhs: Player, rhs: Player) -> Bool {
  return lhs.key == rhs.key
}