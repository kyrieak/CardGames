//
//  CardDeckDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 4/28/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation

protocol CardViewDelegate {
  typealias cardType: Card
  
  func flipCard()
  func displayCard(card: cardType)
}

class TrumpCardViewDelegate: NSObject {
  typealias cardType = TrumpCard
    
  func flipCard() {}
  func displayCard(card: TrumpCard) {}
}

protocol CardDeckDataSource {
  typealias cardType: Card
  
  var topCard: cardType? { get }
  var drawPile: Deck<TrumpCard> { get }

  init(deck: Deck<cardType>)
  
  func discardTopCard()
  
  func flipTopCard()
}


class TrumpDeckDataSource: CardDeckDataSource {
  typealias cardType = TrumpCard
  
  var topCard: TrumpCard? {
    if (drawPile.isEmpty()) {
      return nil
    } else {
      return drawPile.cards[0]
    }
  }

  var drawPile: Deck<TrumpCard>
  
  private var discardPile = Deck<TrumpCard>()
  
  init() {
    drawPile = TrumpCard.standardDeck()
  }
  
  required init(deck: Deck<TrumpCard>) {
    drawPile = deck
  }
  
  func discardTopCard() {
    if (topCard != nil) {
      var discard = topCard

      discardPile.addCard(discard!)
      drawPile.removeTopCard()
    }
  }
  
  func flipTopCard() {
    if (topCard != nil) {
      topCard!.flip()
    }
  }
  
  func reset() {
    drawPile = TrumpCard.standardDeck()
    discardPile = Deck<TrumpCard>()
  }
  
  func reset(deck: Deck<TrumpCard>) {
    drawPile = deck
    discardPile = Deck<TrumpCard>()
  }
}