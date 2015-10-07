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
  
  func addPlayerButtons(players: [Player], target: SetGameController, action: Selector) {
    var ct: Int = 1
    
    for p in players {
      let pButton = makePlayerBtn(CGPointZero)
      
      pButton.setTitle("p \(ct)", forState: UIControlState.Normal)
      pButton.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
      
      pButton.tag = p.hashValue
      pButton.backgroundColor = UIColor.blueColor()
      
      addSubview(pButton)
      ct += 1
    }

    layoutIfNeeded()
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
}

/*
private func addPlayerButtons(collectionView: UICollectionView, footer: UIView) {
let _datasource = collectionView.dataSource! as? SetGameDataSource
let game = _datasource!.game

var playerWrapView = footer.viewWithTag(8)!
NSLog("pwview size: \(playerWrapView.frame.size)")

let pCount = game.players.count
let h = playerWrapView.frame.height
var spacing = (collectionView.frame.width - (h * CGFloat(pCount))) / CGFloat(pCount + 1)
var _origin = CGPoint(x: spacing, y: 0)
let buttonSize = CGSize(width: h, height: h)

for player in game.players {
var pButton = UIButton(frame: CGRect(origin: _origin, size: buttonSize))
pButton.backgroundColor = UIColor.blueColor()
playerWrapView.addSubview(pButton)

NSLog("\(buttonSize)")
_origin.x = pButton.frame.maxX + spacing
}

}

*/