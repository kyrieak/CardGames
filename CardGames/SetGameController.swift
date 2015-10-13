//
//  SetGameController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/27/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGameController: UIViewController, StyleGuideDelegate {
  
  // - MARK: - CollectionView
  
  @IBOutlet var sgDataSource: SetGameDataSource!
  @IBOutlet var sgDelegate: SetGameDelegate!
  
  var game: SetGame {
    return sgDataSource.game
  }
  
  // - MARK: Subviews
  
  @IBOutlet var headerView: SGHeaderView!
  @IBOutlet var footerView: SGFooterView!
  @IBOutlet var wrapperView: UIView!
  @IBOutlet var collectionView: UICollectionView!
  
  var deckButton: UIButton {
    return headerView.deckButton
  }

  // - MARK: Private Properties
  
  private(set) var style: StyleGuide = styleGuide
  private(set) var themeID: Int = styleGuide.themeID
  private var layerSelectors: [ViewSelector] = [.MainContent, .Header, .Footer, .Status, .CardBack, .FooterUIBtn]
  private var textSelectors: [ViewSelector] = [.HeadTitle, .FooterUIBtn]
  
  
  // - MARK: - Override Functions

  
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
    applyStyleToViews()
    
    NSLog("\(footerView.subviews.first?.backgroundColor)")
  }
  
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    headerView.setNeedsLayout()
    wrapperView.setNeedsLayout()
    footerView.setNeedsLayout()
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "gameSettingsSegue") {
      let dvc = segue.destinationViewController as! GameSettingsController
      
      dvc.settings = game.settings
    }
    
    super.prepareForSegue(segue, sender: sender)
  }
  
  // - MARK: - UIActions
  
  @IBAction func tapDeckAction(sender: UIButton) {
    let alert = UIAlertController(title: "My Alert",
                                    message: "This is an action sheet.",
                                      preferredStyle: .Alert)
    
    let redealAction = UIAlertAction(title: "Redeal", style: .Default)
                                      { (alert: UIAlertAction!) -> Void in
      self.redealCards()
    }
    
    let newGameAction = UIAlertAction(title: "New Game", style: .Default)
                                        { (alert: UIAlertAction!) -> Void in
      let vc = self.storyboard?.instantiateViewControllerWithIdentifier("gameSettingController")

      self.presentViewController(vc!, animated: true, completion: nil)
    }
    
    alert.addAction(redealAction)
    alert.addAction(newGameAction)
    
    presentViewController(alert, animated: true, completion:nil)
  }

  
  @IBAction func makeMoveAction(sender: UIButton) {
    sgDelegate.makeMove(collectionView, game: game, playerTag: sender.tag)
  }
  
  // - MARK: - Unwind Segue Functions
  
  
  @IBAction func prepareForNewGame(segue: UIStoryboardSegue) {
    if (segue.identifier == "newGameSegue") {
      let vc = segue.sourceViewController as! GameSettingsController

      startNewGame(vc.settings)
      
      footerView.layoutPlayerBtns(game.players)
    } else {
      startNewGame(game.settings)
    }
  }
  
  
  @IBAction func prepareForThemeChange(segue: UIStoryboardSegue) {
    if (themeID != styleGuide.themeID) {
      applyStyleToViews()
    }
  }
  
  
  // - MARK: - Private Functions
  
  private func startNewGame(settings: GameSettings) {
    if (game.settings.numPlayers != settings.numPlayers) {
    }
    sgDataSource.game = SetGame(settings: settings)

    collectionView.reloadData()
  }

  
  private func endCurrentGame() {
    game.endGame()
  }
  
  
  private func redealCards() {
    game.startNewRound(game.numberOfCardPositions())
    
    collectionView!.reloadData()
    
    sgDelegate.selectIdxPaths = []
  }
  
  
  
  // - MARK: - UIViewStyleDelegate Protocol Functions
  
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [collectionView]
      case .Header, .Footer:
        return [headerView, footerView]
      case .Status:
        return (sgDelegate.statusView == nil) ? [] : [sgDelegate.statusView!]
      case .CardBack:
        return [deckButton]
      case .FooterUIBtn:
        return footerView.subviews
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    switch(sel) {
      case .HeadTitle:
        return [headerView.titleLabel]
      case .FooterUIBtn:
        return footerView.playerBtnLabels
      default:
        return []
    }
  }
  
  func applyStyleToViews() {
    for elem in layerSelectors {
      styleGuide.applyLayerStyle(elem, views: viewsForLayerStyle(elem))
    }
    
    for elem in textSelectors {
      styleGuide.applyFontStyle(elem, views: viewsForFontStyle(elem))
    }
  }
}


