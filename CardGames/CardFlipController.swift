//
//  ViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 12/27/14.
//  Copyright (c) 2014 Kyrie. All rights reserved.
//

import UIKit
import QuartzCore

class CardFlipController: UIViewController {
  @IBOutlet var headerView: UILabel!
  @IBOutlet var cardView: TrumpCardView!
  @IBOutlet var discardsLabel: UILabel!

  let style = Style()

  
  private var topCard: TrumpCard? {
    if (drawPile.isEmpty()) {
      return nil
    } else {
      return drawPile.cards[0]
    }
  }
  
  private var drawPile    = TrumpCard.standardDeck()
  private var discardPile = Deck<TrumpCard>()

  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    drawPile.shuffle()
  }
  
  
  @IBAction func tapCardAction(sender: UITapGestureRecognizer) {
    if (topCard != nil) {
      if (topCard!.isFaceUp()) {
        discardTopCard()
      } else {
        flipTopCard()
      }
    }
  }
  
  func flipTopCard() {
    if (topCard != nil) {
      topCard!.flip()
      cardView.flipCard()
    }
  }
  
  func discardTopCard() {
    if (topCard != nil) {
      drawPile.removeTopCard()
      
      if (topCard != nil) {
        cardView.displayCard(topCard!.attributes())
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if (topCard != nil) {
      cardView.displayCard(topCard!.attributes())
    }
    
    style.applyShade(headerView.layer)
    style.applyShade(discardsLabel.layer)
  }


  func updateDiscardLabel<T: Card>(discard: Deck<T>) {
    discardsLabel.drawTextInRect(UIEdgeInsetsInsetRect(discardsLabel.frame, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    discardsLabel.text = "Discards: \(discard.cards.count)"
  }
}

