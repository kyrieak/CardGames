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
  var cardPathA: NSIndexPath?
  var cardPathB: NSIndexPath?
  var dataSource: TrumpCardCollectionDataSource?
  var viewedCards: [Bool]?
  var waitingForNextPlayer = false
  
  override func viewDidLoad() {
    self.collectionView!.allowsMultipleSelection = true
    self.dataSource = self.collectionView!.dataSource as? TrumpCardCollectionDataSource
    
    self.viewedCards = [Bool](count: dataSource!.cardsInPlay.count, repeatedValue: false)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

      viewedCards![indexPath.item] = true
      
      if (cardPathA == nil) {
        cardPathA = indexPath
      } else if (cardPathB == nil) {
        cardPathB = indexPath

        checkStatus()
        
        var matchVal = getMatchValue(cardPathA!.item, idxB: cardPathB!.item)
        
        if (matchVal > 0) {
          removeCardsAt(cardPathA!, idxPathB: cardPathB!)
        }
        
        score += matchVal
        waitingForNextPlayer = true
      }
    }
  
  func checkStatus() {
    NSLog("=== Score: \(score) ========")
    
    if (cardPathA != nil) {
      NSLog("cardA \(dataSource!.cardsInPlay[cardPathA!.item]!.label())")
    }
    
    if (cardPathB != nil) {
      NSLog("cardB \(dataSource!.cardsInPlay[cardPathB!.item]!.label())")
    }
    
    NSLog("indexA \(cardPathA?.item)")
    NSLog("indexB \(cardPathB?.item)")
  }
//  }

  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

    if (waitingForNextPlayer) {
      collectionView.deselectItemAtIndexPath(cardPathA!, animated: false)
      collectionView.deselectItemAtIndexPath(cardPathB!, animated: false)

      (cardPathA, cardPathB) = (nil, nil)

      waitingForNextPlayer = false

      return false
    } else {
      return dataSource!.cardsInPlay[indexPath.item] != nil
    }
  }
  
  override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    
    return !((indexPath == cardPathA) || (indexPath == cardPathB))
  }
  
  func removeCardsAt(idxPathA: NSIndexPath, idxPathB: NSIndexPath) {
    dataSource!.cardsInPlay[idxPathA.item] = nil
    dataSource!.cardsInPlay[idxPathB.item] = nil
    
    collectionView!.reloadItemsAtIndexPaths([idxPathA, idxPathB])
  }
  

  func getMatchValue(idxA: Int, idxB: Int) -> Int {
    var cardA: TrumpCard = dataSource!.cardsInPlay[idxA]!
    var cardB: TrumpCard = dataSource!.cardsInPlay[idxB]!
    
    if (cardA.rank != cardB.rank) {
      if (self.viewedCards![idxB]) {
        NSLog("=== -1 ==============================")
        return -1
      } else {
        NSLog("=== 0 ==============================")

        return 0
      }
    } else if (cardA.suit.color == cardB.suit.color) {
      NSLog("=== 4 ==============================")

      return 4
    } else {
      NSLog("=== 2 ==============================")
      
      return 2
    }
  }
}