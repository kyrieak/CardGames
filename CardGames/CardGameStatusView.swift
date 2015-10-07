import Foundation
import UIKit

class CardGameStatusView: UIView {
  private var cardListView: CardListView?
  private var messageView: UILabel

  
  override init(frame: CGRect) {
    let initialSize = CGSize(width: frame.width, height: 50)
    messageView = UILabel(frame: CGRect(origin: frame.origin, size: initialSize))
    cardListView = CardListView(frame: CGRect(origin: frame.origin,
      size: initialSize))

    
    super.init(frame: frame)
    
    addSubview(messageView)
    addSubview(cardListView!)
  }
  
  required init?(coder aDecoder: NSCoder) {
    messageView = UILabel()

    super.init(coder: aDecoder)
    
    let initialSize = CGSize(width: frame.width, height: 50)

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
    NSLog("message view frame: \(messageView.frame)")
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

//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    
////    cardListView = CardListView(frame: frame)
////    addSubview(cardListView!)
//  }
  
  override func setMessage(cardListAsText: String, statusText: String) {
    setMessage(statusText)
  }
  
  func addCardToListView(attrs: SetCardAttrs) {
    let cardFrame = CGRect(origin: cardListView!.getCornerRight(),
                           size: cardListView!.cardSize)
    let cardView = SetCardView(frame: cardFrame, attrs: attrs)
    
    addCardViewToList(cardView)
  }
}


class CardListView: UIView {
  private var cardSize = CGSizeZero
  private var numCards = 0

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    NSLog("card list view frame: \(frame)")
    
    cardSize = CGSize(width: (frame.height * 0.72), height: frame.height)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    cardSize = CGSize(width: (frame.height * 0.72), height: frame.height)
  }
  
  func getContentWidth() -> CGFloat {
    return (cardSize.width * 1.1 * CGFloat(numCards))
  }
  
  func getCornerRight() -> CGPoint {
    let posX = self.frame.origin.x + getContentWidth()

    return CGPoint(x: posX, y: frame.origin.y)
  }
  
  func addCardView(view: UIView) {
    view.frame = CGRect(origin: CGPoint(x: getContentWidth(), y: 0), size: cardSize)
    NSLog("cardSize: \(cardSize)")
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
      sv.removeFromSuperview()
    }
    
    frame.size.width = 0
  }
}