//
//  SGSettingController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/7/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class AppSettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  let tableCellReuseId = "themeTableRow"
  let themes = Theme.all()
  var selectIdxPath: NSIndexPath?

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

    view.backgroundColor = theme.bgColor1
    newGameBtn.backgroundColor = theme.bgColor2
    backBtn.backgroundColor = theme.bgColor3

    selectIdxPath = indexPath
    styleGuide.setTheme(theme)
  }
}