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
  typealias sg = SGStyleGuide
  
  let tags = SetGameController.sectionTags()
  private(set) var paused: Bool = false

  // - MARK: - CollectionView
  
  @IBOutlet var sgDataSource: SetGameDataSource!
  @IBOutlet var sgDelegate: SetGameDelegate!
  
  var game: SetGame { return sgDataSource.game }
  
  // - MARK: Subviews
  
  lazy var headerView: SGHeaderView          = { return self.view.viewWithTag(1)! as! SGHeaderView }()
  lazy var footerView: SGFooterView          = { return self.view.viewWithTag(3)! as! SGFooterView }()

  lazy var wrapperView: UIView               = { return self.view.viewWithTag(2)! }()
  lazy var collectionView: UICollectionView? = { return self.view.viewWithTag(20) as? UICollectionView }()
  
  var deckButton: UIButton { return headerView.deckButton }
  
  // - MARK: Private Properties
  
  private(set) var styleGuide: SGStyleGuide = appGlobals.styleGuide
  private(set) var themeID: Int?

  private var layerSelectors: [ViewSelector] = SetGameController.selectorsForViewLayers()
  private var btnSelectors:   [ViewSelector] = SetGameController.selectorsForBtns()
  
  // - MARK: - Override Functions

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    appGlobals.gameIsActive = true
    collectionView!.allowsMultipleSelection = true
  }
  
  override func viewWillLayoutSubviews() {
    if (deviceInfo.screenDims.min < 400) {
      adjustConstraintsForSmallScreen()
    }
  }
  
  
  override func viewDidLayoutSubviews() {
    if (footerView.subviews.count < 1) {
      footerView.addPlayerButtons(game.players, target: self, action: Selector("makeMoveAction:"))
    }
    
    if (themeID != styleGuide.themeID) {
      applyStyleToViews()
    }
  }
  
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    headerView.setNeedsLayout()
    wrapperView.setNeedsLayout()
    footerView.setNeedsLayout()
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    
    setPause()
    
    if (segue.identifier != nil) {
      let sid = segue.identifier!
      
      if (sid == "modalToScores") {
        let dvc = segue.destinationViewController as! ScoresController
        
        dvc.stats = game.stats
      }
    }
  }
  
  
  func themeDidChange() -> Bool {
    return (themeID != styleGuide.themeID)
  }
  
  // - MARK: - UIActions
  
  @IBAction func tapLogoAction(sender: UIButton) {
    let vc = storyboard!.instantiateViewControllerWithIdentifier("homeViewController")
    
    self.presentViewController(vc, animated: true, completion: nil)
  }
  
  
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
  
  
  @IBAction func tapGearAction(sender: UIButton) {
    setPause()

    let vc = storyboard!.instantiateViewControllerWithIdentifier("gameSettingController")
    
    self.presentViewController(vc, animated: true, completion: nil)
  }

  
  @IBAction func makeMoveAction(sender: UIButton) {
    sgDelegate.makeMove(collectionView!, game: game, playerTag: sender.tag)

    styleGuide.applyLayerStyle(.FooterUIBtn, views: [sender])
  }

  
  // - MARK: - Unwind Segue Functions
  
  @IBAction func prepareUnwind(segue: UIStoryboardSegue) {
    unpause()

    prepareForThemeChange()
    
    if (segue.identifier == "unwindToNewGame") {
      startNewGame(appGlobals.gameSettings)
    }
  }
  
  
  @IBAction func prepareUnwindToGame(segue: UIStoryboardSegue) {
    prepareUnwind(segue)
  }
  
  
  func prepareForThemeChange() {
    if (themeID != styleGuide.themeID) {
      applyStyleToViews()
      
      themeID = styleGuide.themeID
    }
  }

  
  // - MARK: - Private Functions
  
  private func startNewGame(settings: GameSettings) {
    sgDataSource.game = SetGame(settings: settings)
    collectionView!.reloadData()

    sgDelegate.reset()
    deckButton.enabled = true
    footerView.layoutPlayerBtns(appGlobals.gameSettings.players)

    styleGuide.applyLayerStyle(.CardBack, views: [deckButton])
    styleGuide.applyBtnStyle(.FooterUIBtn, views: footerView.playerBtns)
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
        return [collectionView!]
      case .Header:
        return [headerView]
      case .Footer:
        return [footerView]
      case .Status:
        return [sgDelegate.statusView]
      case .CardBack:
        return [deckButton]
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    if (sel == .Status) {
      return [sgDelegate.statusView.messageView]
    } else {
      return []
    }
  }
  
  
  func viewsForBtnStyle(sel: ViewSelector) -> [UIButton] {
    switch(sel) {
    case .HeadTitle:
      return [headerView.logoButton]
    case .FooterUIBtn:
      return footerView.playerBtns
    default:
      return []
    }
  }
  
  
  func getHeaderView() -> SGHeaderView {
    return self.view.viewWithTag(1)! as! SGHeaderView
  }
  
  class func sectionTags() -> (header: Int, wrapper: Int, footer: Int) {
    return (header: 1, wrapper: 2, footer: 3)
  }
  
  class func selectorsForViewLayers() -> [ViewSelector] {
    return [.MainContent, .Header, .Footer, .Status, .CardBack]
  }
  
  class func selectorsForBtns() -> [ViewSelector] {
    return [.HeadTitle, .FooterUIBtn]
  }
  
  func applyStyleToViews() {
    for sel in layerSelectors {
      styleGuide.applyLayerStyle(sel, views: viewsForLayerStyle(sel))
    }
    
    for sel in btnSelectors {
      styleGuide.applyBtnStyle(sel, views: viewsForBtnStyle(sel))
    }
    
    styleGuide.applyFontStyle(.Status, views: viewsForFontStyle(.Status))
    
    if (game.deck.isEmpty()) {
      deckButton.backgroundColor = UIColor.clearColor()
    }
    
    headerView.gearButton.setTitleColor(styleGuide.theme.fontColor2, forState: .Normal)
    headerView.gearButton.setTitleShadowColor(styleGuide.theme.fontColor2.getShade(-0.2), forState: .Normal)
    
//    let scoreIcon = sgDelegate.statusView.viewWithTag(5) as! UIButton
    
//    scoreIcon.setTitleColor(UIColor(red: 0.45, green: 0.14, blue: 0.15, alpha: 1.0), forState: .Normal)

    updateCollectionViewStyle()
    themeID = styleGuide.themeID
  }
  
  func updateCollectionViewStyle() {
    for path in collectionView!.indexPathsForVisibleItems() {
      let cell = collectionView!.cellForItemAtIndexPath(path)!

      cell.backgroundColor = styleGuide.theme.patternColor
      cell.selectedBackgroundView!.layer.borderColor = styleGuide.theme.bgColor3.CGColor

      if (cell.selected) { cell.setNeedsDisplay() }
    }
  }
  
  func setPause() {
    paused = true
    
    for path in collectionView!.indexPathsForVisibleItems() {
      sgDelegate.flipFaceDown(collectionView!, indexPath: path)
    }
  }
  
  func unpause() {
    paused = false
    
    for path in collectionView!.indexPathsForVisibleItems() {
      sgDelegate.flipFaceUp(collectionView!, indexPath: path)
    }
  }
  
  func setAllCardsFaceUp() {
    paused = false

    for path in collectionView!.indexPathsForVisibleItems() {
      sgDelegate.flipFaceUp(collectionView!, indexPath: path)
    }
  }
  
  func setAllCardsFaceDown() {
    paused = true

    for path in collectionView!.indexPathsForVisibleItems() {
      sgDelegate.flipFaceDown(collectionView!, indexPath: path)
    }
  }
  
  private func adjustConstraintsForSmallScreen() {
    let layout = (collectionView!.collectionViewLayout as! SGCollectionViewLayout)
    let cardSize = layout.itemSize
    
    for c in headerView.constraints {
      if (c.identifier == "sectionInset") {
        c.constant = layout.sectionInset.left
      }
    }
    
    for c in deckButton.constraints {
      switch (c.firstAttribute) {
        case .Width:
          c.constant = cardSize.width
        case .Height:
          c.constant = cardSize.height
        default:
          NSLog("attribute was \(c.firstAttribute)")
      }
    }
  }
}


