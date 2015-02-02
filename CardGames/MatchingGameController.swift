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
  var scorer: MatchingGameScorer?
  
  @IBAction func clickedDeckButton(sender: UIButton) {
    if dataSource!.hasSelectableCards() {
      NSLog("has cards remaining")
    } else {
      dataSource!.changeCards()
      scorer!.nextRound(dataSource!.cardsInPlay.count)
      collectionView!.reloadData()
    }
  }
  
  override func viewDidLoad() {
    self.collectionView!.allowsMultipleSelection = true
    self.dataSource = self.collectionView!.dataSource as? TrumpCardCollectionDataSource

    scorer = MatchingGameScorer(cardCount: dataSource!.cardsInPlay.count, cardsPerTurn: 2)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      selectIdxPaths.append(indexPath)
      var (didMatch, msg) = scorer!.updateTurn(indexPath.item, card: dataSource!.getCardAt(indexPath)!)
    
      NSLog(msg)
    
      if (scorer!.currentTurn.done()) {
        score = scorer!.getScore()
        NSLog("Score: \(score)=================================================")
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