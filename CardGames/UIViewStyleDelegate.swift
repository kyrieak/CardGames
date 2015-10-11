//
//  UIThemedView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/10/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewStyleDelegate {
  var style: SG { get set }

//  func layerStyleIdx() -> [Int: UILayerStyle]
//  func fontStyleIdx() -> [Int: UIFontStyle]
//  
  func viewsForLayerStyle(id: Int) -> [UIView]
  func viewsForFontStyle(id: Int) -> [UIView]
  
  func applyStyleToViews()
}