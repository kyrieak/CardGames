//
//  SGFooterView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 9/20/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SGFooterView: UIView {
  var pBtnSize = CGSize(width: 88, height: 44)
  var btnTarget: SetGameController?
  var btnAction = Selector("makeMoveAction:")
  var frameInset: CGFloat = 0

  var playerBtns: [UIButton] {
    return self.subviews as! [UIButton]
  }
  
  var playerBtnLabels: [UILabel] {
    return playerBtns.map{(btn: UIButton) -> UILabel in
                            return btn.titleLabel! }
  }
  
  
  private func setBtnSize(numPlayers: Int) {
    if (self.frame.width > self.frame.height) {
      frameInset = frame.height * 0.1
      
      setBtnSizeForHorizontalLayout(numPlayers)
    } else {
      frameInset = frame.width * 0.1

      setBtnSizeForVerticalLayout(numPlayers)
    }
  }
  
  private func setBtnSizeForHorizontalLayout(numPlayers: Int) {
    pBtnSize.height = (frame.height * 0.8)
    
    if (numPlayers > 1) {
      let combinedWidth = self.frame.width - (CGFloat(numPlayers + 1) * frameInset)

      pBtnSize.width = (combinedWidth / CGFloat(numPlayers))
    } else {
      pBtnSize.width = 160
    }
    
    pBtnSize.height = 44

    if (frame.height > 55) {
      pBtnSize.height = (frame.height * 0.8)
    }
  }
  
  private func setBtnSizeForVerticalLayout(numPlayers: Int) {
    pBtnSize.width = self.frame.width
    
    if (numPlayers > 1) {
      pBtnSize.height = (self.frame.height / CGFloat(numPlayers))
    } else {
      pBtnSize.height = 88
    }
  }
  
  
  func addPlayerButtons(players: [Player], target: SetGameController?, action: Selector) {
    setBtnSize(players.count)
    btnTarget = target
    btnAction = action
    
    for p in players {
      let btn = makePlayerBtn(CGPointZero)

      btn.setTitle(p.label, forState: UIControlState.Normal)
      btn.addTarget(self, action: Selector("addActiveBorder:"), forControlEvents: UIControlEvents.TouchDown)
      btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
      
      btn.tag = p.hashValue
      
      addSubview(btn)
    }

    layoutIfNeeded()
  }
  
  func addActiveBorder(sender: UIButton) {
    sender.layer.borderWidth = CGFloat(2)
    sender.layer.borderColor = appGlobals.styleGuide.theme.bgColor2.getShade(-0.2).CGColor
//    sender.layer.borderColor = UIColor.blueColor().CGColor
  }
  
  func layoutPlayerBtns(players: [Player]) {
    if (players.count != subviews.count) {
      for btn in playerBtns {
        btn.removeFromSuperview()
      }
      
      addPlayerButtons(players, target: btnTarget, action: btnAction)
    } else {
      var idx = 0

      for btn in playerBtns {
        let player = players[idx]
        btn.setTitle(player.label, forState: .Normal)
        btn.tag = player.hashValue
        btn.sizeToFit()
        
        idx++
      }
      
      layoutIfNeeded()
    }
  }
  
  
  private func makePlayerBtn(atOrigin: CGPoint) -> UIButton {
    return UIButton(frame: CGRect(origin: atOrigin, size: pBtnSize))
  }
  
  override func layoutSubviews() {
    if (playerBtns.count > 0) {
      if (frame.width < frame.height) {
        setBtnSizeForVerticalLayout(playerBtns.count)
        layoutVertically()
      } else {
        setBtnSizeForHorizontalLayout(playerBtns.count)
        layoutHorizontally()
      }
    }
  }
  
  private func layoutHorizontally() {
    var origin = CGPoint(x: frameInset, y: frameInset)
    
    if (subviews.count == 1) {
      let btn = subviews.first!
      
      btn.frame.size = pBtnSize
      btn.frame.origin.y = origin.y
      btn.frame.origin.x = self.bounds.midX - btn.bounds.midX
    } else {
      let spacing = frameInset

      for btn in subviews {
        btn.frame.origin = origin
        btn.frame.size = pBtnSize
        origin.x = btn.frame.maxX + spacing
      }
    }
  }
  
  private func layoutVertically() {
    var origin = CGPointZero

    if (subviews.count == 1) {
      let btn = subviews.first!
      
      btn.frame.size = pBtnSize
      btn.frame.origin.y = self.bounds.midY - btn.bounds.midY
    } else {
      for btn in subviews {
        btn.frame.origin = origin
        btn.frame.size = pBtnSize
        origin.y = btn.frame.maxY
      }
    }
  }
}