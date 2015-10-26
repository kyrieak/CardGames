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
    
    if (deviceIsMobile) {
      w = minScreenDim * 0.193
      h = minScreenDim * 0.254
    } else {
      w = minScreenDim * 0.156
      h = minScreenDim * 0.208
    }
    
    self.itemSize = CGSize(width: w, height: h)
  }
  
  
  private func setSectionInset() {
    if (deviceIsMobile) {
      if (minScreenDim < 400) {
        self.sectionInset = UIEdgeInsets(tb: 8, lr: 8)
      } else {
        self.sectionInset = UIEdgeInsets(tb: 10, lr: 8)
      }
    } else {
      self.sectionInset = UIEdgeInsets(tb: 20, lr: 50)
    }
  }
  
  private func setMinItemSpacing() {
    if (deviceIsMobile) {
      self.minimumInteritemSpacing = ((minScreenDim < 400) ? 8 : 12)
    } else {
      self.minimumInteritemSpacing = CGFloat(30)
    }
  }
  
  private func setMinLineSpacing() {
    if (deviceIsMobile) {
      self.minimumLineSpacing = ((minScreenDim < 400) ? 8 : 12)
    } else {
      self.minimumLineSpacing = CGFloat(50)
    }
  }
  
  private func setSectionFooterHeight() {
    if (deviceIsMobile) {
      self.footerReferenceSize.height = ((minScreenDim > 400) ? 50 : 40)
    } else {
      self.footerReferenceSize.height = 70
    }
  }
}