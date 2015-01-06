//
//  CardViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class CardViewController: UIViewController {
  @IBOutlet var cardLabelTop: UILabel!
  @IBOutlet var cardLabelBottom: UILabel!
  @IBOutlet var cardLabelCenter: UILabel!
  
  let hearts   = Suit(title: "Hearts", symbol: "♥︎", tier: 1, color: UIColor.redColor())
  let diamonds = Suit(title: "Diamonds", symbol: "♦︎", tier: 1, color: UIColor.redColor())
  let spades   = Suit(title: "Spades", symbol: "♠︎", tier: 1, color: UIColor.blackColor())
  let clubs    = Suit(title: "Clubs", symbol: "♣︎", tier: 1, color: UIColor.blackColor())
 
  var drawPile = Deck<TrumpCard>()
  var discardPile = Deck<TrumpCard>()
  var parentVC: UIViewController?
  var topCard: TrumpCard?
  
  override func viewDidLoad() {
    for rankVal in 1...13 {
      drawPile.addCard(TrumpCard(suit: hearts, rank: rankVal))
      drawPile.addCard(TrumpCard(suit: diamonds, rank: rankVal))
      drawPile.addCard(TrumpCard(suit: spades, rank: rankVal))
      drawPile.addCard(TrumpCard(suit: clubs, rank: rankVal))
    }
    
    drawPile.shuffle()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    println("sender")
//    println("\(sender)")
//    println("segue destined")
//    println("\(segue.destinationViewController)")
  }

  func updateCardView(card: TrumpCard?) {
    if (card != nil) {
      var label: String
      
      if (card!.isFaceUp()) {
        label = card!.label()
        var color = card!.suit.color
        
        if (cardLabelTop.textColor != color) {
          cardLabelTop.textColor = color
          cardLabelBottom.textColor = color
          cardLabelCenter.textColor = color
        }
        
        self.view.backgroundColor = UIColor.whiteColor()
      } else {
        label = ""
        self.view.backgroundColor = UIColor.grayColor()
      }
      
      cardLabelTop.text = label
      cardLabelBottom.text = label
      cardLabelCenter.text = label
    } else {
      cardLabelTop.text = ""
      cardLabelBottom.text = ""
      cardLabelCenter.text = "Empty"
    }
  }
  
  
  @IBAction func tapCardAction(sender: UITapGestureRecognizer) {
    if (drawPile.cards.count > 0) {
      if (topCard == nil) {
        topCard = drawPile.removeTopCard()
      } else if (topCard!.isFaceUp()) {
        discardPile.addCard(topCard!)
        
        topCard = drawPile.removeTopCard()
      } else {
        topCard!.flip()
      }
    } else if (topCard != nil) {
      if (topCard!.isFaceUp()) {
        discardPile.addCard(topCard!)
        topCard = nil
      } else {
        topCard!.flip()
      }
    }
    
    updateCardView(topCard)

    if var vc = parentVC as? ViewController {
      vc.updateDiscardLabel(discardPile)
    }
    
    if (topCard == nil) {
      discardPile.shuffle()
      
      var temp = drawPile
      drawPile = discardPile
      discardPile = temp
      
      for card in drawPile.cards {
        card.faceUp = false
      }
    }
  }
}