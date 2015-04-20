//
//  CardCollectionDelegate.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 1/16/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class TrumpCardCollectionDataSource: NSObject, UICollectionViewDataSource {
  let viewHeight: Int?
  var cardsInPlay: [TrumpCard?]
  var cardPairs: Array<[TrumpCard]>
  
  let deckButtonTag = 1
  let pageButtonTag = 2

  let style = Style()
  
//  override init() {
//    cardsInPlay = []
//    cardPairs = Array<[TrumpCard]>()
//    
//    super.init()
//
//    loadNewCardSet()
//  }
  
  init(totalViewHeight: Int) {
    cardsInPlay = []
    cardPairs = Array<[TrumpCard]>()
    viewHeight = totalViewHeight

    super.init()

    loadNewCardSet()
  }
  
  
  // --- Game Interfacing Functions ------------------------------------
  
  func loadNewCardSet() {
    let standardSet = TrumpCard.standardSet()
    
    if (cardPairs.count > 0) { cardPairs = Array<[TrumpCard]>() }
    
    for (key, cardSet) in standardSet {
      var cards: [TrumpCard] = []
      
      for card in cardSet.allObjects {
        cards.append(card as! TrumpCard)
      }
      
      TrumpCardCollectionDataSource.shuffleCards(&cards)
      
      cardPairs.append([cards[0], cards[1]])
      cardPairs.append([cards[2], cards[3]])
      
      cardSet.removeAllObjects()
    }
    
    TrumpCardCollectionDataSource.shufflePairs(&cardPairs)
  }
  
  
  func loadNextCards() {
    cardsInPlay = []
    
    for i in 0...7 {
      var pair = getNextPair()
      
      if (pair != nil) {
        cardsInPlay.append(pair![0])
        cardsInPlay.append(pair![1])
      } else {
        break
      }
    }
    
    TrumpCardCollectionDataSource.shuffleCards(&cardsInPlay)
  }

  
  func hasCardAt(idxPath: NSIndexPath) -> Bool {
    return (cardsInPlay[idxPath.item] != nil)
  }
  
  
  func getCardAt(idxPath: NSIndexPath) -> TrumpCard? {
    return cardsInPlay[idxPath.item]
  }

  
  func removeCardsAt(idxPaths: [NSIndexPath]) {
    for path in idxPaths {
      cardsInPlay[path.item] = nil
    }
  }
  
  
  func hasSelectableCards() -> Bool {
    for card in cardsInPlay {
      if card != nil {
        return true
      }
    }
    
    return false
  }

  
  // --- DataSource Functions ------------------------------------
  
  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return cardsInPlay.count
  }
  
  
  func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      var reuseId: String
      
      switch (kind) {
      case UICollectionElementKindSectionHeader:
        reuseId = TrumpCardCollectionDataSource.headerReuseId()
        break
      case UICollectionElementKindSectionFooter:
        reuseId = TrumpCardCollectionDataSource.footerReuseId()
        break
      default:
        return UICollectionReusableView()
      }
      
      var suppView = (collectionView.dequeueReusableSupplementaryViewOfKind(kind,
        withReuseIdentifier: reuseId,
        forIndexPath: indexPath) as? UICollectionReusableView)!
      
      if (kind == UICollectionElementKindSectionHeader) {
        var buttonLeft = suppView.viewWithTag(deckButtonTag)!
//        var buttonRight = suppView.viewWithTag(pageButtonTag)!

        style.applyShade(suppView.layer)
        style.applyCardBg(buttonLeft, withScale: 3.0)
        style.applyShade(buttonLeft.layer, color: style.liteShadeColor, thickness: 2)
//        style.applyShade(buttonRight.layer, color: style.liteShadeColor, thickness: 1)
      } else {
        suppView.frame.origin.y = collectionView.layer.frame.height - 100
        var label = suppView.viewWithTag(1)!
        
        if (label.layer.borderWidth == 0) {
          style.applyShade(label.layer)
        }
      }
      
      return suppView
  }
  
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      var cell = (collectionView.dequeueReusableCellWithReuseIdentifier(TrumpCardCollectionDataSource.cellReuseId(),
        forIndexPath: indexPath) as? UICollectionViewCell)!
      
      if (cardsInPlay[indexPath.item] != nil) {
        cell.backgroundView = UIView(frame: cell.frame)
        style.applyCardBg(cell.backgroundView!, withScale: 3.0)
        cell.selectedBackgroundView = labelFor(cardsInPlay[indexPath.item]!, withFrame: cell.frame)

        style.applyShade(cell.backgroundView!.layer)
        style.applyShade(cell.selectedBackgroundView!.layer, color: style.darkShadeColor, thickness: 1)
      } else {
        cell.backgroundView = nil
        cell.selectedBackgroundView = nil
      }
      
      cell.selected = false
      
      return cell
  }
  
  
  // --- Private Functions ------------------------------------
  
  private func getNextPair() -> [TrumpCard]? {
    if (cardPairs.count > 0) {
      return cardPairs.removeAtIndex(0)
    } else {
      return nil
    }
  }
  
  
  private func labelFor(card: TrumpCard, withFrame: CGRect) -> UILabel {
    var label = UILabel(frame: withFrame)
    
    label.text = card.label()
    label.textColor = Style.getUIColorFor(card.color())
    label.textAlignment = NSTextAlignment.Center
    label.backgroundColor = UIColor.whiteColor()
    
    return label
  }
  
  // --- Class Functions ------------------------------------
  
  class func shufflePairs(inout cardPairs: Array<[TrumpCard]>) {
    let rIdx = cardPairs.count - 1
    
    if (rIdx > -1) {
      for i in 0...rIdx {
        var j = Int(arc4random_uniform(UInt32(rIdx)))
        var temp: [TrumpCard] = cardPairs[i]
        
        cardPairs[i] = cardPairs[j] as [TrumpCard]
        cardPairs[j] = temp
      }
    }
  }
  
  
  class func shuffleCards(inout cards: [TrumpCard]) {
    let rIdx = cards.count - 1
    
    if (rIdx > -1) {
      for i in 0...rIdx {
        var j = Int(arc4random_uniform(UInt32(rIdx)))
        var temp = cards[i]
        
        cards[i] = cards[j]
        cards[j] = temp
      }
    }
  }
  
  
  class func shuffleCards(inout cards: [TrumpCard?]) {
    let rIdx = cards.count - 1

    if (rIdx > -1) {
      for i in 0...rIdx {
        var j = Int(arc4random_uniform(UInt32(rIdx)))
        var temp = cards[i]
        
        cards[i] = cards[j]
        cards[j] = temp
      }
    }
  }
  
  
  class func headerReuseId() -> String {
    return "game_header"
  }
  
  
  class func footerReuseId() -> String {
    return "game_footer"
  }
  
  
  class func cellReuseId() -> String {
    return "card_cell"
  }
  
}


/* Replace above section with this to test triple match game
//
for i in 0...3 {
cardsInPlay.append(TrumpCard(suit: TrumpCard.hearts(), rank: 3))
cardsInPlay.append(TrumpCard(suit: TrumpCard.spades(), rank: 3))
cardsInPlay.append(TrumpCard(suit: TrumpCard.diamonds(), rank: 3))
cardsInPlay.append(TrumpCard(suit: TrumpCard.clubs(), rank: 3))
}
*/

