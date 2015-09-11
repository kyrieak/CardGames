//
//  SGHeaderView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 9/8/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SGHeaderView: UIView {
  let deckTag: Int  = 1
  let titleTag: Int = 2
  
  let style = Style()
  
  private var cardSize: CGSize
  private var insetX, insetY: CGFloat
  
  var deckButton: UIButton {
    return self.viewWithTag(deckTag)! as! UIButton
  }
  
  var titleLabel: UILabel {
    return self.viewWithTag(titleTag)! as! UILabel
  }
  
  
  init(frame: CGRect, _insetX: CGFloat, _insetY: CGFloat, _cardSize: CGSize) {
    cardSize = _cardSize
    (insetX, insetY) = (_insetX, _insetY)
    
    super.init(frame: frame)
    
    backgroundColor = style.medGreenColor
    
    addDeckButton("Redraw")
    addTitleLabel("Take Three")
  }
  
  convenience init(frame: CGRect, layout: UICollectionViewFlowLayout) {
    let inset = layout.sectionInset

    self.init(frame: frame, _insetX: inset.left,
                            _insetY: inset.top,
                            _cardSize: layout.itemSize)
  }

  required init(coder aDecoder: NSCoder) {
    cardSize = CGSizeZero
    (insetX, insetY) = (0, 0)
    
    super.init(coder: aDecoder)

    let h = frame.height * 0.8
    let w = h * 0.5

    insetY = h * 0.05
    insetX = insetY
    
    cardSize = CGSize(width: w, height: h)
  }
  
  private func addTitleLabel(_title: String) {
    var title = UILabel(frame: self.frame)
    
    title.text = _title
  }
  
  private func addDeckButton(_title: String) {
    var button = UIButton(frame: getDeckFrame())

    button.tag = deckTag
    button.backgroundColor = style.cardBgPattern
    button.setTitle(_title, forState: UIControlState.Normal)

    style.applyShade(button.layer)
    
    addSubview(button)
  }
  
  private func getDeckFrame() -> CGRect {
    let contentFrame = getContentFrame()
    let yOffset = contentFrame.maxY - self.cardSize.height
    let _origin = CGPoint(x: self.insetX, y: yOffset)
    
    return CGRect(origin: _origin, size: self.cardSize)
  }
  
  private func getTitleFrame() -> CGRect {
    let contentFrame = getContentFrame()

    return contentFrame
  }
  
  private func getContentFrame() -> CGRect {
    return CGRectInset(self.frame, self.insetX, self.insetY)
  }
}