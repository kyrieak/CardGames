//
//  ResourceListDataSource.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 11/4/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class ResourceListDataSource: NSObject, UITableViewDataSource {
  let resources: [AppResource] = AppResource.all()
  let styleGuide = appGlobals.styleGuide
  let theme = appGlobals.styleGuide.theme
  var fontSize: (title: CGFloat, sub: CGFloat) = (title: 16, sub: 14)
  var imgWidth: CGFloat = 100
  
  override init() {
    super.init()

    if (deviceInfo.screenDims.min < 400) {
      fontSize.title = 14
      fontSize.sub = 12
      imgWidth = 70
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0) {
      return 1
    } else {
      return resources.count
    }
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell

    if (indexPath.section == 0) {
      cell = tableView.dequeueReusableCellWithIdentifier("disclaimerRow", forIndexPath: indexPath)
      
      let textView = cell.contentView.subviews.first! as! UITextView
      
      textView.tintColor = theme.fontColor2
      textView.attributedText = introText()
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("imageSourceRow", forIndexPath: indexPath)
      
      let resource = resources[indexPath.item]
      let imgView = cell.viewWithTag(1) as! UIImageView
      let infoView = cell.viewWithTag(2) as! UITextView

      infoView.textContainerInset.top = 0
      infoView.tintColor = theme.fontColor1
      infoView.attributedText = makeInfoTextFor(resource)
      
      imgView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: imgWidth))
      
      imgView.image = UIImage(named: resource.assetName!)
    }
    

    let separator = UIView(frame: CGRect(origin: CGPoint(x: 5, y: cell.contentView.frame.maxY - 1), size: CGSize(width: cell.contentView.frame.width - 10, height: 0.5)))
    
    separator.backgroundColor = appGlobals.styleGuide.theme.shadeColor1
    
    cell.addSubview(separator)
    cell.backgroundColor = nil
    
    return cell
  }
  
  func introText() -> NSMutableAttributedString {
    let baseText = NSMutableAttributedString(string: "I am an independent developer and I have built the Seta3 app based on the rules of the original game called Set. I do not claim credit for the idea of the original Set game designed by Marsha Falco. I do not represent Set Enterprises, nor do I have any affiliation with Set Enterprises.\n\nSpecial Thanks To:\n\n")
    let thanksLine = NSMutableAttributedString(string: "Victoria Wong: Design Consultant and Theme Contributor\nMiki Bairstow: Design Consultant\n")
    
    thanksLine.addAttributes(styleGuide.linkTextAttributes(NSURL(string: "http://touch.www.linkedin.com/#profile/236978521")!), range: NSRange(location: 0, length: 13))
    thanksLine.addAttributes(styleGuide.linkTextAttributes(NSURL(string: "https://touch.www.linkedin.com/#profile/111913701")!), range: NSRange(location: 55, length: 13))
    baseText.appendAttributedString(thanksLine)
    
    return baseText
  }

  
  func makeInfoTextFor(resource: AppResource) -> NSAttributedString {
    let italicFont = UIFont(name: "Palatino-Italic", size: fontSize.sub)!
    
    let sourceLine = NSMutableAttributedString(string: resource.source.name + "\n")
    let authorLine = NSMutableAttributedString(string: "by: " + resource.author.name + "\n")
    let viaLine: NSMutableAttributedString
    
    if (resource.via.name.characters.count > 0) {
      viaLine = NSMutableAttributedString(string: "via: " + resource.via.name)
    } else {
      viaLine = NSMutableAttributedString(string: "")
    }
    
    let sourceRange = NSRange(location: 0, length: sourceLine.length)
    let authorRange = NSRange(location: 0, length: authorLine.length)
    let viaRange = NSRange(location: 0, length: viaLine.length)
    
    sourceLine.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(fontSize.title), range: sourceRange)
    sourceLine.addAttribute(NSParagraphStyleAttributeName, value: makeParagStyle(1.0), range: sourceRange)
    
    if (resource.source.url != nil) {
      sourceLine.addAttributes(styleGuide.linkTextAttributes(resource.source.url!), range: NSRange(location: 0, length: (sourceLine.length - 1)))
      sourceLine.addAttribute(NSUnderlineColorAttributeName, value: styleGuide.theme.shadeColor1, range: NSRange(location: 0, length: (sourceLine.length - 1)))
    }
    
    authorLine.addAttribute(NSFontAttributeName, value: italicFont, range: NSRange(location: 0, length: 4))
    authorLine.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(fontSize.sub), range: NSRange(location: 4, length: (authorLine.length - 4)))
    authorLine.addAttribute(NSLinkAttributeName, value: resource.author.url!, range: NSRange(location: 4, length: (authorLine.length - 5)))
    authorLine.addAttribute(NSParagraphStyleAttributeName, value: makeParagStyle(1.5), range: authorRange)
    
    if (resource.via.name.characters.count > 0) {
      viaLine.addAttribute(NSFontAttributeName, value: italicFont, range: NSRange(location: 0, length: 5))
      viaLine.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(fontSize.sub), range: NSRange(location: 5, length: (viaLine.length - 5)))
      
      if (resource.via.url != nil) {
        viaLine.addAttribute(NSLinkAttributeName, value: resource.via.url!, range: NSRange(location: 5, length: (viaLine.length - 5)))
      }
      viaLine.addAttribute(NSParagraphStyleAttributeName, value: makeParagStyle(1.5), range: viaRange)
    }
    
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
}

