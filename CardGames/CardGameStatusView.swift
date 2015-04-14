import Foundation
import UIKit

class CardGameStatusView: UIView {
  private var cardListView: CardListView?
  private var messageView: UILabel
  
  override init() {
//    cardListView = CardListView()
    messageView = UILabel()
    
    super.init()

//    addSubview(cardListView)
    addSubview(messageView)
  }
  
  override init(frame: CGRect) {
//    cardListView = CardListView(frame: frame)
    messageView = UILabel(frame: frame)
    
    super.init(frame: frame)
    
//    addSubview(cardListView)
    addSubview(messageView)
  }
  
  required init(coder aDecoder: NSCoder) {
//    cardListView = CardListView()
    messageView = UILabel()
    
    super.init(coder: aDecoder)
    
    cardListView = CardListView(frame: frame)
    messageView.frame = frame
    
//    addSubview(cardListView)
    addSubview(messageView)
  }
  
  func addCardViewToList(view: UIView) {
    if (cardListView != nil) {
      cardListView!.addCardView(view)
      messageView.frame.origin = cardListView!.getCornerRight()
    } else {
      // added
      cardListView = CardListView(frame: frame)
      addSubview(cardListView!)
    }
  }
  
  func setMessage(text: String) {
    messageView.text = text
    messageView.frame.origin.x = leftOffsetForMessage()
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
  
  func log() {
    NSLog("CardGameStatusView -----------------")
    NSLog("frame: \(frame)")
    NSLog("bounds: \(bounds)")
    NSLog("------------------------------------")
  }
}

class SetGameStatusView: CardGameStatusView {
  override init() {
    super.init()
    
    cardListView = CardListView(frame: frame)
    addSubview(cardListView!)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    cardListView = CardListView(frame: frame)
    addSubview(cardListView!)
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
  func addCardToListView(attrs: TrumpCardAttributes) {
    var cardFrame = CGRect(origin: cardListView!.getCornerRight(),
      size: cardListView!.cardSize)
    var cardView = TrumpCardView(frame: cardFrame, attrs: attrs)
    
    addCardViewToList(cardView)
  }
  
  override func setMessage(cardListAsText: String, statusText: String) {
    setMessage(statusText)
  }

}

class CardListView: UIView {
  private var cardSize = CGSizeZero
  private var numCards = 0

  override init() {
    super.init()
    cardSize = CGSize(width: (frame.height * 0.72), height: frame.height)
    backgroundColor = UIColor.whiteColor()
    var constraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0)
    constraint.active = true
    addConstraint(constraint)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
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