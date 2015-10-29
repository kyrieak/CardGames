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
  let screenDims = deviceInfo.screenDims

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    adjustForScreenSize()
  }
  
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  
  func adjustForScreenSize() {
    setSectionInset()
    setSectionFooterHeight()

    setItemSize()
    setMinItemSpacing()
    setMinLineSpacing()
  }
  
  
  private func setItemSize() {
    var w, h: CGFloat
    
    if (deviceInfo.isMobile) {
      if (screenDims.max < 500) {
        w = screenDims.min * 0.174
        h = screenDims.min * 0.203
      } else {
        w = screenDims.min * 0.193
        h = screenDims.min * 0.254
      }
    } else {
      w = screenDims.min * 0.15
      h = screenDims.min * 0.2
    }
    
    self.itemSize = CGSize(width: w, height: h)
  }
  
  
  private func setSectionInset() {
    if (deviceInfo.isMobile) {
      if (screenDims.min < 400) {
        self.sectionInset = UIEdgeInsets(tb: 8, lr: 8)
      } else {
        self.sectionInset = UIEdgeInsets(tb: 10, lr: 8)
      }
    } else {
      self.sectionInset = UIEdgeInsets(tb: 15, lr: 50)
    }
  }
  
  private func setMinItemSpacing() {
    if (deviceInfo.isMobile) {
      self.minimumInteritemSpacing = ((screenDims.min < 400) ? 8 : 12)
    } else {
      self.minimumInteritemSpacing = CGFloat(30)
    }
  }
  
  private func setMinLineSpacing() {
    if (deviceInfo.isMobile) {
      if (screenDims.max < 500) {
        self.minimumLineSpacing = 6
      } else {
        self.minimumLineSpacing = ((screenDims.min < 400) ? 8 : 12)
      }
    } else {
      self.minimumLineSpacing = CGFloat(10)
    }
  }
  
  private func setSectionFooterHeight() {
    if (deviceInfo.isMobile) {
      self.footerReferenceSize.height = ((screenDims.min > 400) ? 50 : 40)
    } else {
      self.footerReferenceSize.height = 60
    }
  }
}