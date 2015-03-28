//
//  TrumpCardView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 3/26/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class TrumpCardView: UIView {
  private var rank: Int
  private var suit: Suit
    
  init(attrs: TrumpCardAttributes) {
    rank = attrs.rank
    suit = attrs.suit
    
    super.init()
  }

  required init(coder aDecoder: NSCoder) {
    rank = 1
    suit = TrumpCard.hearts()
    
    super.init(coder: aDecoder)
  }
}