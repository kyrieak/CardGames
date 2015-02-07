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
  let cardBackImage = UIImage(named: "card_back")
  let stdCardSet = TrumpCard.standardSet()
  let viewHeight: Int?
  var cardsInPlay: [TrumpCard?] = []
  var cardPairs: Array<[TrumpCard]> = Array<[TrumpCard]>()
  var headerView, footerView: UICollectionReusableView?
  
  override init() {
    for (key, cardSet) in stdCardSet {
      var cards: [TrumpCard] = []
      
      for card in cardSet.allObjects {
        cards.append(card as TrumpCard)
      }
      
      TrumpCardCollectionDataSource.shuffleCards(&cards)
      
      cardPairs.append([cards[0], cards[1]])
      cardPairs.append([cards[2], cards[3]])

      cardSet.removeAllObjects()
    }
    
    super.init()
    
    shufflePairs()
    changeCards()
  }
  
  init(totalViewHeight: Int) {
    super.init()

    viewHeight = totalViewHeight
  }
  
  func changeCards() {
    cardsInPlay = []
    
    var cards = getNextCards()
    
    for c in cards {
      cardsInPlay.append(c)
    }
  }
  
  func getNextCards() -> [TrumpCard] {
    var rIdx = min(7, (cardPairs.count - 1))

    if (rIdx > -1) {
      var cards: [TrumpCard] = []
      
      for i in 0...rIdx {
        var p: [TrumpCard] = cardPairs[0]
        
        cards.append(p[0])
        cards.append(p[1])
        
        cardPairs.removeAtIndex(0)
      }
      
      TrumpCardCollectionDataSource.shuffleCards(&cards)
      
      return cards
    } else {
      return []
    }
  }
  
  func shufflePairs() {
    let rIdx = cardPairs.count - 1
    
    for i in 0...rIdx {
      var j = Int(arc4random_uniform(UInt32(rIdx)))
      var temp: [TrumpCard] = cardPairs[i]
      
      cardPairs[i] = cardPairs[j] as [TrumpCard]
      cardPairs[j] = temp
    }
  }
  
  class func shuffleCards(inout cards: [TrumpCard]) {
    let rIdx = cards.count - 1
    
    for i in 0...rIdx {
      var j = Int(arc4random_uniform(UInt32(rIdx)))
      var temp = cards[i]
      
      cards[i] = cards[j]
      cards[j] = temp
    }    
  }
  
  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return cardsInPlay.count
  }
  
  func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
      
      switch (kind) {
        case UICollectionElementKindSectionHeader:
          headerView = (collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                       withReuseIdentifier: TrumpCardCollectionDataSource.headerReuseId(),
                                       forIndexPath: indexPath) as? UICollectionReusableView)!
          return headerView!
        case UICollectionElementKindSectionFooter:
          footerView = (collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                       withReuseIdentifier: TrumpCardCollectionDataSource.footerReuseId(),
                                       forIndexPath: indexPath) as? UICollectionReusableView)!
          return footerView!
        default:
          return UICollectionReusableView()
      }
  }
  
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      var cell = (collectionView.dequeueReusableCellWithReuseIdentifier("card_cell", forIndexPath: indexPath) as? UICollectionViewCell)!
      
      if (cardsInPlay[indexPath.item] != nil) {
        cell.backgroundView = UIImageView(image: cardBackImage)
        cell.selectedBackgroundView = labelFor(cardsInPlay[indexPath.item]!, withFrame: cell.frame)
      } else {
        cell.backgroundView = nil
        cell.selectedBackgroundView = nil
      }
      
      cell.selected = false
      
      return cell
  }
  
  
  func labelFor(card: TrumpCard, withFrame: CGRect) -> UILabel {
    var label = UILabel(frame: withFrame)

    label.text = card.label()
    label.textColor = card.color()
    label.textAlignment = NSTextAlignment.Center
    label.backgroundColor = UIColor.whiteColor()
    
    return label
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
  
  func statusLabel() -> UILabel {
    return footerView!.subviews[0] as UILabel
  }
  
  func hasSelectableCards() -> Bool {
    for card in cardsInPlay {
      if card != nil {
        return true
      }
    }
    
    return false
  }
  
  class func headerReuseId() -> String {
    return "game_header"
  }
  
  class func footerReuseId() -> String {
    return "game_footer"
  }
  
}




















































































