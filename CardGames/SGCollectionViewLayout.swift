//
//  SGCollectionViewLayout.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/6/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class SGCollectionViewLayout: UICollectionViewFlowLayout {
  var cellSize: CGSize = CGSizeZero
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
//  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//    var attrs = super.layoutAttributesForItemAtIndexPath(indexPath)
//    
//    if (attrs != nil) {
//      attrs.frame.size =
//    }
//  }
//  
//  func collectionViewContentSize() -> CGSize {
//    <#code#>
//  }
}