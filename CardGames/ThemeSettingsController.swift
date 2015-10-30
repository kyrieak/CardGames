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
  typealias sg = SGStyleGuide
  
  @IBOutlet var themeDataSource: ThemeTableDataSource!
  
  var styleGuide: sg = appGlobals.styleGuide
  var themeID: Int?  = appGlobals.styleGuide.themeID
  
  lazy var headerView:  UIView      = { return self.view.viewWithTag(1)! }()
  lazy var themesTable: UITableView = { return self.view.viewWithTag(2)! as! UITableView }()
  lazy var saveBtn:     UIButton    = { return self.view.viewWithTag(3)! as! UIButton }()
  lazy var backBtn:     UIButton    = { return self.view.viewWithTag(12)! as! UIButton }()
  
  
  override func viewWillLayoutSubviews() {
    for c in themesTable.constraints {
      if (c.firstAttribute == NSLayoutAttribute.Height) {
        c.constant = min(computedTableHeight(), maxTableHeight())
      }
    }
  }

  
  override func viewDidLayoutSubviews() {
    themesTable.layer.borderWidth = CGFloat(1)

    applyStyleToViews()
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let theme = themeDataSource.themeAt(indexPath)!

    styleGuide.setTheme(theme)
    themeID = theme.id

    applyStyleToViews()
  }

  
  @IBAction func respondToSaveAction(sender: UIButton) {
    NSLog("\(self.presentingViewController?.description)")
    if (self.presentingViewController != nil) {
      let pvc = self.presentingViewController as? GameSettingsController
      
      if (pvc != nil) {
        self.performSegueWithIdentifier("unwindToSetGame", sender: self)
      } else {
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
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

  
  private func computedTableHeight() -> CGFloat {
    return (themesTable.rowHeight * CGFloat(themeDataSource.themes.count))
  }
  
  
  private func maxTableHeight() -> CGFloat {
    return (saveBtn.frame.minY - themesTable.frame.minY - 60)
  }
}