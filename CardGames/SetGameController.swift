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

  private var layerSelectors: [ViewSelector] = SetGameController.selectorsForViewLayers()
  private var textSelectors: [ViewSelector] = SetGameController.selectorsForViewText()
  
  // - MARK: - Override Functions

  
  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView!.allowsMultipleSelection = true
  }
  
  
  override func viewDidLayoutSubviews() {
    if (footerView.subviews.count < 1) {
      footerView.addPlayerButtons(game.players, target: self, action: Selector("makeMoveAction:"))
    }

    if (deviceIsMobile) {
      adjustForMobileScreenSize()
    }
    
    collectionView.reloadData()

    applyStyleToViews()
  }
  
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    headerView.setNeedsLayout()
    wrapperView.setNeedsLayout()
    footerView.setNeedsLayout()
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier != nil) {
      let sid = segue.identifier!
      
      if (sid == "gameSettingSegue") {
        gameSettings.options = game.options
      }
    }
  }
  
  // - MARK: - UIActions
  
  @IBAction func tapDeckAction(sender: UIButton) {
    if (!game.isOver) {
      self.redealCards()

      if (game.deck.isEmpty()) {
        sender.backgroundColor = UIColor.clearColor()
        sender.setTitle("Empty", forState: UIControlState.Disabled)
        sender.enabled = false
      }
    }
  }

  
  @IBAction func makeMoveAction(sender: UIButton) {
    sgDelegate.makeMove(collectionView, game: game, playerTag: sender.tag)

    styleGuide.applyLayerStyle(.FooterUIBtn, views: [sender])
  }

  
  // - MARK: - Unwind Segue Functions
  
  @IBAction func prepareForNewGame(segue: UIStoryboardSegue) {
    startNewGame(gameSettings)
    sgDelegate.statusView?.clear()
    footerView.layoutPlayerBtns(gameSettings.players)
  }
  
  
  @IBAction func prepareForThemeChange(segue: UIStoryboardSegue) {
    if (themeID != styleGuide.themeID) {
      applyStyleToViews()
    }
  }
  
  
  // - MARK: - Private Functions
  
  private func startNewGame(settings: GameSettings) {
    styleGuide.applyLayerStyle(.CardBack, views: [deckButton])
    
    sgDataSource.game = SetGame(settings: settings)
    sgDelegate.reset()

    collectionView.reloadData()
    deckButton.enabled = true
  }

  
  private func endCurrentGame() {
    game.endGame()
  }
  
  
  private func redealCards() {
    game.startNewRound(game.numberOfCardPositions())
    sgDelegate.reset()
    
    collectionView!.reloadData()
  }
  
  
  
  // - MARK: - UIViewStyleDelegate Protocol Functions
  
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [collectionView]
      case .Header:
        return [headerView]
      case .Footer:
        return [footerView]
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
  
  class func selectorsForViewLayers() -> [ViewSelector] {
    return [.MainContent, .Header, .Footer, .Status, .CardBack, .FooterUIBtn]
  }
  
  class func selectorsForViewText() -> [ViewSelector] {
    return [.HeadTitle, .FooterUIBtn]
  }
  
  func applyStyleToViews() {
    for elem in layerSelectors {
      styleGuide.applyLayerStyle(elem, views: viewsForLayerStyle(elem))
    }
    
    for elem in textSelectors {
      styleGuide.applyFontStyle(elem, views: viewsForFontStyle(elem))
    }
    
    if (game.deck.isEmpty()) {
      deckButton.backgroundColor = UIColor.clearColor()
    }
    
    styleGuide.applyBtnFontStyle(.FooterUIBtn, views: footerView.playerBtns)
  }

  
  private func adjustForMobileScreenSize() {
    if (minScreenDim > 376) {
      for c in headerView.constraints {
        if (c.firstAttribute == NSLayoutAttribute.Height) {
          c.constant = CGFloat(143)
        }
      }
      
      for c in deckButton.constraints {
        if (c.firstAttribute == NSLayoutAttribute.Height) {
          c.constant = CGFloat(105)
        } else if (c.firstAttribute == NSLayoutAttribute.Width) {
          c.constant = CGFloat(80)
        }
      }
    }
  }
}


