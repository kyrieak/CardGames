////
////  MemoryGameController.swift
////  CardGames
////
////  Created by Kyrie Kopczynski on 1/11/15.
////  Copyright (c) 2015 Kyrie. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class MemoryGameController: UICollectionViewController, UICollectionViewDelegate {
//  var score: Int = 0
//  var selectIdxPaths: [NSIndexPath] = []
//  var dataSource: TrumpCardCollectionDataSource?
//  var waitingForNextPlayer = false
//  var game: MemoryGame?
//  var scoreLabel: UILabel?
//  var statusLabel: UILabel?
//  let style = Style()
//  var currentTurn: MemoryTurn = MemoryTurn()
//  
//  
//  
//  // --- Controller Overrides ---
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    collectionView!.allowsMultipleSelection = true
//    dataSource = collectionView!.dataSource as? TrumpCardCollectionDataSource
//    
//    startNewGame()
//  }
//  
//  
//  // --- UI Responders ---
//  
//  @IBAction func clickedDeckButton(sender: UIButton) {
//    if (game!.hasUnviewedCards()) {
//      NSLog("has unviewed cards")
//    } else {
//      startNewRound()
//    }
//  }
//  
//  
//  // --- Delegate Functions ---
//  
//  override func collectionView(collectionView: UICollectionView,
//                               willDisplaySupplementaryView view: UICollectionReusableView,
//                                 forElementKind elementKind: String,
//                                   atIndexPath indexPath: NSIndexPath) {
//                                    
//    if (elementKind == UICollectionElementKindSectionFooter) {
//      view.layer.position.y = self.view.frame.height - (view.frame.height / 2) - 49
//      NSLog("\(self.view.frame.height)")
//      statusLabel = view.viewWithTag(1) as? UILabel
//    } else {
//      scoreLabel = view.viewWithTag(3) as? UILabel
//    }
//  }
//  
//  
//  override func collectionView(collectionView: UICollectionView,
//                                 didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    // Updates mvc properties on UI card selection and checks turn state
//
//    selectIdxPaths.append(indexPath)
//                                  
//    currentTurn.addCard(indexPath.item)
//    
//    game!.updateTurn(currentTurn)
//                                  
//    if currentTurn.done() {
//    }
//
//    var (didMatch, msg) = game!.updateTurn(indexPath.item, card: dataSource!.getCardAt(indexPath)!)
//    
//    statusLabel!.text = msg
//
//    if (game!.currentTurn.done()) {
//      score = game!.getScore()
//      scoreLabel!.text = score.description
//      NSLog("Score: \(score) =====================================")
//      
//      if (didMatch) {
//        removeCardsAt(selectIdxPaths)
//      } else {
//        waitingForNextPlayer = true
//      }
//    }
//  }
//  
//  
//  override func collectionView(collectionView: UICollectionView,
//                                 shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//    // Handles card flip behavior so that cards are not accidentally
//    // flipped back in the middle of a turn and such.
//                                  
//    if (!currentTurn.done()) {
//      return dataSource!.hasCardAt(indexPath)
//    } else if (currentTurn.hasEnded) {
//      currentTurn = game!.startNewTurn()
//      
//      return true
//    } else {
//      for path in selectIdxPaths {
//        collectionView.deselectItemAtIndexPath(path, animated: false)
//      }
//      selectIdxPaths = []
//      
//      return false
//    }
//  }
//  
//  
//  override func collectionView(collectionView: UICollectionView,
//                                 shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//    // Sets remaining view and controller properties and inits game model
//    
//    for path in selectIdxPaths {
//      if (indexPath == path) {
//        return false
//      }
//    }
//    
//    return true
//  }
//  
//  
//  // --- Private Functions ---
//  
//  private func makeGameStatus() -> String {
//    if (!currentTurn.done()) {
//      var score = game!.evaluateMatchScore()
//
//      return "not done"
//    } else if (currentTurn.hasEnded) {
//      return "\(game!.turnKeeper.nextPlayer()) Turn Start"
//    } else {
//      return "\(game!.turnKeeper.currentPlayer): "
//    }
//  }
//  
//  private func getCurrentPlayerName() -> String {
//    return split(game!.turnKeeper.currentPlayer, " ").pop().join()
//  }
//  
//  private func removeCardsAt(idxPaths: [NSIndexPath]) {
//    dataSource!.removeCardsAt(idxPaths)
//    collectionView!.reloadItemsAtIndexPaths(idxPaths)
//
//    selectIdxPaths = []
//  }
//  
//  
//  private func checkStatus() {
//    NSLog("=== Score: \(score) ========")
//    
//    for path in selectIdxPaths {
//      NSLog("index: \(path.item)")
//      NSLog("card: \(dataSource!.getCardAt(path)!.label())")
//    }
//  }
//
//  private func prepareNewGame() {
//    dataSource!.loadNewCardSet()
//    
//    prepareNewRound()
//  }
//
//  private func startNewGame() {
//    prepareNewGame()
//    game = MemoryGame(cardCount: dataSource!.cardsInPlay.count, cardsPerTurn: 3)
//    
//    if (statusLabel != nil) {
//      statusLabel!.text = "Game Start!"
//    }
//  }
//  
//  private func prepareNewRound() {
//    waitingForNextPlayer = false
//    selectIdxPaths = []
//    dataSource!.loadNextCards()
//  }
//  
//  private func startNewRound() {
//    prepareNewRound()
//    
//    game!.nextRound(dataSource!.cardsInPlay.count)
//    collectionView!.reloadData()
//    
//    statusLabel!.text = "New Round!"
//  }
//}
