//
//  MemoryGameDelegate.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/9/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class MemoryGameDelegate: NSObject, UICollectionViewDelegate {
  private var gameStatuses: [String] = []

  var header: UICollectionReusableView?
  var footer: UICollectionReusableView?
  var statusLabel: UILabel?
  var scoreLabel: UILabel?
  
  var selectIdxPaths: [NSIndexPath] = []
  
  func collectionView(collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    atIndexPath indexPath: NSIndexPath) {
      
      if (elementKind == UICollectionElementKindSectionFooter) {
        view.layer.position.y = collectionView.frame.height - (view.frame.height / 2) - 49
        footer = view
        statusLabel = view.viewWithTag(1) as? UILabel
      } else {
        header = view
        scoreLabel = view.viewWithTag(3) as? UILabel
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath) {
      var game = getGame(collectionView)
      
      selectIdxPaths.append(indexPath)
      
      game.updateTurn(indexPath.item)
      
      var status = getStatus(game)
      
      statusLabel!.text = status.msg
      
      if (game.currentTurn().done()) {
        scoreLabel!.text = game.currentPlayer().name + ": \(game.getScoreForCurrentPlayer())"
      }
      
      gameStatuses.append(status.msg)
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      var game = getGame(collectionView)
      
      if (game.waitingNextTurn()) {
        var status = getStatus(game)
        game.endTurn()
        
        statusLabel!.text = status.msg
        scoreLabel!.text = game.nextPlayer().name + ": \(game.getScoreForPlayer(game.nextPlayer()))"
        
        if (status.isMatch) {
          collectionView.reloadItemsAtIndexPaths(selectIdxPaths)
        } else {
          for path in selectIdxPaths {
            collectionView.deselectItemAtIndexPath(path, animated: false)
          }
        }
        selectIdxPaths = []
        
        recordStatus(status.msg)
        
        return false
      } else {
        if (game.currentTurn().hasEnded) {
          game.startNewTurn()
        }
        
        return (game.hasCardAt(indexPath.item))
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Sets remaining view and controller properties and inits game model
      return false
  }
  
  
  func getGameStatuses() -> [String] {
    return gameStatuses
  }
  
  
  func recordStatus(status: String) {
    gameStatuses.append(status)
  }
  
  
  func clearOldStatuses() {
    gameStatuses = []
  }
  
  
  private func getGame(collectionView: UICollectionView) -> MemoryGame {
    return (collectionView.dataSource! as! MemoryGameDataSource).game
  }
  
  
  private func getStatus(game: MemoryGame) -> (isMatch: Bool, msg: String) {
    
    if (game.isMultiPlayer() && game.currentTurn().hasEnded) {
      return (game.currentTurn().didMatch, (game.nextPlayer().name + "\'s Turn"))
    } else {
      let statusMaker = MGStatus(cards: game.getSelectedCards())
      
      if (!game.currentTurn().done()) {
        return (false, statusMaker.listCards())
      } else if (game.currentTurn().didMatch) {
        return (true, statusMaker.isMatchMsg(game.currentTurn().matchValue).statusText)
      } else {
        return (false, statusMaker.noMatchMsg(game.currentTurn().penaltyValue).statusText)
      }
    }
  }
}

struct MGStatus {
  private var cardsStr: String
  
  init(cards: [TrumpCard]) {
    cardsStr = join(", ", cards.map({(c: TrumpCard) -> String in
      return c.label()
    }))
    
    if (cards.count > 0) {
      cardsStr = "{ " + cardsStr + " }"
    }
  }
  
  func listCards() -> String {
    return cardsStr
  }
  
  func isMatchMsg(matchVal: Int) -> (cardListText: String, statusText: String) {
    return (cardListText: cardsStr, statusText: "is a match for \(matchVal) Points!")
  }
  
  func noMatchMsg(penaltyVal: Int) -> (cardListText: String, statusText: String) {
    var penalty = abs(penaltyVal)
    
    if (penalty > 0) {
      return (cardListText: cardsStr, statusText: "is not a match. \(penalty) point penalty.")
    } else {
      return (cardListText: cardsStr, statusText: "is not a match.")
    }
  }
}