import Foundation
import UIKit

class CardGameStatusView: UIView {
  private var cardListView: CardListView?
  private var messageView: UILabel

  
  override init(frame: CGRect) {
    var initialSize = CGSize(width: frame.width, height: 50)
    messageView = UILabel(frame: CGRect(origin: frame.origin, size: initialSize))
    cardListView = CardListView(frame: CGRect(origin: frame.origin,
      size: initialSize))

    
    super.init(frame: frame)
    
    addSubview(messageView)
    addSubview(cardListView!)
  }
  
  required init(coder aDecoder: NSCoder) {
    messageView = UILabel()

    super.init(coder: aDecoder)
    
    var initialSize = CGSize(width: frame.width, height: 50)

    messageView = UILabel(frame: CGRect(origin: frame.origin, size: initialSize))
    cardListView = CardListView(frame: CGRect(origin: frame.origin,
      size: initialSize))
    
    addSubview(messageView)
    addSubview(cardListView!)
  }
  
  func addCardViewToList(view: UIView) {
    cardListView!.addCardView(view)
    messageView.frame.origin = cardListView!.getCornerRight()
  }
  
  func setMessage(text: String) {
    messageView.text = text
    messageView.frame.origin.x = leftOffsetForMessage()
    NSLog("\(messageView.text)")
    NSLog("\(messageView.frame)")
    messageView.setNeedsDisplay()
  }
  
  func setMessage(cardListAsText: String, statusText: String) {
    setMessage(cardListAsText + " " + statusText)
  }
  
  func leftOffsetForMessage() -> CGFloat {
    if (cardListView != nil) {
      return cardListView!.getCornerRight().x
    } else {
      return 0
    }
  }
  
  func clear() {
    if (cardListView != nil) {
      cardListView!.clear()
    }
    
    messageView.text = nil
    messageView.frame.origin = CGPointZero
  }
}

class SetGameStatusView: CardGameStatusView {

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
//    cardListView = CardListView(frame: frame)
//    addSubview(cardListView!)
  }
  
  override func setMessage(cardListAsText: String, statusText: String) {
    setMessage(statusText)
  }
  
  func addCardToListView(attrs: SetCardAttributes) {
    var cardFrame = CGRect(origin: cardListView!.getCornerRight(),
                           size: cardListView!.cardSize)
    var cardView = SetCardView(frame: cardFrame, attrs: attrs)
    
    addCardViewToList(cardView)
  }
}

class MemoryGameStatusView: CardGameStatusView {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NSLog("init \(frame)")
    cardListView!.frame.size.height = 50
//    cardListView = CardListView(frame: CGRect(origin: frame.origin,
//      size: CGSize(width: 0, height: 50)))

//    addSubview(cardListView!)
  }
  
  func addCardToListView(attrs: TrumpCardAttributes) {
    var cardFrame = CGRect(origin: cardListView!.getCornerRight(),
      size: cardListView!.cardSize)
    var cardView = TrumpCardView(frame: cardFrame, attrs: attrs)
    cardView.flipCard()
    cardView.backgroundColor = UIColor.whiteColor()
    
    addCardViewToList(cardView)
  }
  
  override func setMessage(cardListAsText: String, statusText: String) {
    setMessage(statusText)
  }
}

class CardListView: UIView {
  private var cardSize = CGSizeZero
  private var numCards = 0

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    NSLog("\(frame)")
    
    cardSize = CGSize(width: (frame.height * 0.72), height: frame.height)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    cardSize = CGSize(width: (frame.height * 0.72), height: frame.height)
  }
  
  func getContentWidth() -> CGFloat {
    return (cardSize.width * 1.1 * CGFloat(numCards))
  }
  
  func getCornerRight() -> CGPoint {
    var posX = self.frame.origin.x + getContentWidth()

    return CGPoint(x: posX, y: frame.origin.y)
  }
  
  func addCardView(view: UIView) {
    view.frame = CGRect(origin: CGPoint(x: getContentWidth(), y: 0), size: cardSize)
    NSLog("\(cardSize)")
    numCards += 1
    
    addSubview(view)
    
    frame.size.width = getContentWidth()
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