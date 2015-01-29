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
  
  @IBAction func clickedDeckButton(sender: UIButton) {
    if dataSource!.hasSelectableCards() {
      NSLog("has cards remaining")
    } else {
      dataSource!.changeCards()
      
      viewedCards = [Bool](count: dataSource!.cardsInPlay.count, repeatedValue: false)

      collectionView!.reloadData()
    }
  }
  
  override func viewDidLoad() {
    self.collectionView!.allowsMultipleSelection = true
    self.dataSource = self.collectionView!.dataSource as? TrumpCardCollectionDataSource
    
    self.viewedCards = [Bool](count: dataSource!.cardsInPlay.count, repeatedValue: false)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
      if (cardPathA == nil) {
        cardPathA = indexPath
      } else if (cardPathB == nil) {
        cardPathB = indexPath

        checkStatus()
        
        var matchVal = getMatchValue(cardPathA!, idxPathB: cardPathB!)
        
        score += matchVal
        
        if (matchVal > 0) {
          removeCardsAt(cardPathA!, idxPathB: cardPathB!)
        } else {
          waitingForNextPlayer = true
        }
      }
    
      viewedCards![indexPath.item] = true
    }
  
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

    if (waitingForNextPlayer) {
      collectionView.deselectItemAtIndexPath(cardPathA!, animated: false)
      collectionView.deselectItemAtIndexPath(cardPathB!, animated: false)

      (cardPathA, cardPathB) = (nil, nil)

      waitingForNextPlayer = false

      return false
    } else {
      return dataSource!.hasCardAt(indexPath)
    }
  }
  
  override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    
    return !((indexPath == cardPathA) || (indexPath == cardPathB))
  }
  
  func removeCardsAt(idxPathA: NSIndexPath, idxPathB: NSIndexPath) {
    dataSource!.removeCardsAt([idxPathA, idxPathB])
    collectionView!.reloadItemsAtIndexPaths([idxPathA, idxPathB])

    (cardPathA, cardPathB) = (nil, nil)
  }
  

  func getMatchValue(idxPathA: NSIndexPath, idxPathB: NSIndexPath) -> Int {
    var cardA: TrumpCard = dataSource!.getCardAt(idxPathA)!
    var cardB: TrumpCard = dataSource!.getCardAt(idxPathB)!
    
    if (cardA.rank != cardB.rank) {
      if (viewedCards![idxPathB.item]) {
        NSLog("Did See Card")
        return -1
      } else {
        return 0
      }
    } else if (cardA.color() == cardB.color()) {
      return 4
    } else {
      return 2
    }
  }
  
  func checkStatus() {
    NSLog("=== Score: \(score) ========")
    
    if (cardPathA != nil) {
      NSLog("indexA \(cardPathA!.item)")
      NSLog("cardA \(dataSource!.getCardAt(cardPathA!)!.label())")
    }
    
    if (cardPathB != nil) {
      NSLog("indexB \(cardPathB!.item)")
      NSLog("cardB \(dataSource!.getCardAt(cardPathB!)!.label())")
    }
  }
}