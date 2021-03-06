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

  private(set) var statusView: SGStatusView = SGStatusView()
  private(set) var selectIdxPaths: [NSIndexPath] = []
  private(set) var cardSize: CGSize = CGSizeZero
  

  func collectionView(collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    atIndexPath indexPath: NSIndexPath) {
      if (elementKind == UICollectionElementKindSectionFooter) {
        statusView = view.viewWithTag(statusViewTag) as! SGStatusView
        statusView.adjustHeight(view.frame.height)
        appGlobals.styleGuide.applyFontStyle(.Status, views: [statusView.messageView])

        let scoreIcon = statusView.viewWithTag(5) as! UIButton
    
        scoreIcon.setTitleColor(appGlobals.styleGuide.theme.fontColor1, forState: .Normal)
        
        view.frame.origin.y = collectionView.frame.height - view.frame.height
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    didSelectItemAtIndexPath indexPath: NSIndexPath) {
      if (selectIdxPaths.count == 0) {
        statusView.clear()
      }
      
      selectIdxPaths.append(indexPath)

      let game = getGame(collectionView)
      let card = game.getCardAt(indexPath.item)!

      statusView.addCardToListView(card.attributes())
      statusView.setNeedsDisplay()
  }
  
  
  func makeMove(collectionView: UICollectionView, game: SetGame, playerTag: Int) {
    if (selectIdxPaths.count == 3) {
      game.makeMove(selectedIndexes(), playerKey: playerTag)

      let isASet = game.currentMoveIsASet()

      statusView.updateStatus(game.currentMove, isASet: isASet)
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
//      let cell = collectionView.cellForItemAtIndexPath(indexPath)
//      cell?.selectedBackgroundView!.layer.borderColor = styleGuide.theme.bgColor3.CGColor

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
  
  
  func flipFaceDown(collectionView: UICollectionView, indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath)

    if (cell != nil) {
      appGlobals.styleGuide.applyLayerStyle(.CardBack, view: cell!)
    }
    
    cell?.backgroundView?.hidden = true
    cell?.selectedBackgroundView?.hidden = true
  }
  
  func flipFaceUp(collectionView: UICollectionView, indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath)
    
    cell?.layer.borderWidth = CGFloat(0)
    cell?.backgroundView?.hidden = false
    cell?.selectedBackgroundView?.hidden = false
  }
  

  func reset() {
    selectIdxPaths = []
    statusView.clear()
  }
  
  
  private func getGame(collectionView: UICollectionView) -> SetGame {
    return (collectionView.dataSource! as! SetGameDataSource).game
  }
    
  
  private func selectedIndexes() -> [Int] {
    return selectIdxPaths.map { (path: NSIndexPath) -> Int in
      return path.item
    }
  }
}
