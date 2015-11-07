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
  
  @IBOutlet var tableDataSource: ResourceListDataSource!
  
  override func viewDidLoad() {
    NSLog("view did load?")

    super.viewDidLoad()
  }
  override func viewDidLayoutSubviews() {
    let tableView = (self.view.viewWithTag(10) as! UITableView)
    NSLog("\(tableView.delegate) and \n\n\(tableView.dataSource)")
    tableView.reloadData()
    NSLog("did layout subviews")
    super.viewDidLayoutSubviews()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSLog("vid did appear???????????????")
  }
  
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    let resource = tableDataSource.resources[indexPath.item]
    
    let imgView = cell.viewWithTag(1) as! UIImageView
    let infoView = cell.viewWithTag(2) as! UITextView

    infoView.attributedText = makeInfoTextFor(resource)

    imgView.image = UIImage(named: resource.assetName!)
  }
  
  func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
    UIApplication.sharedApplication().openURL(URL)
    return false
  }
  
  func makeInfoTextFor(resource: AppResource) -> NSAttributedString {
    let italicFont = UIFont(name: "Palatino-Italic", size: 14)!
    
    let sourceLine = NSMutableAttributedString(string: resource.source.name + "\n")
    let authorLine = NSMutableAttributedString(string: "by: " + resource.author.name + "\n")
    let viaLine = NSMutableAttributedString(string: "via: " + resource.via.name)
    
    let sourceRange = NSRange(location: 0, length: sourceLine.length)
    let authorRange = NSRange(location: 0, length: authorLine.length)
    let viaRange = NSRange(location: 0, length: viaLine.length)
    
    sourceLine.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: sourceRange)
    sourceLine.addAttribute(NSParagraphStyleAttributeName, value: makeParagStyle(1.0), range: sourceRange)
    sourceLine.addAttribute(NSLinkAttributeName, value: resource.source.url!, range: NSRange(location: 0, length: (sourceLine.length - 1)))
    NSLog("\(authorLine)")
    
    authorLine.addAttribute(NSFontAttributeName, value: italicFont, range: NSRange(location: 0, length: 4))
    authorLine.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSRange(location: 4, length: (authorLine.length - 4)))
    authorLine.addAttribute(NSLinkAttributeName, value: resource.author.url!, range: NSRange(location: 4, length: (authorLine.length - 5)))
    authorLine.addAttribute(NSParagraphStyleAttributeName, value: makeParagStyle(1.5), range: authorRange)
    
    viaLine.addAttribute(NSFontAttributeName, value: italicFont, range: NSRange(location: 0, length: 5))
    viaLine.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSRange(location: 5, length: (viaLine.length - 5)))
    viaLine.addAttribute(NSLinkAttributeName, value: resource.via.url!, range: NSRange(location: 5, length: (viaLine.length - 5)))
    viaLine.addAttribute(NSParagraphStyleAttributeName, value: makeParagStyle(1.5), range: viaRange)

    let infoText = sourceLine
    
    infoText.appendAttributedString(authorLine)
    infoText.appendAttributedString(viaLine)
    
    return infoText
  }
  
  func makeParagStyle(lhm: CGFloat) -> NSParagraphStyle {
    let ps = NSMutableParagraphStyle()

    ps.lineHeightMultiple = lhm

    return ps
  }
  
  func setLineHeight(attrString: NSMutableAttributedString, lhm: CGFloat) -> NSMutableAttributedString {
    let len = attrString.string.characters.count
    let dps = NSMutableParagraphStyle()
    
    dps.lineHeightMultiple = lhm
    attrString.addAttribute(NSParagraphStyleAttributeName, value: dps, range: NSRange(location: 0, length: len))

    return attrString
  }
  
  
  func setSizeAndLayoutAttrs(attrString: NSMutableAttributedString, size: CGFloat, lhm: CGFloat) -> NSMutableAttributedString{
    let len = attrString.string.characters.count
    
    let dps = NSMutableParagraphStyle()
    dps.lineHeightMultiple = lhm

    attrString.addAttribute(NSFontAttributeName,
      value: UIFont.systemFontOfSize(size),
      range: NSRange(location: 0, length: len))
    attrString.addAttribute(NSParagraphStyleAttributeName, value: dps, range: NSRange(location: 0, length: len))
    return attrString
  }
  
  func setLinkAttrs(attrString: NSMutableAttributedString, size: CGFloat) -> NSMutableAttributedString {
    let len = attrString.string.characters.count

    attrString.addAttribute(NSFontAttributeName,
                              value: UIFont.systemFontOfSize(size),
                                range: NSRange(location: 0, length: len))
    return attrString
  }
  
  @IBAction func didTapLink(sender: UIButton) {
    var range: NSRange = NSMakeRange(0, 1)
    let title = sender.titleLabel!.attributedText!
    let url = title.attribute(NSLinkAttributeName, atIndex: 0, effectiveRange: &range)

    UIApplication.sharedApplication().openURL(url as! NSURL)
  }
}