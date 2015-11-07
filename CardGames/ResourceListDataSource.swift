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
    NSLog("am here in resource list")
    return 3
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    NSLog("did count sections")
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("imageSourceRow", forIndexPath: indexPath)
    
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
    var first = AppResource(author: ("Anny Cecilia Walter", "http://www.publicdomainpictures.net/browse-author.php?a=53721"),
                            source: ("Floral Seamless Pattern", "http://www.publicdomainpictures.net/view-image.php?image=129033&picture=floral-seamless-pattern"),
                               via: ("PublicDomainPictures.net", "http://www.publicdomainpictures.net"))
    first.assetName = "cb_2"
    
    return [first, first, first]
  }
}