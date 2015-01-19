//
//  MatchingGameDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 1/11/15.
//  Copyright (c) 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class MatchingGameDataSource: NSObject, UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      return UICollectionViewCell()
  }
}