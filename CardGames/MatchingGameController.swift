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
  var statusLabel: UILabel?
  
  @IBAction func clickedDeckButton(sender: UIButton) {
    if (game!.hasUnviewedCards()) {
      NSLog("has unviewed cards")
    } else {
      startNewRound()
    }
  }
  
  /* Sets remaining view and controller properties and inits game model
  */
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView!.allowsMultipleSelection = true

    dataSource  = collectionView!.dataSource as? TrumpCardCollectionDataSource

    startNewGame()
  }
  
  override func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
    if (elementKind == UICollectionElementKindSectionFooter) {
      statusLabel = view.subviews[0] as? UILabel
    }
  }
  
  /* Updates mvc properties on UI card selection and checks turn state
  */
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    // Update: Controller
    selectIdxPaths.append(indexPath)

    // Update: Model
    var (didMatch, msg) = game!.updateTurn(indexPath.item, card: dataSource!.getCardAt(indexPath)!)
  
    // Update: View
    statusLabel!.text = msg
  
    NSLog(msg)

    // Update State: Controller
    if (game!.currentTurn.done()) {
      score = game!.getScore()
      NSLog("Score: \(score) =====================================")
      
      if (didMatch) {
        removeCardsAt(selectIdxPaths)
      } else {
        waitingForNextPlayer = true
      }
    }
  }
  
  /* Handles card flip behavior so that cards are not accidentally
   * flipped back in the middle of a turn and such.
  */
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
  
  /* Sets remaining view and controller properties and inits game model
  */
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

  private func prepareNewGame() {
    dataSource!.loadNewCardSet()
    
    prepareNewRound()
  }

  private func startNewGame() {
    prepareNewGame()
    game = MatchingGame(cardCount: dataSource!.cardsInPlay.count, cardsPerTurn: 3)
    
    if (statusLabel != nil) {
      statusLabel!.text = "Game Start!"
    }
  }
  
  private func prepareNewRound() {
    waitingForNextPlayer = false
    selectIdxPaths = []
    dataSource!.loadNextCards()
  }
  
  private func startNewRound() {
    prepareNewRound()
    
    game!.nextRound(dataSource!.cardsInPlay.count)
    collectionView!.reloadData()
    
    statusLabel!.text = "New Round!"
  }
}








































































































