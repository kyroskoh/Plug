//
//  PopularHeatMapView.swift
//  Plug
//
//  Created by Alexander Marchant on 7/16/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa

class HeatMapView: NSView {
    var dataPoints: (CGFloat, CGFloat)? {
    didSet {
        needsDisplay = true
    }
    }
    var heatMapColor: NSColor? {
    didSet {
        needsDisplay = true
    }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if dataPoints && heatMapColor {
            drawHeatMap(dirtyRect)
        }
    }
    
    func drawHeatMap(dirtyRect: NSRect) {
        let heatMapSideLength: CGFloat = 32
        
        let xOffset: CGFloat = (bounds.size.width - heatMapSideLength) / 2
        let yOffset: CGFloat = (bounds.size.height - heatMapSideLength) / 2
        let heatMapOrigin = NSMakePoint(xOffset, yOffset)
        
        let thePath = NSBezierPath()
        thePath.moveToPoint(heatMapOrigin)
        thePath.lineToPoint(NSMakePoint(heatMapOrigin.x, heatMapOrigin.y + heatMapSideLength * dataPoints!.0))
        thePath.lineToPoint(NSMakePoint(heatMapOrigin.x + heatMapSideLength, heatMapOrigin.y + heatMapSideLength * dataPoints!.1))
        thePath.lineToPoint(NSMakePoint(heatMapOrigin.x + heatMapSideLength, heatMapOrigin.y))
        thePath.closePath()
        
        heatMapColor!.set()
        thePath.fill()
    }
}