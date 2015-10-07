//
//  SetGameController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/27/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGameController: UIViewController {
  @IBOutlet var sgDataSource: SetGameDataSource!
  @IBOutlet var sgDelegate: SetGameDelegate!
  
  @IBOutlet var headerView: SGHeaderView!
  @IBOutlet var footerView: SGFooterView!
  
  @IBOutlet var wrapperView: UIView!
  @IBOutlet var collectionView: UICollectionView!
  
  var game: SetGame {
    return sgDataSource.game
  }
  
  var deckButton: UIButton {
    return headerView.deckButton
  }
  
  lazy var orientation: UIDeviceOrientation = {
    UIDevice.currentDevice().orientation
  }()

  
  // - MARK: - Override Functions ------------------------------------

  
  override func viewDidLoad() {
    super.viewDidLoad()

    NSLog("\(game.players.count)")

    collectionView!.allowsMultipleSelection = true
  }
  
  
  override func viewDidLayoutSubviews() {
    if (footerView.subviews.count < 1) {
      footerView.addPlayerButtons(game.players, target: self, action: Selector("makeMoveAction:"))
    }
    
    collectionView.reloadData()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    headerView.setNeedsLayout()
    wrapperView.setNeedsLayout()
    footerView.setNeedsLayout()
  }

  
  @IBAction func tapDeckAction(sender: UIButton) {
    game.startNewRound(game.numberOfCardPositions())
    
    collectionView!.reloadData()
    
    sgDelegate.selectIdxPaths = []
  }
  
  
  func makeMoveAction(sender: UIButton) {
    sgDelegate.makeMove(collectionView, game: game, playerTag: sender.tag)
  }
  
  
  
  func startNewGame() {
    sgDataSource.game = SetGame(_players: game.players)
  }

  
  func endCurrentGame() {
    game.endGame()
  }

  // - MARK: - Private Functions ------------------------------------
}