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
  
  var statusView: SetGameStatusView?
  var scoreLabel: UILabel?
  var selectIdxPaths: [NSIndexPath] = []
  
  
  lazy var screen: UIScreen = {
    return UIScreen.mainScreen()
  }()
  
  var horizontalSizeClass: UIUserInterfaceSizeClass {
    return screen.traitCollection.horizontalSizeClass
  }
  
  var verticalSizeClass: UIUserInterfaceSizeClass {
    return screen.traitCollection.verticalSizeClass
  }
  
  
  func collectionView(collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    atIndexPath indexPath: NSIndexPath) {
      
      if (elementKind == UICollectionElementKindSectionFooter) {
        view.frame.origin.y = collectionView.frame.height - view.frame.height
        statusView = view.viewWithTag(1) as? SetGameStatusView
        NSLog("\(statusView)")
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath) {
      if (selectIdxPaths.count == 0) {
        statusView!.clear()
      }
      
      selectIdxPaths.append(indexPath)

      let game = getGame(collectionView)
      let card = game.getCardAt(indexPath.item)!

      statusView!.addCardToListView(card.attributes())
      statusView!.setNeedsDisplay()
  }
  
  
  func makeMove(collectionView: UICollectionView, game: SetGame, playerTag: Int) {
    if (selectIdxPaths.count == 3) {
      game.makeMove(selectedIndexes(), playerKey: playerTag)

      if (game.currentMoveIsASet()) {
        collectionView.reloadData()
      } else {
        for path in selectIdxPaths {
          collectionView.deselectItemAtIndexPath(path, animated: false)
        }
      }

      selectIdxPaths = []

      let status = getStatus(game)
      let (cardListText, statusText) = status.msg
      
      statusView!.setMessage(cardListText, statusText: statusText)
      
      game.endMove()
    }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      let game = getGame(collectionView)
      NSLog("I am here in should select indexpath delegate")

      if (selectIdxPaths.count > 2) {
        return false
      } else {
        NSLog("selectIdxPaths count is < 3, so game.hasCardAt is \(game.hasCardAt(indexPath.item))")
        return game.hasCardAt(indexPath.item)
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
      switch (collectionView.frame.width) {
        case let x where x > 599:
          return CGFloat(50)
        default:
          return CGFloat(8)
      }
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAtIndex section: Int) -> UIEdgeInsets {

      switch (horizontalSizeClass) {
        case UIUserInterfaceSizeClass.Regular:
          return UIEdgeInsets(tb: 20, lr: 50)
        default:
          return UIEdgeInsets(tb: 10, lr: 8)
      }
  }
  
  func collectionView(collectionView: UICollectionView,
         layout collectionViewLayout: UICollectionViewLayout,
           sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            var (w, h): (CGFloat, CGFloat)
            
            switch (horizontalSizeClass) {
              case UIUserInterfaceSizeClass.Regular:
                (w, h) = (166, 160)
              case UIUserInterfaceSizeClass.Unspecified:
                (w, h) = (88, 122)
              default:
                (w, h) = (68, 94)
            }
            
            if (verticalSizeClass == UIUserInterfaceSizeClass.Compact) {
              return CGSize(width: h, height: w)
            } else {
              return CGSize(width: w, height: h)
            }
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
  
  
  private func getGame(collectionView: UICollectionView) -> SetGame {
    return (collectionView.dataSource! as! SetGameDataSource).game
  }
  
  
  private func getStatus(game: SetGame) -> (isSet: Bool, msg: (String, String)) {
    let statusMaker = SetGameStatus(cards: game.getSelectedCards())
    
    if (!game.currentMove.done) {
      return (false, (statusMaker.listCards(), ""))
    } else if (game.currentMoveIsASet()) {
      return (true, statusMaker.isSetMsg(5)) // arbit 5pts
    } else {
      return (false, statusMaker.notSetMsg(-1)) // arbit -1pts
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
    cardsStr = cards.map({(sc: SetCard) -> String in
      switch(sc.shape) {
        case .Diamond:
          return "Diamond"
        case .Oval:
          return "Oval"
        case .Squiggle:
          return "Squiggle"
      }
    }).joinWithSeparator(", ")
    
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
    let penalty = abs(penaltyVal)
    
    if (penalty > 0) {
      return (cardsStr, "is not a set. \(penalty) point penalty.")
    } else {
      return (cardsStr, "is not a set")
    }
  }
}