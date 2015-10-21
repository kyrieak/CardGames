//
//  SGSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/7/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class ThemeSettingsController: UIViewController, UITableViewDelegate, StyleGuideDelegate {
  @IBOutlet var themeDataSource: ThemeTableDataSource!
  
  var selectIdxPath: NSIndexPath?
  
  var style: StyleGuide {
    return styleGuide
  }

  var themeID = styleGuide.themeID

  @IBOutlet var headerView: UIView!
  @IBOutlet var saveBtn: UIButton!
  @IBOutlet var backBtn: UIButton!
  @IBOutlet var themesTable: UITableView!

  
  override func viewDidLayoutSubviews() {
    let computedHeight = themesTable.rowHeight * CGFloat(themeDataSource.themes.count)
    let maxHeight = saveBtn.frame.minY - themesTable.frame.minY - 60
    themesTable.layer.borderWidth = CGFloat(1)

    themesTable.addConstraint(NSLayoutConstraint(item: themesTable, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(1), constant: min(computedHeight, maxHeight)))
    applyStyleToViews()
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let theme = themeDataSource.themeAt(indexPath)!

    styleGuide.setTheme(theme)
    
    selectIdxPath = indexPath

    applyStyleToViews()
  }

  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [self.view]
      case .Header:
        return [headerView, saveBtn]
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    switch(sel) {
      case .FooterUIBtn:
        return [saveBtn.titleLabel!]
      default:
        return []
    }
  }
  
  func applyStyleToViews() {
    let selectors: [ViewSelector] = [.MainContent, .Header, .FooterUIBtn]

    for sel in selectors {
      styleGuide.applyLayerStyle(sel, views: viewsForLayerStyle(sel))
    }
    
    themesTable.layer.borderColor = styleGuide.theme.bgColor1.getShade(-0.15).CGColor
    styleGuide.applyFontStyle(.FooterUIBtn, views: viewsForFontStyle(.FooterUIBtn))
  }

}