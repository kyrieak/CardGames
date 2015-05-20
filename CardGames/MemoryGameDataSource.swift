//
//  MemoryGameDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/4/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class MemoryGameDataSource: NSObject, UICollectionViewDataSource {
  let cellReuseId   = "card_cell"
  let headerReuseId = "game_header"
  let footerReuseId = "game_footer"
  
  let deckButtonTag = 1
  let style = Style()
  
  let game: MemoryGame
  
  override init() {
    game = MemoryGame(players: ["Kyrie"])
    
    super.init()
  }
  
  func startNewRound() {
    game.startNewRound(15)
  }

  // - MARK: - DataSource Functions -------------------------
  
  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return game.numberOfCardPositions()
  }
  
  
  func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      var suppView: UICollectionReusableView
      
      switch (kind) {
      case UICollectionElementKindSectionHeader:
        suppView = dequeHeaderView(collectionView, indexPath: indexPath)
        applyHeaderStyle(&suppView)
        break
      case UICollectionElementKindSectionFooter:
        suppView = dequeFooterView(collectionView, indexPath: indexPath)
        applyFooterStyle(&suppView, collectionViewHeight: collectionView.layer.frame.height)
        break
      default:
        suppView = UICollectionReusableView()
        break
      }
      
      return suppView
  }
  
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      var card: TrumpCard? = game.getCardAt(indexPath.item)
      
      var cell = (collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId,
        forIndexPath: indexPath) as? UICollectionViewCell)!
      
      if (card != nil) {
        cell.backgroundView = cellBgView(cell.frame)
        cell.selectedBackgroundView = cellSelectedBgView(card!, withFrame: cell.frame)
      } else {
        cell.backgroundView = nil
        cell.selectedBackgroundView = nil
      }
      
      cell.selected = false
      
      return cell
  }
  
  
  
  // - MARK: - Private Functions ------------------------------------
  
  private func dequeHeaderView(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionReusableView {
    
    return (collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
      withReuseIdentifier: headerReuseId,
      forIndexPath: indexPath) as? UICollectionReusableView)!
  }
  
  
  private func dequeFooterView(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionReusableView {
    
    return (collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
      withReuseIdentifier: footerReuseId,
      forIndexPath: indexPath) as? UICollectionReusableView)!
  }
  
  
  private func applyHeaderStyle(inout suppView: UICollectionReusableView) {
    var buttonLeft = suppView.viewWithTag(deckButtonTag)!
    
    style.applyShade(suppView.layer)
    style.applyCardBg(buttonLeft, withScale: 3.0)
    style.applyShade(buttonLeft.layer, color: style.liteShadeColor, thickness: 2)
  }
  
  
  private func applyFooterStyle(inout suppView: UICollectionReusableView, collectionViewHeight: CGFloat) {
    var label = suppView.viewWithTag(1)!
    
    suppView.frame.origin.y = collectionViewHeight - 100
    
    if (label.layer.borderWidth == 0) {
      style.applyShade(label.layer)
    }
  }
  
  
  private func cellBgView(withFrame: CGRect) -> UIView {
    var bgView = UIView(frame: withFrame)
    style.applyCardBg(bgView, withScale: 3.0)
    style.applyShade(bgView.layer)
    
    return bgView
  }
  
  
  private func cellSelectedBgView(card: TrumpCard, withFrame: CGRect) -> TrumpCardView {
    var cardAttrs = TrumpCardAttributes(card: card)
    cardAttrs.faceUp = true

    var selectedView = TrumpCardView(frame: withFrame, attrs: cardAttrs)
    selectedView.backgroundColor = UIColor.whiteColor()
//    style.applyShade(selectedView.layer, color: style.darkShadeColor, thickness: 1)
    
    return selectedView
  }
}