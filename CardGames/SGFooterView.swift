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
  let pBtnSize = CGSize(width: 44, height: 44)
  var btnTarget: SetGameController?
  var btnAction = Selector("makeMoveAction:")

  var playerBtns: [UIButton] {
    return self.subviews as! [UIButton]
  }
  
  var playerBtnLabels: [UILabel] {
    return playerBtns.map{(btn: UIButton) -> UILabel in
                            return btn.titleLabel! }
  }
  
  
  func addPlayerButtons(players: [Player], target: SetGameController?, action: Selector) {
    btnTarget = target
    btnAction = action
    
    for p in players {
      let btn = makePlayerBtn(CGPointZero)
      
      btn.setTitle(labelFor(p), forState: UIControlState.Normal)
      btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
      
      btn.tag = p.hashValue
//      btn.backgroundColor = UIColor.blueColor()
      
      addSubview(btn)
    }

    layoutIfNeeded()
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
        NSLog("am here")
        
        btn.titleLabel!.text = player.label
        //        btn.setTitle(labelFor(player), forState: UIControlState.Normal)

        btn.tag = player.hashValue
        idx++
      }
      
      layoutIfNeeded()
    }
  }
  
  private func getPlayerBtnSpacing(numPlayers: Int) -> CGFloat {
    let space = frame.width - (pBtnSize.width * CGFloat(numPlayers))

    return space / CGFloat(numPlayers + 1)
  }
  
  private func getVerticalBtnSpacing(numBtns: Int) -> CGFloat {
    let space = frame.height - (pBtnSize.height * CGFloat(numBtns))
    
    return space / CGFloat(numBtns + 1)
  }
  
  private func makePlayerBtn(atOrigin: CGPoint) -> UIButton {
    return UIButton(frame: CGRect(origin: atOrigin, size: pBtnSize))
  }
  
  override func layoutSubviews() {
    if (frame.width < frame.height) {
      layoutVertically()
    } else {
      layoutHorizontally()
    }
  }
  
  private func layoutHorizontally() {
    let spacing = getPlayerBtnSpacing(subviews.count)
    var origin = CGPoint(x: spacing, y: 0)

    for btn in subviews {
      btn.frame.origin = origin
      origin.x = btn.frame.maxX + spacing
    }
  }
  
  private func layoutVertically() {
    let spacing = getVerticalBtnSpacing(subviews.count)
    var origin = CGPoint(x: 0, y: spacing)

    for btn in subviews {
      btn.frame.origin = origin
      origin.y = btn.frame.maxY + spacing
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