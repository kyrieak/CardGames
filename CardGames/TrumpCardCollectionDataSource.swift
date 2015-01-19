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
  var cardsInPlay: [TrumpCard]
  let cardBackImage = UIImage(named: "card_back")
  let stdCardSet = TrumpCard.standardSet()
  var cardPairs: NSMutableArray = []
  
  override init() {
    cardsInPlay = []
    
    for (key, cardSet) in stdCardSet {
      var cards = cardSet.allObjects as [TrumpCard]
      TrumpCardCollectionDataSource.shuffleCards(&cards)
      
      cardSet.removeAllObjects()
      
      cardPairs.addObject([cards[0], cards[1]])
      cardPairs.addObject([cards[2], cards[3]])
    }
    
    super.init()
    
    shufflePairs()
    changeCards()
  }
  
//  init(cards: [TrumpCard]) {
//    cardsInPlay = cards
//  }
  
  func changeCards() {
    cardsInPlay = []
    var rIdx = min(7, (cardPairs.count - 1))
    
    for i in 0...rIdx {
      var p = cardPairs[i] as [TrumpCard]
      cardsInPlay.append(p[0])
      cardsInPlay.append(p[1])
      cardPairs.removeObjectAtIndex(0)
    }
    
    TrumpCardCollectionDataSource.shuffleCards(&cardsInPlay)
    
    NSLog("here shuff cards")
  }
  
  func shufflePairs() {
    let rIdx = cardPairs.count - 1
    
    for i in 0...rIdx {
      var j = Int(arc4random_uniform(UInt32(rIdx)))
      var temp = cardPairs[i] as [TrumpCard]
      
      cardPairs[i] = cardPairs[j] as [TrumpCard]
      cardPairs[j] = temp
    }
    NSLog("here shuffpair")
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
      var suppView: UICollectionReusableView
      
      suppView = (collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "game_header", forIndexPath: indexPath) as? UICollectionReusableView)!
      
      return suppView
  }
  
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      var cell: UICollectionViewCell
      var label: UILabel
      var card = cardsInPlay[indexPath.item]
      
      cell = (collectionView.dequeueReusableCellWithReuseIdentifier("card_cell", forIndexPath: indexPath) as? UICollectionViewCell)!
      
      if var button = cell.contentView.subviews[0] as? UIButton {
        button.setBackgroundImage(nil, forState: UIControlState.Normal)
      }
      
      label = UILabel(frame: cell.frame)
      label.text = card.label()
      label.textColor = card.suit.color
      label.textAlignment = NSTextAlignment.Center
      label.backgroundColor = UIColor.whiteColor()
      
      cell.backgroundView = UIImageView(image: cardBackImage)
      cell.selectedBackgroundView = label
      cell.selected = false
      
      return cell
  }
}