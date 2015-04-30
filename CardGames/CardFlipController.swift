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
  @IBOutlet var cardView: TrumpCardView!
  @IBOutlet var discardsLabel: UILabel!

  let style = Style()

//  var dataSource = TrumpDeckDataSource()
  
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
      // cardView set needs display
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
    
    self.view.layer.insertSublayer(makeHeaderLayer(), atIndex: 0)
    style.applyShade(discardsLabel.layer)
  }


  func updateDiscardLabel<T: Card>(discard: Deck<T>) {
    discardsLabel.drawTextInRect(UIEdgeInsetsInsetRect(discardsLabel.frame, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    discardsLabel.text = "Discards: \(discard.cards.count)"
  }
  
  
  private func makeHeaderLayer() -> CALayer {
    var headerLayer = CALayer()
    
    headerLayer.bounds = CGRect(origin: self.view.bounds.origin, size: CGSize(width: self.view.bounds.width, height: 130))
    headerLayer.frame.origin = self.view.frame.origin
    headerLayer.backgroundColor = style.medGreenColor
    style.applyShade(headerLayer)
    
    return headerLayer
  }
  
  
  private func makeFooterLayer() -> CALayer {
    var footerLayer = CALayer()
    var footerOrigin = CGPoint(x: 0, y:self.view.frame.height - 100)
    
    footerLayer.bounds = CGRect(origin: footerOrigin, size: CGSize(width: self.view.bounds.width, height: 50))
    footerLayer.frame.origin = footerOrigin
    footerLayer.backgroundColor = style.medBrownColor
    style.applyShade(footerLayer)
    
    return footerLayer
  }
}

