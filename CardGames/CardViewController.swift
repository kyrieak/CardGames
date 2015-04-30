////
////  CardViewController.swift
////  CardGames
////
////  Created by Kyrie Kopczynski on 12/27/14.
////  Copyright (c) 2014 Kyrie. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class CardViewController: UIViewController {
//  var dataSource: CardFlipController?
//  
//  let style = Style()
//  
//  override func viewDidLoad() {
//    style.applyCardBg(self.view, withScale: 2.0)
//    style.applyShade(self.view.layer, color: style.darkShadeColor, thickness: 2)
//  }
//
//  func updateCardView(card: TrumpCard?) {
//    if (card != nil) {
//      var label: String
//      
//      if (card!.isFaceUp()) {
//        label = card!.label()
//        var color = Style.getUIColorFor(card!.color())
//        
//        self.view.backgroundColor = UIColor.whiteColor()
//      } else {
//        label = ""
//        style.applyCardBg(self.view, withScale: 2.0)
//      }
//    }
//  }
//  
//  
//  @IBAction func tapCardAction(sender: UITapGestureRecognizer) {
////    if (!parentVC.drawPile.isEmpty()) {
////      if (topCard == nil) {
////        topCard = drawPile.removeTopCard()
////      } else if (topCard!.isFaceUp()) {
////        discardPile.addCard(topCard!)
////        
////        topCard = drawPile.removeTopCard()
////      } else {
////        topCard!.flip()
////      }
////    } else if (topCard != nil) {
////      if (topCard!.isFaceUp()) {
////        discardPile.addCard(topCard!)
////        topCard = nil
////      } else {
////        topCard!.flip()
////      }
////    } else {
////      discardPile.shuffle()
////      
////      var temp = drawPile
////      drawPile = discardPile
////      discardPile = temp
////      
////      for card in drawPile.cards {
////        card.faceUp = false
////      }
////    }
////    
////    updateCardView(topCard)
////
////    if var vc = parentVC as? CardFlipController {
////      vc.updateDiscardLabel(discardPile)
////    }
//  }
//}