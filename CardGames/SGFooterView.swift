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

  var playerBtns: [UIButton] {
    return self.subviews as! [UIButton]
  }
  
  var playerBtnLabels: [UILabel] {
    return playerBtns.map{(btn: UIButton) -> UILabel in
                            return btn.titleLabel! }
  }
  
  
  private func setBtnSize(numPlayers: Int) {
    if (self.frame.width > self.frame.height) {
      setBtnSizeForHorizontalLayout(numPlayers)
    } else {
      setBtnSizeForVerticalLayout(numPlayers)
    }
  }
  
  private func setBtnSizeForHorizontalLayout(numPlayers: Int) {
    if (numPlayers > 1) {
      pBtnSize.width = (self.frame.width / CGFloat(numPlayers))
    } else {
      pBtnSize.width = 160
    }
    
    pBtnSize.height = 44
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
      
      btn.setTitle(labelFor(p), forState: UIControlState.Normal)
      btn.addTarget(self, action: Selector("addActiveBorder:"), forControlEvents: UIControlEvents.TouchDown)
      btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
      
      btn.tag = p.hashValue
      
      addSubview(btn)
    }

    layoutIfNeeded()
  }
  
  func addActiveBorder(sender: UIButton) {
    sender.layer.borderWidth = CGFloat(2)
    sender.layer.borderColor = UIColor.blueColor().CGColor
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
        
        btn.titleLabel!.text = player.label
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
    var origin = CGPointZero
    
    if (subviews.count == 1) {
      let btn = subviews.first!
      
      btn.frame.size = pBtnSize
      btn.frame.origin.x = self.bounds.midX - btn.bounds.midX
    } else {
      for btn in subviews {
        btn.frame.origin = origin
        btn.frame.size = pBtnSize
        origin.x = btn.frame.maxX
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
  
  private func labelFor(player: Player) -> String {
    let name = player.name
    
    if (name.characters.count < 3) {
      return name
    } else {
      return name.substringToIndex(name.startIndex.successor().successor())
    }
  }
}