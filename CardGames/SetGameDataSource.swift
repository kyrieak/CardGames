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
  
  
  // - MARK: - Initializers
  
  init(settings: GameSettings) {
    game = SetGame(settings: settings)
    
    super.init()
  }
  
  convenience override init() {
    self.init(settings: appGlobals.gameSettings)
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
        cell.backgroundColor = appGlobals.styleGuide.theme.patternColor
        cell.backgroundView = cellBgView(card!, withFrame: cell.frame)
        cell.selectedBackgroundView = cellSelectedView(card!, withFrame: cell.frame)
      }
      
      return cell
  }
  
  
  
  // - MARK: - Private Functions ------------------------------------

  
  private func dequeFooterView(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionReusableView {
    let sectionFooter = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
                                          withReuseIdentifier: footerReuseId,
                                          forIndexPath: indexPath)
    
    appGlobals.styleGuide.applyLayerStyle(.Status, views: [sectionFooter])

    return sectionFooter
  }
  
  
  private func cellBgView(card: SetCard, withFrame: CGRect) -> SetCardView {
    let view = SetCardView(frame: withFrame, attrs: card.attributes())

    view.accessibilityLabel = accessLabelFor(card)

    appGlobals.styleGuide.applyLayerStyle(.CardFront, views: [view])

    return view
  }
  
  
  private func cellSelectedView(card: SetCard, withFrame: CGRect) -> SetCardView {
    let selectedView = cellBgView(card, withFrame: withFrame)
    
    selectedView.layer.borderWidth = 2
    selectedView.layer.borderColor = appGlobals.styleGuide.theme.bgColor3.CGColor
//    selectedView.layer.borderColor = styleGuide.theme.bgBase.getShade(-0.15).CGColor
//    selectedView.layer.borderColor = UIColor.blueColor().CGColor
    
    return selectedView
  }
  
  private func accessLabelFor(card: SetCard) -> String {
    let opt = game.options
    var text: String
    
    if (opt.colorsOn && opt.shadingOn && opt.shapesOn) {
      text = card.attributes().toString()
    } else {
      text = "\(card.number)"
      
      if (opt.colorsOn) {
        text += " \(card.color.toString)"
      }
      
      if (opt.shadingOn) {
        text += " \(card.shading.toString)"
      }

      text += " \(card.shape.toString)"

      if (card.number > 1) {
        text += "s"
      }
    }
    
    return text
  }
}