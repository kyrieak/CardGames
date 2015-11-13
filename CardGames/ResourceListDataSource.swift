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
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0) {
      return 1
    } else {
      return resources.count
    }
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    NSLog("did count sections")
    return 2
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell

    if (indexPath.section == 0) {
      cell = tableView.dequeueReusableCellWithIdentifier("disclaimerRow", forIndexPath: indexPath)
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("imageSourceRow", forIndexPath: indexPath)
    }

    let separator = UIView(frame: CGRect(origin: CGPoint(x: 5, y: cell.contentView.frame.maxY - 1), size: CGSize(width: cell.contentView.frame.width - 10, height: 0.5)))
    
    separator.backgroundColor = appGlobals.styleGuide.theme.shadeColor1

    cell.addSubview(separator)
    cell.backgroundColor = nil

    return cell
  }
  
//  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//    NSLog("\(cell) at will display)")
//    setImgDataFor(cell, atIndexPath: indexPath)
//  }
//  
//  func setImgDataFor(cell: UITableViewCell, atIndexPath: NSIndexPath) {
//    NSLog("setting data for img resource")
//    let resource = resources[atIndexPath.item]
//
//    let imgView    = cell.viewWithTag(1) as! UIImageView
//    let authorView = cell.viewWithTag(2) as! UITextView
//    let sourceView = cell.viewWithTag(3) as! UITextView
//    let viaView    = cell.viewWithTag(4) as! UITextView
//
//    imgView.image             = UIImage(named: resource.assetName!)
//    authorView.attributedText = resource.authorLinkText
//    sourceView.attributedText = resource.sourceLinkText
//    viaView.attributedText    = resource.viaLinkText
//  }
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
    var first = AppResource(author: ("Victoria Wong", "https://www.linkedin.com/in/victoria-wong-42144467"),
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
    
//    var fourth = AppResource(author: ("", ""),
//      source: ("cardBack", ""),
//      via: ("", ""))
//    fourth.assetName = "cardBack"
    
    return [first, second, third, first]
  }
}