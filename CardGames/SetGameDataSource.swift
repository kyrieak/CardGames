//
//  SetCardCollectionDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 2/27/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SetGameDataSource: NSObject, UICollectionViewDataSource {
  let cellReuseId   = "card_cell"
  let headerReuseId = "game_header"
  let footerReuseId = "game_footer"

  let deckButtonTag = 1
  let style = Style()
  
  let game: SetGame
  
  override init() {
    game = SetGame(numPlayers: 2)
    
    super.init()
  }
  
  func startNewRound() {
    game.startNewRound(15)
  }
  
  // --- DataSource Functions ------------------------------------
  
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
      var card: SetCard? = game.getCardAt(indexPath.item)

      var cell = (collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId,
        forIndexPath: indexPath) as? UICollectionViewCell)!
      
      if (card != nil) {
//        cell.backgroundView = cellBgView(cell.frame)
        cell.backgroundView = tempBgView(card!, withFrame: cell.frame)
        cell.selectedBackgroundView = tempBgSelectedView(card!, withFrame: cell.frame)
//        cell.backgroundView = cellBgView(card!, withFrame: cell.frame)
//        cell.selectedBackgroundView = cellSelectedBgView(card!, withFrame: cell.frame)
      } else {
        cell.backgroundView = nil
        cell.selectedBackgroundView = nil
      }
      
      cell.selected = false
      
      return cell
  }

  
  
  // --- Private Functions ------------------------------------

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
  
  
  private func cellBgView(card: SetCard, withFrame: CGRect) -> UILabel {
    var bgView = UILabel(frame: withFrame)
    
    bgView.text            = card.shape
    bgView.textColor       = card.color
    bgView.textAlignment   = NSTextAlignment.Center
    bgView.backgroundColor = UIColor.whiteColor()
    
    style.applyShade(bgView.layer, color: style.darkShadeColor, thickness: 1)
    
    return bgView
  }
  
  private func tempBgView(card: SetCard, withFrame: CGRect) -> SetCardView {
    var view = SetCardView(frame: withFrame, color: card.color, shape: card.shape, count: card.number)
    
    view.backgroundColor = UIColor.whiteColor()
    
    return view
  }

  private func tempBgSelectedView(card: SetCard, withFrame: CGRect) -> SetCardView {
    var selectedView = tempBgView(card, withFrame: withFrame)

    selectedView.layer.borderWidth = 2
    selectedView.layer.borderColor = UIColor.blueColor().CGColor
    
    return selectedView
  }

  private func cellSelectedBgView(card: SetCard, withFrame: CGRect) -> UILabel {
    var selectedView = cellBgView(card, withFrame: withFrame)

    selectedView.layer.borderWidth = 2
    selectedView.layer.borderColor = UIColor.blueColor().CGColor
//    var selectedView = UILabel(frame: withFrame)
//    
//    selectedView.text            = card.shape
//    selectedView.textColor       = card.color
//    selectedView.textAlignment   = NSTextAlignment.Center
//    selectedView.backgroundColor = UIColor.whiteColor()
//    
//    style.applyShade(selectedView.layer, color: style.darkShadeColor, thickness: 1)

    return selectedView
  }
}