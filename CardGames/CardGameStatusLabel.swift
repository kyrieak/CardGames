import Foundation
import UIKit

class CardGameStatusView: UIView {
  private var cardListView: CardListView
  private var messageView = UILabel()
  
  override init() {
    cardListView = CardListView()
    
    super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    cardListView = CardListView()
    
    super.init(coder: aDecoder)
  }
  
  func addCardViewToList(view: UIView) {
    cardListView.addCardView(view)
    messageView.frame.origin = cardListView.nextCardPosition
  }
  
  func setMessage(text: String) {
    messageView.text = text
    
    frame.size.width = cardListView.frame.width + messageView.frame.width
  }
  
  func clear() {
    cardListView.clear()
    messageView.text = nil
    messageView.frame.origin = CGPointZero
  }
  
  func nextCardPosition() -> CGPoint {
    return cardListView.nextCardPosition
  }
  
  func cardSize() -> CGSize {
    return cardListView.cardSize
  }
}

class SetGameStatusView: CardGameStatusView {
  func addCardToListView(attrs: SetCardAttributes) {
    var cardFrame = CGRect(origin: nextCardPosition(), size: cardSize())
    var cardView = SetCardView(frame: cardFrame, attrs: attrs)
    
    addCardViewToList(cardView)
  }
}

class MemoryGameStatusView: CardGameStatusView {
  func addCardToListView(attrs: TrumpCardAttributes) {
    var cardFrame = CGRect(origin: nextCardPosition(), size: cardSize())
    var cardView = TrumpCardView(attrs: attrs)
    
    addCardViewToList(cardView)
  }
}

class CardListView: UIView {
  private var cardSize = CGSizeZero
  private var numCards = 0

  private var nextCardPosition: CGPoint {
    var xPos = frame.origin.x + frame.width
    
    return CGPoint(x: xPos, y: frame.origin.y)
  }

  override init() {
    super.init()
    
    frame.size.width = 0
    cardSize = CGSize(width: (frame.height / 2), height: frame.height)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    cardSize = CGSize(width: (frame.height / 2), height: frame.height)
  }
  
  func addCardView(view: UIView) {
    view.frame = CGRect(origin: nextCardPosition, size: cardSize)
    
    addSubview(view)
    
    numCards += 1
    frame.size.width = nextCardPosition.x // will trigger auto redraw
  }
  
  func isEmpty() -> Bool {
    return numCards == 0
  }
  
  func clear() {
    numCards = 0
    
    for sv in subviews {
      sv.removeFromSuperview!()
    }
    
    frame.size.width = 0
  }
}