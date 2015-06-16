//
//  TitleBarPopUpButton.swift
//  Plug
//
//  Created by Alex Marchant on 6/10/15.
//  Copyright (c) 2015 Plug. All rights reserved.
//

import Cocoa

class TitleBarPopUpButtonCell: NSPopUpButtonCell {
    var originalMenu: NSMenu?
    
    override var menu: NSMenu? {
        didSet {
            originalMenu = menu!.copy() as? NSMenu
        }
    }
    
    var formattedTitle: NSAttributedString {
        return DropdownTitleFormatter().attributedDropdownTitle(menu!.title, optionTitle: title)
    }
    
    var extraWidthForFormattedTitle: CGFloat {
        return formattedTitle.size.width - attributedTitle.size.width
    }
    
    override func drawTitle(title: NSAttributedString, withFrame frame: NSRect, inView controlView: NSView) -> NSRect {
        return super.drawTitle(formattedTitle, withFrame: frame, inView: controlView)
    }
    
    override func drawBezelWithFrame(frame: NSRect, inView controlView: NSView) {
        drawArrow(frame, inView: controlView)
    }
    
    private func drawArrow(frame: NSRect, inView controlView: NSView) {
        let arrowColor = NSColor(white: 0, alpha: 0.4)
        
        let path = NSBezierPath()
        let bounds = controlView.bounds
        
        let leftPoint = NSMakePoint(bounds.size.width - 14, (bounds.size.height / 2) - 1)
        let bottomPoint = NSMakePoint(bounds.size.width - 10, (bounds.size.height / 2) + 3.5);
        let rightPoint = NSMakePoint(bounds.size.width - 6, (bounds.size.height / 2) - 1);
        
        path.moveToPoint(leftPoint)
        path.lineToPoint(bottomPoint)
        path.lineToPoint(rightPoint)
        
        arrowColor.set()
        path.lineWidth = 2
        path.stroke()
    }
    
    
    override func selectItem(item: NSMenuItem?) {
        super.selectItem(item)
        sortMenuForSelectedItem(item)
    }
    
    private func sortMenuForSelectedItem(item: NSMenuItem?) {
        let originalMenuItems = (originalMenu!.itemArray as! [NSMenuItem])
        let sortedItemArray = originalMenuItems.map { self.menu!.itemWithTitle($0.title)! }
        
        for sortItem in sortedItemArray.reverse() {
            if sortItem === item! { continue }
            
            menu!.removeItem(sortItem)
            menu!.insertItem(sortItem, atIndex: 0)
        }
        
        menu!.removeItem(item!)
        menu!.insertItem(item!, atIndex: 0)
    }
}