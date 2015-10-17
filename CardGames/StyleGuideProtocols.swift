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
       Status,
       CardBack,
       CardFront,
       HeadTitle,
       FooterUIBtn,
       UIBtn
}

// - MARK: - StyleGuide Protocol

protocol StyleGuide {
  var themeID: Int { get }
  var theme: Theme { get }
  
  init(theme: Theme)

  func setTheme(theme: Theme)

  func hasLayerStyle(sel: ViewSelector) -> Bool
  func hasFontStyle(sel: ViewSelector) -> Bool
  
  func layerStyle(sel: ViewSelector) -> UILayerStyle?
  func fontStyle(sel: ViewSelector) -> UIFontStyle?
  
  func applyLayerStyle(sel: ViewSelector, views: [UIView])
  func applyFontStyle(sel: ViewSelector, views: [UILabel])
}


// - MARK: - StyleGuideDelegate Protocol

protocol StyleGuideDelegate {
  var style: StyleGuide { get }
  var themeID: Int { get }
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView]
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel]
  
  func applyStyleToViews()
}

