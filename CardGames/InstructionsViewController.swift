//
//  InstructionsViewController.swift
//  CardGames
//
//  Created by Kyrie Kopczynski on 10/29/15.
//  Copyright © 2015 Kyrie. All rights reserved.
//

import Foundation
import UIKit

class InstructionsViewController: UIViewController {
  lazy var numberSection: UIView!  = { return self.view.viewWithTag(1) }()
  lazy var shapeSection: UIView!   = { return self.view.viewWithTag(2) }()
  lazy var shadingSection: UIView! = { return self.view.viewWithTag(3) }()
  lazy var colorSection: UIView!   = { return self.view.viewWithTag(4) }()

  let control1: SetCardAttrs = SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red)
  let control2: SetCardAttrs = SetCardAttrs(number: 2, shape: .Oval, shading: .Open, color: .Green)
  let control3: SetCardAttrs = SetCardAttrs(number: 3, shape: .Squiggle, shading: .Striped, color: .Purple)
  
  lazy var sectionSize: CGSize = {
    let h = (deviceInfo.screenDims.min > 500) ? 140 : 112
    
    return CGSize(width: (self.view.frame.width - 56), height: CGFloat(h))
  }()
  
  lazy var cardSize: CGSize = {
    if (deviceInfo.screenDims.min > 500) {
      return CGSize(width: 75, height: 100)
    } else {
      return CGSize(width: 46, height: 64)
    }
  }()
  
  
  override func viewDidLayoutSubviews() {
    loadNumberCards()
    loadShapeCards()
    loadShadingCards()
    loadColorCards()
  }
  
  
  func loadNumberCards() {
    if (numberSection.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: sectionSize.height - cardSize.height)
      let originR = CGPoint(x: sectionSize.width - (cardSize.width * 3 * 1.1), y: originL.y)
      
      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))
      
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red))
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Oval, shading: .Open, color: .Green))
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Squiggle, shading: .Striped, color: .Purple))
      
      listR.addCardWith(control1)
      listR.addCardWith(control2)
      listR.addCardWith(control3)
      
      numberSection.addSubview(listL)
      numberSection.addSubview(listR)
    }
  }
  
  func loadShapeCards() {
    if (shapeSection.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: sectionSize.height - cardSize.height)
      let originR = CGPoint(x: sectionSize.width - (cardSize.width * 3 * 1.1), y: originL.y)
      
      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))
      
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red))
      listL.addCardWith(SetCardAttrs(number: 2, shape: .Diamond, shading: .Open, color: .Green))
      listL.addCardWith(SetCardAttrs(number: 3, shape: .Diamond, shading: .Striped, color: .Purple))
      
      listR.addCardWith(control1)
      listR.addCardWith(control2)
      listR.addCardWith(control3)
      
      shapeSection.addSubview(listL)
      shapeSection.addSubview(listR)
    }
  }


  func loadShadingCards() {
    if (shadingSection.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: sectionSize.height - cardSize.height)
      let originR = CGPoint(x: sectionSize.width - (cardSize.width * 3 * 1.1), y: originL.y)
      
      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))
      
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red))
      listL.addCardWith(SetCardAttrs(number: 2, shape: .Oval, shading: .Solid, color: .Green))
      listL.addCardWith(SetCardAttrs(number: 3, shape: .Squiggle, shading: .Solid, color: .Purple))
      
      listR.addCardWith(SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red))
      listR.addCardWith(SetCardAttrs(number: 2, shape: .Oval, shading: .Open, color: .Green))
      listR.addCardWith(SetCardAttrs(number: 3, shape: .Squiggle, shading: .Striped, color: .Purple))
      
      shadingSection.addSubview(listL)
      shadingSection.addSubview(listR)
    }
  }


  func loadColorCards() {
    if (colorSection.subviews.count < 2) {
      let originL = CGPoint(x: 0, y: sectionSize.height - cardSize.height)
      let originR = CGPoint(x: sectionSize.width - (cardSize.width * 3 * 1.1), y: originL.y)
      
      let listL = CardListView(frame: CGRect(origin: originL, size: CGSize(width: 0, height: cardSize.height)))
      let listR = CardListView(frame: CGRect(origin: originR, size: CGSize(width: 0, height: cardSize.height)))
      
      listL.addCardWith(SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red))
      listL.addCardWith(SetCardAttrs(number: 2, shape: .Oval, shading: .Open, color: .Red))
      listL.addCardWith(SetCardAttrs(number: 3, shape: .Squiggle, shading: .Striped, color: .Red))
      
      listR.addCardWith(SetCardAttrs(number: 1, shape: .Diamond, shading: .Solid, color: .Red))
      listR.addCardWith(SetCardAttrs(number: 2, shape: .Oval, shading: .Open, color: .Green))
      listR.addCardWith(SetCardAttrs(number: 3, shape: .Squiggle, shading: .Striped, color: .Purple))
      
      colorSection.addSubview(listL)
      colorSection.addSubview(listR)
    }
  }



}