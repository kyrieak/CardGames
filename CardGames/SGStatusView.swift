import Foundation
import UIKit

class SGStatusView: UIView {
  var cardListView = CardListView(frame: CGRectZero)
  var messageView  = UILabel(frame: CGRectZero)

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.setupSubviews()
  }
  
  func setupSubviews() {
    messageView.isAccessibilityElement = true

    if (minScreenDim < 400) {
      frame.size.height = 40
    }

    adjustHeight(frame.height)
    
    addSubview(cardListView)
    addSubview(messageView)
  }
  
  
  func adjustHeight(height: CGFloat) {
    frame.size.height = height

    cardListView.adjustHeight(frame.height)
    messageView.frame.size.height = self.frame.height
  }
  
  
  func addCardToListView(attrs: SetCardAttrs) {
    cardListView.addCardToList(attrs)
  }
  
  
  func updateStatus(move: SGMove, isASet: Bool) {
    updateMessageText(move, isASet: isASet)
    adjustMessageFrame()
  }
  
  
  func updateMessageText(move: SGMove, isASet: Bool) {
    let cardsListText = cardsToString(move.cards)
    
    if (move.done) {
      if (isASet) {
        messageView.text = "is a set for \(gameSettings.pointsFor.set)."
      } else {
        let penalty = abs(gameSettings.pointsFor.penalty)
        
        if (penalty > 0) {
          messageView.text = "is not a set. \(penalty) point penalty."
        } else {
          messageView.text = "is not a set."
        }
      }
      
      messageView.accessibilityLabel = "\(cardsListText) \(messageView.text)"
    }
  }
  
  
  func adjustMessageFrame() {
    messageView.frame.origin.x = cardListView.cornerRight.x
    messageView.sizeToFit()
    messageView.setNeedsDisplay()
  }
  
  
  func cardsToString(cards: [SetCard]) -> String {
    let opts = gameSettings.options
    
    return cards.map{ (c: SetCard) -> String in
      return c.attributes().toString(opts)
    }.joinWithSeparator(", ")
  }
  
  
  func clear() {
    cardListView.clear()
    
    messageView.text = nil
    messageView.accessibilityLabel = nil
    messageView.frame.origin = CGPointZero
  }
}



class CardListView: UIView {
  private var cardSize = CGSizeZero
  private var numCards = 0
  
  var cornerRight: CGPoint {
    return CGPoint(x: bounds.maxX, y: bounds.minY)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupAccessibility()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupAccessibility()
  }
  
  func setupAccessibility() {
    self.isAccessibilityElement = true
    self.accessibilityLabel = "No cards selected"
  }
  
  
  func adjustHeight(height: CGFloat) {
    if (numCards == 0) {
      frame.size.height = height
      
      cardSize = CGSize(width: (frame.height * 0.72), height: frame.height)
    }
  }
  
  
  func addCardToList(attrs: SetCardAttrs) {
    addSubview(makeCardView(attrs))
    
    numCards++
    
    updateLabel(attrs)
    adjustFrame()
  }
  
  
  func makeCardView(attrs: SetCardAttrs) -> SetCardView {
    let cardFrame = CGRect(origin: cornerRight, size: cardSize)
    let cardView  = SetCardView(frame: cardFrame, attrs: attrs)
    
    cardView.isAccessibilityElement = false
    
    return cardView
  }
  
  func addCardView(attrs: SetCardAttrs) {
    let cardFrame = CGRect(origin: cornerRight, size: cardSize)
    let cardView  = SetCardView(frame: cardFrame, attrs: attrs)

    cardView.isAccessibilityElement = false
    addSubview(cardView)

    numCards += 1
    
    adjustFrame()
    updateLabel(attrs)
  }
  
  
  private func adjustFrame() {
    frame.size.width = (cardSize.width * 1.1 * CGFloat(numCards))
  }

  
  private func updateLabel(attr: SetCardAttrs) {
    if (numCards == 1) {
      self.accessibilityLabel = "Selected Cards: \(attr.toString(gameSettings.options))"
    } else if (numCards > 1) {
      self.accessibilityLabel! += ", \(attr.toString(gameSettings.options))"
    } else {
      self.accessibilityLabel = "\(attr.toString(gameSettings.options))"
    }
  }
  
  
  func isEmpty() -> Bool {
    return numCards == 0
  }
  
  
  func clear() {
    numCards = 0
    
    for sv in subviews {
      sv.removeFromSuperview()
    }
    
    frame.size.width = 0
    
    self.accessibilityLabel = "No cards selected"
  }
}