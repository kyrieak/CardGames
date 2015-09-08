//
//  SetGameController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/27/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGameController: UICollectionViewController {
  @IBOutlet var sgDataSource: SetGameDataSource!
  @IBOutlet var sgDelegate: SetGameDelegate!
  
  var headerHeight: CGFloat {
    return view.frame.height * 0.2
  }
  
  var contentHeight: CGFloat {
    return view.frame.height * 0.6
  }
  
  private var game: SetGame {
    return sgDataSource.game
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView!.frame.origin.y += headerHeight
    collectionView!.frame.size.height = contentHeight
    
    collectionView!.setNeedsDisplay()
    
//    var _collectionView = self.collectionView!
//
//    _collectionView.setNeedsDisplay()
    
//    startNewGame()

    collectionView!.allowsMultipleSelection = true
  }
  
  @IBAction func startNewRound(sender: UIButton) {
    game.startNewRound(game.numberOfCardPositions())

    collectionView!.reloadData()

    sgDelegate.selectIdxPaths = []
  }
  
  // - MARK: - Private Functions ------------------------------------
  
//  private func getGame() -> SetGame {
//    return (collectionView!.dataSource! as! SetGameDataSource).game
//  }
//  
//  private func getDelegate() -> SetGameDelegate {
//    return (collectionView!.delegate! as! SetGameDelegate)
//  }
  
//  private func getDataSource() -> SetGameDataSource {
//    return (collectionView!.dataSource! as! SetGameDataSource)
//  }
  
  private func getCurrentGame() -> SetGame {
    return sgDataSource.game
  }
  
  func startNewGame() {
    sgDataSource.game = SetGame(_players: game.players)
//    sgDelegate().recordStatus("-- Game Started --")
  }

  
  func endCurrentGame() {
    game.endGame()
//    getDelegate().recordStatus("-- Game Ended --")
  }
  
  func getGameHistory() -> [String] {
    return sgDelegate.getGameStatuses()
  }
  
  func clearOldHistory() {
    sgDelegate.clearOldStatuses()
  }
}