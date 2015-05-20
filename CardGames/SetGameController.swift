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
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startNewGame()

    collectionView!.allowsMultipleSelection = true
  }
  
  @IBAction func startNewRound(sender: UIButton) {
    var game = getGame()
    
    game.startNewRound(game.numberOfCardPositions())
    collectionView!.reloadData()
    getDelegate().selectIdxPaths = []
  }
  
  // - MARK: - Private Functions ------------------------------------
  
  private func getGame() -> SetGame {
    return (collectionView!.dataSource! as! SetGameDataSource).game
  }
  
  private func getDelegate() -> SetGameDelegate {
    return (collectionView!.delegate! as! SetGameDelegate)
  }
  
  private func getDataSource() -> SetGameDataSource {
    return (collectionView!.dataSource! as! SetGameDataSource)
  }
  
  private func getCurrentGame() -> SetGame {
    return getDataSource().game
  }
  
  func startNewGame() {
    getDelegate().recordStatus("-- Game Started --")
  }

  
  func endCurrentGame() {
    getCurrentGame().endGame()
    getDelegate().recordStatus("-- Game Ended --")
  }
  
  func getGameHistory() -> [String] {
    return getDelegate().getGameStatuses()
  }
  
  func clearOldHistory() {
    getDelegate().clearOldStatuses()
  }
}