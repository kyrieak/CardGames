//
//  MatchingGameController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 1/11/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class MatchingGameController: UICollectionViewController, UICollectionViewDelegate {
//  let stdCardSet = TrumpCard.standardSet()
//  var dataSource: TrumpCardCollectionDataSource?
//  var cardPairs: NSMutableArray = []
  
//  override init() {
//    for (key, cardSet) in stdCardSet {
//      var cards = cardSet.allObjects as [TrumpCard]
//
//      for i in 0...3 {
//        var j = Int(arc4random_uniform(UInt32(3)))
//        var temp = cards[i]
//        
//        cards[i] = cards[j]
//        cards[j] = temp
//      }
//
//      cardSet.removeAllObjects()
//
//      cardPairs.addObject([cards[0], cards[1]])
//      cardPairs.addObject([cards[2], cards[3]])
//    }
//    
//    for i in 0...25 {
//      var j = Int(arc4random_uniform(UInt32(25)))
//      var temp = cardPairs[i] as [TrumpCard]
//      
//      cardPairs[i] = cardPairs[j] as [TrumpCard]
//      cardPairs[j] = temp
//    }
//    
//    super.init()
//  }

//  required init(coder aDecoder: NSCoder) {
//    for (key, cardSet) in stdCardSet {
//      var cards = cardSet.allObjects as [TrumpCard]
//      
//      for i in 0...3 {
//        var j = Int(arc4random_uniform(UInt32(3)))
//        var temp = cards[i]
//        
//        cards[i] = cards[j]
//        cards[j] = temp
//      }
//      
//      cardSet.removeAllObjects()
//
//      cardPairs.addObject([cards[0], cards[1]])
//      cardPairs.addObject([cards[2], cards[3]])
//    }
//    
//    for i in 0...25 {
//      var j = Int(arc4random_uniform(UInt32(25)))
//      var temp = cardPairs[i] as [TrumpCard]
//      
//      cardPairs[i] = cardPairs[j]
//      cardPairs[j] = temp
//    }
//    
//    super.init(coder: aDecoder)
//  }
  
//  override func viewDidLoad() {
//    dataSource = self.collectionView!.dataSource as? TrumpCardCollectionDataSource
//    var cardsInPlay: [TrumpCard] = []
//    
//    for pair in cardPairs {
//      cardsInPlay.append(pair[0] as TrumpCard)
//      cardsInPlay.append(pair[1] as TrumpCard)
//    }
//    
//    dataSource!.changeCards(cardsInPlay)
//  }
//  
  
  @IBAction func selectCard(sender: UIButton) {
    if var s = sender.superview!.superview as? UICollectionViewCell {
      s.selected = !s.selected
    }
  }
}