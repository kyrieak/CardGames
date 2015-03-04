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
      NSLog("input idx is: \(indexPath.item)")
      game.updateTurn(indexPath.item)
      
      NSLog("will get status in DIDSELECT")

      let (isSet, statusMsg) = getStatus(game)

      statusLabel!.text = statusMsg
      
      if (game.currentTurn().done()) {
        scoreLabel!.text = game.currentPlayer() + ": \(game.getCurrentPlayerScore())"
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      var game = getGame(collectionView)

      NSLog("will get status in SHOULDSELECT")
      
      if (game.waitingNextTurn()) {
        let (isSet, statusMsg) = getStatus(game)

        game.endTurn()

        if (!isSet) {
          for path in selectIdxPaths {
            collectionView.deselectItemAtIndexPath(path, animated: false)
          }
        } else {
          collectionView.reloadItemsAtIndexPaths(selectIdxPaths)
        }
        selectIdxPaths = []

        statusLabel!.text = statusMsg
        
        return false
      } else {
        if (game.currentTurn().hasEnded) {
          NSLog("turn has ended, starting new turn")

          game.startNewTurn()
        }
        
        NSLog("slot is empty? \(game.getCardAt(indexPath.item) == nil)")

        return (game.getCardAt(indexPath.item) != nil)
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
  
  
  private func getStatus(game: SetGame) -> (Bool, String) {
    if (game.isMultiPlayer() && game.currentTurn().hasEnded) {
      return (false, (game.nextPlayer() + "\'s Turn"))
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