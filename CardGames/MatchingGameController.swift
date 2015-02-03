//
//  MatchingGameController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 1/11/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class MatchingGameController: UICollectionViewController, UICollectionViewDelegate {
  var score: Int = 0
  var selectIdxPaths: [NSIndexPath] = []
  var dataSource: TrumpCardCollectionDataSource?
  var waitingForNextPlayer = false
  var game: MatchingGame?
  
  @IBAction func clickedDeckButton(sender: UIButton) {
    if (game!.hasUnviewedCards()) {
      NSLog("has unviewed cards")
    } else {
      dataSource!.changeCards()
      game!.nextRound(dataSource!.cardsInPlay.count)
      collectionView!.reloadData()
    }
  }
  
  override func viewDidLoad() {
    self.collectionView!.allowsMultipleSelection = true
    self.dataSource = self.collectionView!.dataSource as? TrumpCardCollectionDataSource

    game = MatchingGame(cardCount: dataSource!.cardsInPlay.count, cardsPerTurn: 3)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      selectIdxPaths.append(indexPath)
      var (didMatch, msg) = game!.updateTurn(indexPath.item, card: dataSource!.getCardAt(indexPath)!)
    
      NSLog(msg)
      if (game!.currentTurn.done()) {
        score = game!.getScore()
        NSLog("Score: \(score) =====================================")
        // updateTurn resets currentTurn so this code wont work
        if (didMatch) {
          removeCardsAt(selectIdxPaths)
        } else {
          waitingForNextPlayer = true
        }
      }
    }
  
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

    if (waitingForNextPlayer) {
      for path in selectIdxPaths {
        collectionView.deselectItemAtIndexPath(path, animated: false)
      }
      selectIdxPaths = []
      waitingForNextPlayer = false

      return false
    } else {
      return dataSource!.hasCardAt(indexPath)
    }
  }
  
  override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    
    for path in selectIdxPaths {
      if (indexPath == path) {
        return false
      }
    }
    
    return true
  }
  
  func removeCardsAt(idxPaths: [NSIndexPath]) {
    dataSource!.removeCardsAt(idxPaths)
    collectionView!.reloadItemsAtIndexPaths(idxPaths)

    selectIdxPaths = []
  }
  
  
  func checkStatus() {
    NSLog("=== Score: \(score) ========")
    
    for path in selectIdxPaths {
      NSLog("index: \(path.item)")
      NSLog("card: \(dataSource!.getCardAt(path)!.label())")
    }
  }
}