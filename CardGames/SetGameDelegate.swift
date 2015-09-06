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
  private var gameStatuses: [String] = []
  private var waitingNextMove = true
  
  var header: UICollectionReusableView?
  var footer: UICollectionReusableView?
  var statusView: SetGameStatusView?
  var scoreLabel: UILabel?
  
  var selectIdxPaths: [NSIndexPath] = []
  
  func collectionView(collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    atIndexPath indexPath: NSIndexPath) {
      
      if (elementKind == UICollectionElementKindSectionFooter) {
        view.layer.position.y = collectionView.frame.height - (view.frame.height / 2) - 49
        footer = view
        statusView = view.viewWithTag(1) as? SetGameStatusView
      } else {
        header = view
        scoreLabel = view.viewWithTag(3) as? UILabel
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath) {
      var game = getGame(collectionView)

      selectIdxPaths.append(indexPath)
      var card = game.getCardAt(indexPath.item)!

      statusView!.addCardToListView(card.attributes())
      statusView!.setNeedsDisplay()
  }
  
  
  func makeMoveAction(_collectionView: UICollectionView) {
    var game = getGame(_collectionView)

    if (game.currentMove.done) {
      let player = Player(key: 1, name: "hi") // placeholder
      
      if (selectIdxPaths.count == 3) {
        game.makeMove(selectedIndexes(), _player: player)
      }
      
      var status = getStatus(game)
      var (cardListText, statusText) = status.msg
      
      statusView!.setMessage(cardListText, statusText: statusText)
      
//      if (currentMove.done) {
//        NSLog("score goes here")
//        //        scoreLabel!.text = game.currentPlayer().name + ": \(game.getScoreForCurrentPlayer())"
//      }
    }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      var game = getGame(collectionView)
      
      if (selectIdxPaths.count > 2) {
        return false
      } else {
        return game.hasCardAt(indexPath.item)
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
  
  func recordStatus(cardListText: String, statusText: String) {
    recordStatus(cardListText + " " + statusText)
  }
  
  
  func clearOldStatuses() {
    gameStatuses = []
  }
  
  
  private func getGame(collectionView: UICollectionView) -> SetGame {
    return (collectionView.dataSource! as! SetGameDataSource).game
  }
  
  
  private func getStatus(game: SetGame) -> (isSet: Bool, msg: (String, String)) {
    if (game.currentMove.done) {
      return (game.currentMove.isASet, ("", ("Ready for next move")))
    } else {
      let statusMaker = SetGameStatus(cards: game.getSelectedCards())
      
      if (!game.currentMove.done) {
        return (false, (statusMaker.listCards(), ""))
      } else if (game.currentMove.isASet) {
        return (true, statusMaker.isSetMsg(5)) // arbit 5pts
      } else {
        return (false, statusMaker.notSetMsg(-1)) // arbit -1pts
      }
    }
  }
  
  private func selectedIndexes() -> [Int] {
    return selectIdxPaths.map { (path: NSIndexPath) -> Int in
      return path.item
    }
  }
}

struct SetGameStatus {
  private var cardsStr: String
  
  init(cards: [SetCard]) {
    cardsStr = join(", ", cards.map({(sc: SetCard) -> String in
      switch(sc.shape) {
        case .Diamond:
          return "Diamond"
        case .Oval:
          return "Oval"
        case .Squiggle:
          return "Squiggle"
      }
    }))
    
    if (cards.count > 0) {
      cardsStr = "{ " + cardsStr + " }"
    }
  }
  
  func listCards() -> String {
    return cardsStr
  }
  
  func isSetMsg(matchVal: Int) -> (String, String) {
    return (cardsStr, "is a set for \(matchVal) Points!")
  }
  
  func notSetMsg(penaltyVal: Int) -> (String, String) {
    var penalty = abs(penaltyVal)
    
    if (penalty > 0) {
      return (cardsStr, "is not a set. \(penalty) point penalty.")
    } else {
      return (cardsStr, "is not a set")
    }
  }
}
// content of should select --------------------------
//      if (currentMove.done) {
////        game.endMove()
//
//        waitingNextMove = true
//
//        var status = getStatus(game)
//
//        var (cardListText, statusText) = status.msg
//
//        statusView!.setMessage(cardListText, statusText: statusText)
//
//        scoreLabel!.text = game.nextPlayer().name + ": \(game.getScoreForPlayer(game.nextPlayer()))"
//
//        if (status.isSet) {
//          collectionView.reloadItemsAtIndexPaths(selectIdxPaths)
//        } else {
//          for path in selectIdxPaths {
//            collectionView.deselectItemAtIndexPath(path, animated: false)
//          }
//        }
//        selectIdxPaths = []
//        statusView!.clear()
//
//        recordStatus(cardListText, statusText: statusText)
//
//        return false
//      } else {
//        if (game.currentTurn().hasEnded) {
//          game.startNewTurn()
//        }
//
//        return (game.hasCardAt(indexPath.item))
//      }
// --------------------------------