struct AppResource {
  var assetName: String?
  let author: (name: String, url: NSURL?)
  let source: (name: String, url: NSURL?)
  let via: (name: String, url: NSURL?)
  
  var authorLinkText: NSMutableAttributedString {
    return linkText(author.name, url: author.url)
  }
  
  var sourceLinkText: NSMutableAttributedString {
    return linkText(source.name, url: source.url)
  }
  
  var viaLinkText: NSMutableAttributedString {
    return linkText(via.name, url: via.url)
  }
  
  
  init(author: (String, String?), source: (String, String?), via: (String, String?)) {
    let toURL = {(url: String?) -> NSURL? in
      return (url == nil) ? nil : NSURL(string: url!)
    }
    
    self.author = (name: author.0, url: toURL(author.1))
    self.source = (name: source.0, url: toURL(source.1))
    self.via = (name: via.0, url: toURL(via.1))
  }
  
  
  
  func linkText(displayText: String, url: NSURL?) -> NSMutableAttributedString {
    if (url != nil) {
      var textAttributes = [String: AnyObject]()

      textAttributes[NSLinkAttributeName] = url!
      textAttributes[NSUnderlineStyleAttributeName] = NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue)
//      textAttributes[NSUnderlineColorAttributeName] = UIColor.grayColor()
//      textAttributes[NSForegroundColorAttributeName] = UIColor.grayColor()
      
      return NSMutableAttributedString(string: displayText, attributes: textAttributes)
    } else {
      return NSMutableAttributedString(string: displayText)
    }
  }
  
  
  static func all() -> [AppResource] {
    var first = AppResource(author: ("Victoria Wong", "http://touch.www.linkedin.com/#profile/236978521"),
      source: ("Tile I", nil),
      via: ("", nil))
      first.assetName = "cb_v1"
    
    var second = AppResource(author: ("Anny Cecilia Walter", "http://www.publicdomainpictures.net/browse-author.php?a=53721"),
                             source: ("Small Flowers Pattern", "http://www.publicdomainpictures.net/view-image.php?image=123311&picture=small-flowers-pattern"),
                                via: ("PublicDomainPictures.net", "http://www.publicdomainpictures.net"))
    second.assetName = "cb_1"
    
    var third = AppResource(author: ("Anny Cecilia Walter", "http://www.publicdomainpictures.net/browse-author.php?a=53721"),
                            source: ("Floral Seamless Pattern", "http://www.publicdomainpictures.net/view-image.php?image=129033&picture=floral-seamless-pattern"),
                               via: ("PublicDomainPictures.net", "http://www.publicdomainpictures.net"))
    third.assetName = "cb_3"
    
    var fourth = AppResource(author: ("Alex Borland", "http://www.publicdomainpictures.net/browse-author.php?a=39806"),
                             source: ("Gray Seamless Camouflage Pattern", "http://www.publicdomainpictures.net/view-image.php?image=133882&picture=gray-seamless-camouflage-pattern"),
                                via: ("PublicDomainPictures.net", "http://www.publicdomainpictures.net"))
    fourth.assetName = "cb_2"
//    var fourth = AppResource(author: ("", ""),
//      source: ("cardBack", ""),
//      via: ("", ""))
//    fourth.assetName = "cardBack"
    
    return [first, second, third, fourth]
  }
}