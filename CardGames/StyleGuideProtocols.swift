//
//  UIThemedView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/10/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

// - MARK: - ViewSelector Enum

enum ViewSelector {
  case MainContent,
       Header,
       Footer,
       NavPill

  case HomeMenu,
       HomeMenuItem
  
  case CardBack,
       CardFront,
       Status
  
  case HeadTitle,
       FooterUIBtn,
       UIBtn
}

// - MARK: - StyleGuide Protocol

protocol StyleGuide {
  var themeID: Int? { get }
  var theme: Theme { get }
  
  init(theme: Theme)

  func setTheme(theme: Theme)

  func hasLayerStyle(sel: ViewSelector) -> Bool
  func hasFontStyle(sel: ViewSelector) -> Bool
  
  func layerStyle(sel: ViewSelector) -> UILayerStyle?
  func fontStyle(sel: ViewSelector) -> UIFontStyle?
  
  func applyLayerStyle(sel: ViewSelector, views: [UIView])
  func applyFontStyle(sel: ViewSelector, views: [UILabel])
  func applyBtnStyle(sel: ViewSelector, views: [UIButton])
}


// - MARK: - StyleGuideDelegate Protocol

protocol StyleGuideDelegate {
  typealias sg: StyleGuide
  
  var styleGuide: sg { get }
  var themeID: Int? { get }
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView]
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel]
  func viewsForBtnStyle(sel: ViewSelector) -> [UIButton]
  
  func applyStyleToViews()
}

extension UIColor {
  func getRGB() -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    var _r = CGFloat(0)
    var _g = _r
    var _b = _r
    
    self.getRed(&_r, green: &_g, blue: &_b, alpha: nil)
    
    return (r: _r, g: _g, b: _b)
  }
  
  func getShade(delta: CGFloat) -> UIColor {
    let values = self.getRGB()
    
    return UIColor(red: values.r + delta,
                     green: values.g + delta,
                       blue: values.b + delta, alpha: 1.0)
  }
}
