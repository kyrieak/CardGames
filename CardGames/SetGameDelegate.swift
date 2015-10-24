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
  let statusViewTag: Int = 1

  private(set) var statusView: SGStatusView?
  private(set) var selectIdxPaths: [NSIndexPath] = []
  private(set) var cardSize: CGSize = CGSizeZero
  
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
        statusView = view.viewWithTag(statusViewTag) as? SGStatusView
        
        if (!deviceIsMobile) {
          view.frame.size.height = 70
          statusView?.adjustHeight(70)
        }
        
        view.frame.origin.y = collectionView.frame.height - view.frame.height
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

      let isASet = game.currentMoveIsASet()

      statusView!.updateStatus(game.currentMove, isASet: isASet)
      updateSelectedCardCells(collectionView, isASet: isASet)
      
      game.endMove()
    }
  }
  
  
  private func updateSelectedCardCells(collectionView: UICollectionView, isASet: Bool) {
    if (selectIdxPaths.count == 3) {
      if (isASet) {
        collectionView.reloadData()
      } else {
        for path in selectIdxPaths {
          collectionView.deselectItemAtIndexPath(path, animated: false)
        }
      }
      
      selectIdxPaths = []
    }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
      let game = getGame(collectionView)

      if (selectIdxPaths.count > 2) {
        return false
      } else {
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
        case let x where x > 400:
          return CGFloat(30)
        default:
          return CGFloat(8)
      }
//      return CGFloat(8)
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

             if (cardSize.width < 1) {
               setCardSize()
             }

             if (screenIsPortrait) {
               return cardSize
             } else {
               return CGSize(width: cardSize.height, height: cardSize.width)
             }
  }
  

  func reset() {
    selectIdxPaths = []
    statusView?.clear()
  }
  
  
  private func getGame(collectionView: UICollectionView) -> SetGame {
    return (collectionView.dataSource! as! SetGameDataSource).game
  }
  
  
  private func getStatus(game: SetGame) -> (isSet: Bool, msg: String) {
    let cards = game.getSelectedCards()

    let cardText = cards.map{(c: SetCard) -> String in
      return c.attributes().toString(game.options)
    }.joinWithSeparator(", ")

    if (!game.currentMove.done) {
      return (false, cardText)
    } else {
      return (isSet: game.currentMoveIsASet(), msg: game.status())
    }
  }
  
  private func selectedIndexes() -> [Int] {
    return selectIdxPaths.map { (path: NSIndexPath) -> Int in
      return path.item
    }
  }
  
  private func setCardSize() {
    var w, h: CGFloat

    if (deviceIsMobile) {
      w = minScreenDim * 0.193
      h = minScreenDim * 0.254
    } else {
      w = minScreenDim * 0.156
      h = minScreenDim * 0.208
    }
    
    cardSize = CGSize(width: w, height: h)
  }
}
