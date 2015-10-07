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
  let footerReuseId = "game_status"

  let deckButtonTag = 1
  
  var game: SetGame

  lazy var cardLayerStyle: UILayerStyle = {
    return styleGuide.cardFrontLayerStyle
  }()
  
  lazy var footerLayerStyle: UILayerStyle = {
    return styleGuide.footerLayerStyle
  }()
  
  lazy var footerFontSet: UIFontSet = {
    return styleGuide.footerFontSet
  }()
  
  
  override init() {
    game = SetGame(numPlayers: 2)
    
    super.init()
  }
  
  
  
  func startNewRound() {
    game.startNewRound(12)
  }
  
  // - MARK: - DataSource Functions ------------------------------------
  
  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return game.numberOfCardPositions()
  }
  
  
  func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      
      if (kind == UICollectionElementKindSectionFooter) {
        return dequeFooterView(collectionView, indexPath: indexPath)
      } else {
        return UICollectionReusableView()
      }
  }
  
  
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      let card = game.getCardAt(indexPath.item)
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseId,
                                                              forIndexPath: indexPath)
      
      if (card != nil) {
        cell.backgroundView = cellBgView(card!, withFrame: cell.frame)
        cell.selectedBackgroundView = cellSelectedView(card!, withFrame: cell.frame)
      }
      
      return cell
  }
  
  
  
  

  
  // - MARK: - Private Functions ------------------------------------

  
  private func dequeFooterView(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionReusableView {
    let sectionFooter = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
      withReuseIdentifier: footerReuseId,
      forIndexPath: indexPath) as UICollectionReusableView
//    var label = sectionFooter.viewWithTag(1)! as! UILabel
    
    footerLayerStyle.apply(sectionFooter)
//    footerFontSet.applyFont(label, h: nil)
    
    return sectionFooter
  }
  
  
  private func cellBgView(card: SetCard, withFrame: CGRect) -> SetCardView {
    let view = SetCardView(frame: withFrame, attrs: card.attributes())
    
    cardLayerStyle.apply(view)

    return view
  }
  
  
  private func cellSelectedView(card: SetCard, withFrame: CGRect) -> SetCardView {
    let selectedView = cellBgView(card, withFrame: withFrame)
    
    selectedView.layer.borderWidth = 2
    selectedView.layer.borderColor = UIColor.blueColor().CGColor
    
    return selectedView
  }
}