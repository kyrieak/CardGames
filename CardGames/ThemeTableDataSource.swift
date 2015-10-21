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
  let tableRowReuseId = "themeTableRow"
  //  let themes = Theme.all()
  let themes = [Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale(), Theme.green(), Theme.grayscale()]

  let nameTag: Int   = 4
  let color2Tag: Int = 2
  let color3Tag: Int = 3
 
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
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
    themeLabel.font = UIFont(name: styleGuide.fontStyle(.HeadTitle)!.fontName, size: CGFloat(18))
    themeLabel.textColor = theme.fontColor2

    return row
  }
  
  func themeAt(indexPath: NSIndexPath) -> Theme? {
    let idx = indexPath.item
    var theme = Theme()
    
    switch(idx) {
      case 0:
        ThemeTableDataSource.applyHoneydew(&theme)
      case 1:
        ThemeTableDataSource.applyGrayscale(&theme)
      case 2:
        ThemeTableDataSource.applySea(&theme)
      default:
        return nil
    }
    
    return theme
  }
  
  class func applyGrayscale(inout theme: Theme) -> Theme {
    theme.name = "Grayscale"
    
    theme.bgColor1 = UIColor(white: 0.7, alpha: 1.0)
    theme.bgColor2 = UIColor(white: 0.9, alpha: 1.0)
    theme.bgColor3 = UIColor(white: 0.8, alpha: 1.0)
    theme.bgColor4 = UIColor(white: 0.4, alpha: 1.0)
    theme.fontColor2 = UIColor(white: 0.2, alpha: 1.0)

    return theme
  }
  
  class func applyHoneydew(inout theme: Theme) -> Theme {
    theme.name = "Honeydew Green"
    
    theme.bgColor1 = UIColor(red: 0.93, green: 0.97, blue: 0.93, alpha: 1.0)
    theme.bgColor2   = UIColor(red: 0.80, green: 0.88, blue: 0.82, alpha: 1.0)
    theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.73, alpha: 1.0)
    theme.bgColor4   = theme.bgColor1
    
    theme.fontColor2 = UIColor(red: 0.61, green: 0.73, blue: 0.61, alpha: 1.0)
    theme.fontColor3 = UIColor(red: 0.26, green: 0.19, blue: 0.11, alpha: 1.0)
    theme.fontColor4 = UIColor(red: 0.43, green: 0.33, blue: 0.27, alpha: 1.0)
    
    return theme
  }
  
  class func applySea(inout theme: Theme) -> Theme {
    theme.name = "Down by the Sea"
    theme.bgColor1 = UIColor(red: 0.74, green: 0.95, blue: 0.93, alpha: 1.0)
    theme.bgColor2 = theme.bgColor1.getShade(-0.1)
    theme.bgColor3   = UIColor(red: 0.80, green: 0.76, blue: 0.73, alpha: 1.0)
    theme.fontColor2 = theme.bgColor1.getShade(-0.4)

    return theme
  }
}