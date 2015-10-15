//
//  CardCollectionDelegate.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation


class Player: Hashable {
  let key: Int
  let hashValue: Int
  
  private(set) var label: String
  private(set) var name: String
  
  init(key: Int, name: String, label: String) {
    self.key = key
    self.name = name
    self.label = label
    self.hashValue = key
  }

  convenience init(key: Int) {
    self.init(key: key, name: "Player \(key)", label: "P\(key)")
  }
  
  convenience init(key: Int, name: String) {
    self.init(key: key, name: name, label: Player.makeLabelFrom(name))
  }
  
  func setLabel(newLabel: String) {
    let len = newLabel.characters.count
    
    if ((len < 3) && (len > 0)){
      self.label = newLabel
    }
  }
  
  func setName(newName: String) {
    if (newName.characters.count > 0) {
      self.name = newName
    }
  }
  
  class func makeLabelFrom(name: String) -> String {
    if (name.characters.count > 1) {
      return name.substringToIndex(name.startIndex.successor().successor())
    } else {
      return name
    }
  }

  
  class func makeNumberedPlayers(count: Int) -> [Player] {
    if (count > 0) {
      let numberedPlayers = (1...count).map({(num: Int) -> Player in
        return Player(key: num)
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