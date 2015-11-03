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
  
  var previousTheme: Theme = appGlobals.styleGuide.theme
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

  
  @IBAction func logoTapAction(sender: UIButton) {
    let vc = storyboard!.instantiateViewControllerWithIdentifier("homeViewController")
    
    self.presentViewController(vc, animated: true, completion: nil)
  }

  
  
  @IBAction func backAction(sender: UIButton) {
    styleGuide.setTheme(previousTheme)
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  func viewsForLayerStyle(sel: ViewSelector) -> [UIView] {
    switch(sel) {
      case .MainContent:
        return [self.view]
      case .Header:
        return [headerView]
      
      default:
        return []
    }
  }
  
  
  func viewsForFontStyle(sel: ViewSelector) -> [UILabel] {
    return [headerView.viewWithTag(11)! as! UILabel]
  }
  
  func viewsForBtnStyle(sel: ViewSelector) -> [UIButton] {
    switch(sel) {
    case .HeadTitle:
      return [headerView.viewWithTag(11)! as! UIButton]
    case .Header:
      return [saveBtn]
    default:
      return []
    }
  }
  
  
  func applyStyleToViews() {
    let selectors: [ViewSelector] = [.MainContent, .Header, .FooterUIBtn]
    let btnSelectors: [ViewSelector] = [.HeadTitle, .Header]

    for sel in selectors {
      styleGuide.applyLayerStyle(sel, views: viewsForLayerStyle(sel))
    }
    
    for sel in btnSelectors {
      styleGuide.applyBtnStyle(sel, views: viewsForBtnStyle(sel))
    }
    
    backBtn.setTitleColor(styleGuide.fontStyle(.HeadTitle)!.color, forState: .Normal)
    
    themesTable.layer.borderColor = styleGuide.theme.bgBase.getShade(-0.15).CGColor
  }

  
  private func computedTableHeight() -> CGFloat {
    return (themesTable.rowHeight * CGFloat(themeDataSource.themes.count))
  }
  
  
  private func maxTableHeight() -> CGFloat {
    return (saveBtn.frame.minY - themesTable.frame.minY - 60)
  }
}