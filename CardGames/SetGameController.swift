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
  
  var theme: ThemeLabel = styleGuide.theme.label
  
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
    let alert = UIAlertController(title: "My Alert", message: "This is an action sheet.", preferredStyle: .Alert) // 1
    
    let redealAction = UIAlertAction(title: "Redeal", style: .Default) { (alert: UIAlertAction!) -> Void in
      self.redealCards()
    }
    
    let newGameAction = UIAlertAction(title: "New Game", style: .Default) { (alert: UIAlertAction!) -> Void in
      self.startNewGame()
    }
    
    alert.addAction(redealAction)
    alert.addAction(newGameAction)
    
    presentViewController(alert, animated: true, completion:nil)
  }
  
  
  func redealCards() {
    game.startNewRound(game.numberOfCardPositions())
    
    collectionView!.reloadData()
    
    sgDelegate.selectIdxPaths = []
  }
  
  @IBAction func unwindToNewGame(segue: UIStoryboardSegue) {
    startNewGame()
  }
  
//  @IBAction func tapOnModal(segue: UIStoryboardSegue, sender: UITapGestureRecognizer) {
//    let frame = segue.sourceViewController.view.frame
//    let pt = sender.locationInView(nil)
//    
//    if ((pt.x < frame.minX) || (pt.x > frame.maxX) ||
//        (pt.y < frame.minY) || (pt.y > frame.maxY)) {
//      segue.sourceViewController.dismissViewController()
//    } else {
//      segue.cancel
//    }
//    
//  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    NSLog("segue preparing from set game controller")
    
    if (segue.identifier == "gameSettingsSegue") {
      let dvc = segue.destinationViewController as! GameSettingsController
      
      dvc.settings = game.settings
    }
    
    super.prepareForSegue(segue, sender: sender)
  }
  
  @IBAction func prepareForUnwind(segue: UIStoryboardSegue, sender: AnyObject?) {
    NSLog("preparing for segue --------")
    
    if ((sender as? AppSettingsController) != nil) {
      if (theme != styleGuide.theme.label) {
        theme = styleGuide.theme.label
        headerView.backgroundColor = styleGuide.theme.bgColor2
        footerView.backgroundColor = styleGuide.theme.bgColor2
        collectionView.backgroundColor = styleGuide.theme.bgColor1
        sgDelegate.statusView!.backgroundColor = styleGuide.theme.bgColor3
        (headerView.viewWithTag(5)! as! UILabel).textColor = styleGuide.headerFontSet.color
        
      } else {
        NSLog("\(styleGuide.theme.label)")
      }
    } else if ((sender as? UIButton) != nil){
      let btn = sender as! UIButton

      if (btn.titleLabel!.text == "Redeal") {
        self.tapDeckAction(btn)
      } else if (btn.titleLabel!.text == "New Game") {
        self.startNewGame()
      }
    }
  }
  
  
  func makeMoveAction(sender: UIButton) {
    sgDelegate.makeMove(collectionView, game: game, playerTag: sender.tag)
  }
  
  
  
  func startNewGame() {
    sgDataSource.game = SetGame(_players: game.players)
    collectionView.reloadData()
  }

  
  func endCurrentGame() {
    game.endGame()
  }

  // - MARK: - Private Functions ------------------------------------
}