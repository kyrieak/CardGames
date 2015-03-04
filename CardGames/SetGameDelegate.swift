//
//  SetCardCollectionDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGameDelegate: NSObject, UICollectionViewDelegate {
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
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      var game = getGame(collectionView)
      
      if (game.waitingNextTurn()) {
        game.endTurn()

        var status = getStatus(game)
        
        statusLabel!.text = status.msg
        scoreLabel!.text = game.nextPlayer().name + ": \(game.getScoreForPlayer(game.nextPlayer()))"
        
        if (status.isSet) {
          collectionView.reloadItemsAtIndexPaths(selectIdxPaths)
        } else {
          for path in selectIdxPaths {
            collectionView.deselectItemAtIndexPath(path, animated: false)
          }
        }
        selectIdxPaths = []
        
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
  
  
  private func getGame(collectionView: UICollectionView) -> SetGame {
    return (collectionView.dataSource! as SetGameDataSource).game
  }
  
  
  private func getStatus(game: SetGame) -> (isSet: Bool, msg: String) {
    
    if (game.isMultiPlayer() && game.currentTurn().hasEnded) {
      return (game.currentTurn().didMakeSet, (game.nextPlayer().name + "\'s Turn"))
    } else {
      let statusMaker = SetGameStatus(cards: game.getSelectedCards())
      
      if (!game.currentTurn().done()) {
        return (false, statusMaker.listCards())
      } else if (game.currentTurn().didMakeSet) {
        return (true, statusMaker.isSetMsg(game.currentTurn().setValue))
      } else {
        return (false, statusMaker.notSetMsg(game.currentTurn().setValue))
      }
    }
  }
}

struct SetGameStatus {
  private var cardsStr: String
  
  init(cards: [SetCard]) {
    cardsStr = join(", ", cards.map({(sc: SetCard) -> String in
      return sc.shape
    }))
    
    if (cards.count > 0) {
      cardsStr = "{ " + cardsStr + " }"
    }
  }
  
  func listCards() -> String {
    return cardsStr
  }
  
  func isSetMsg(matchVal: Int) -> String {
    return cardsStr + " is a set for \(matchVal) Points!"
  }
  
  func notSetMsg(penaltyVal: Int) -> String {
    var penalty = abs(penaltyVal)
    
    if (penalty > 0) {
      return cardsStr + " is not a set. \(penalty) point penalty."
    } else {
      return cardsStr + " is not a set"
    }
  }
}