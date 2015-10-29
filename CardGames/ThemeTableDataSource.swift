//
//  ThemeRowReusableView.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/18/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class ThemeTableDataSource: NSObject, UITableViewDataSource {
  let themes = ThemeTableDataSource.allThemes()
  let tableRowReuseId = "themeTableRow"
  let nameTag: Int   = 4
  let color2Tag: Int = 2
  let color3Tag: Int = 3
 
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  
  func themeAt(indexPath: NSIndexPath) -> Theme? {
    return themes[indexPath.item]
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let theme = themeAt(indexPath)!
    let row = tableView.dequeueReusableCellWithIdentifier(tableRowReuseId, forIndexPath: indexPath)
    row.layoutMargins = UIEdgeInsetsZero
    let contentView = row.contentView
    
    contentView.backgroundColor                    = theme.bgColor1
    contentView.viewWithTag(2)!.backgroundColor    = theme.bgColor2
    contentView.viewWithTag(3)!.backgroundColor    = theme.bgColor3
    
    let themeLabel = contentView.viewWithTag(4)! as! UILabel
    
    themeLabel.text = theme.name
    themeLabel.font = UIFont(name: appGlobals.styleGuide.fontStyle(.HeadTitle)!.fontName, size: CGFloat(18))
    themeLabel.textColor = theme.fontColor2

    return row
  }
  
  
  class func allThemes() -> [Theme] {
    return [Theme.honeydew(), Theme.grayscale(), Theme.sea()]
  }
}