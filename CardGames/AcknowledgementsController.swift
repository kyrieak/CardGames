//
//  AcknowledgementsController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 11/4/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class AcknowledgementsController: UIViewController, UITableViewDelegate, UITextViewDelegate {
  let styleGuide = appGlobals.styleGuide
  let theme = appGlobals.styleGuide.theme
  
  @IBOutlet var tableDataSource: ResourceListDataSource!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
  }
  
  override func viewDidLoad() {
    view.backgroundColor = theme.bgColor2

    super.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    let tableView = (self.view.viewWithTag(10) as! UITableView)
    let title = view.viewWithTag(1)! as! UILabel
    let backBtn = view.viewWithTag(3)! as! UIButton

    title.textColor = theme.fontColor2
    backBtn.setTitleColor(theme.fontColor2, forState: .Normal)
    
    tableView.backgroundColor = theme.bgLight
  }
  
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if (indexPath.section == 0) {
      return 170
    } else {
      if (deviceInfo.screenDims.min < 400) {
        return 90
      } else {
        return tableView.rowHeight
      }
    }
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if (indexPath.section == 0) {
      (cell.contentView.subviews.first as! UITextView).textContainerInset = UIEdgeInsetsZero
    }
  }
  
  
  func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
    UIApplication.sharedApplication().openURL(URL.absoluteURL)
    
    return false
  }
}