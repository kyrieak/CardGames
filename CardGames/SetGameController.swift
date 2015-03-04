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
    
    collectionView!.allowsMultipleSelection = true
  }
  
  @IBAction func startNewRound(sender: UIButton) {
    var game = getGame()
    NSLog("\(game.numberOfCardPositions())")
    game.startNewRound(game.numberOfCardPositions())
    collectionView!.reloadData()
    getDelegate().selectIdxPaths = []
  }
  
  private func getGame() -> SetGame {
    return (collectionView!.dataSource! as SetGameDataSource).game
  }
  
  private func getDelegate() -> SetGameDelegate {
    return (collectionView!.delegate! as SetGameDelegate)
  }
}