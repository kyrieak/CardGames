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
//  let themes = Theme.all()
  let themes = [Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale()]
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
    let computedHeight = themesTable.rowHeight * CGFloat(themes.count)
    let maxHeight = saveBtn.frame.minY - themesTable.frame.minY - 60
    themesTable.layer.borderWidth = CGFloat(1)

    themesTable.addConstraint(NSLayoutConstraint(item: themesTable, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(1), constant: min(computedHeight, maxHeight)))
  }
  
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