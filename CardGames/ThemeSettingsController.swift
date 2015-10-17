//
//  SGSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/7/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class ThemeSettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate, StyleGuideDelegate {
  let tableCellReuseId = "themeTableRow"
  let themes = Theme.all()
  var selectIdxPath: NSIndexPath?
  
  var style: StyleGuide {
    return styleGuide
  }

  var themeID = styleGuide.themeID

  @IBOutlet var headerView: UIView!
  @IBOutlet var newGameBtn: UIButton!
  @IBOutlet var backBtn: UIButton!
  @IBOutlet var themesTable: UITableView!

  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return themes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let row = tableView.dequeueReusableCellWithIdentifier(tableCellReuseId)!
    
    if ((selectIdxPath == nil) && (indexPath.item == 0)) {
      selectIdxPath = indexPath
    }
    
    row.layoutMargins = UIEdgeInsetsZero
    
    return row
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {

    let theme = themes[indexPath.item]
                    
    cell.contentView.backgroundColor                 = theme.bgColor1
    cell.contentView.viewWithTag(2)!.backgroundColor = theme.bgColor2
    cell.contentView.viewWithTag(3)!.backgroundColor = theme.bgColor3                
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let theme = themes[indexPath.item]

    styleGuide.setTheme(theme)
    
    selectIdxPath = indexPath

    applyStyleToViews()
  }

  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [self.view]
      case .Header:
        return [headerView, newGameBtn]
      default:
        return []
    }
  }
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    switch(sel) {
      case .FooterUIBtn:
        return [newGameBtn.titleLabel!]
      default:
        return []
    }
  }
  
  func applyStyleToViews() {
    let selectors: [ViewSelector] = [.MainContent, .Header, .FooterUIBtn]

    for sel in selectors {
      styleGuide.applyLayerStyle(sel, views: viewsForLayerStyle(sel))
    }
    
    styleGuide.applyFontStyle(.FooterUIBtn, views: viewsForFontStyle(.FooterUIBtn))
  }

}