//
//  iOSSwitch.swift
//  Plug
//
//  Created by Alex Marchant on 6/16/15.
//  Copyright (c) 2015 Plug. All rights reserved.
//

import Cocoa
import QuartzCore

class IOSSwitch: NSControl {
    let animationDuration: CFTimeInterval = 0.4
    
    let borderLineWidth: CGFloat = 2
    
    let goldenRatio: CGFloat = 1.61803398875
    let decreasedGoldenRatio: CGFloat = 1.38
    
    let enabledOpacity: Float = 1
    let disabledOpacity: Float = 0.5
    
    let knobBackgroundColor = NSColor(calibratedWhite: 1, alpha: 1)
    
    let disabledBorderColor = NSColor(calibratedRed: 0.84, green: 0.85, blue: 0.87, alpha: 1)
    let disabledBackgroundColor = NSColor(calibratedRed: 0.84, green: 0.85, blue: 0.87, alpha: 1)
    let defaultTintColor = NSColor(calibratedRed: 0.27, green: 0.62, blue: 1, alpha: 1)
    let inactiveBackgroundColor = NSColor(calibratedWhite: 0, alpha: 0.3)
    
    var isActive: Bool = false
    var hasDragged: Bool = false
    var isDraggingTowardsOn: Bool = false
    
    let rootLayer = CALayer()
    let backgroundLayer = CALayer()
    let knobLayer = CALayer()
    let knobInsideLayer = CALayer()

    var on: Bool = false {
        didSet { reloadLayer() }
    }
    var tintColor: NSColor {
        set { tintColorStore = newValue }
        get { return tintColorStore ?? defaultTintColor }
    }
    var tintColorStore: NSColor? {
        didSet { reloadLayer() }
    }
    override var enabled: Bool {
        didSet { reloadLayer() }
    }


    // MARK: Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        setup()
    }
    
    func setup() {
        // The Switch is enabled per default
        enabled = true
    
        // Set up the layer hierarchy
        setUpLayers()
    }
    
    func setUpLayers() {
        // Root layer
        //rootLayer.delegate = self
        layer = rootLayer
        wantsLayer = true
        
        // Background layer
        backgroundLayer.autoresizingMask = .LayerWidthSizable | .LayerHeightSizable
        backgroundLayer.bounds = rootLayer.bounds
        backgroundLayer.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.borderWidth = borderLineWidth
        rootLayer.addSublayer(backgroundLayer)
        
        // Knob layer
        knobLayer.frame = rectForKnob()
        knobLayer.autoresizingMask = .LayerHeightSizable
        knobLayer.backgroundColor = knobBackgroundColor.CGColor
        knobLayer.shadowColor = NSColor.blackColor().CGColor
        knobLayer.shadowOffset = CGSize(width: 0, height: -2)
        knobLayer.shadowRadius = 1
        knobLayer.shadowOpacity = 0.3
        rootLayer.addSublayer(knobLayer)
        
        knobInsideLayer.frame = knobLayer.bounds
        knobInsideLayer.autoresizingMask = .LayerWidthSizable | .LayerHeightSizable
        knobInsideLayer.shadowColor = NSColor.blackColor().CGColor
        knobInsideLayer.shadowOffset = CGSize(width: 0, height: 0)
        knobInsideLayer.backgroundColor = NSColor.whiteColor().CGColor
        knobInsideLayer.shadowRadius = 1
        knobInsideLayer.shadowOpacity = 0.35
        knobLayer.addSublayer(knobInsideLayer)
        
        // Initial
        reloadLayerSize()
        reloadLayer()
    }
    
    // MARK: NSView

    override func acceptsFirstMouse(theEvent: NSEvent) -> Bool {
        return true
    }
    
    override var frame: NSRect {
        didSet {
            reloadLayerSize()
        }
    }
    
    // MARK: Update Layer
    
    
    func reloadLayer() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        
        
            // ------------------------------- Animate Border
            // The green part also animates, which looks kinda weird
            // We'll use the background-color for now
            //        _backgroundLayer.borderWidth = (YES || self.isActive || self.isOn) ? NSHeight(_backgroundLayer.bounds) / 2 : kBorderLineWidth;
            
            // ------------------------------- Animate Colors
            if (hasDragged && isDraggingTowardsOn) || (!hasDragged && on) {
                backgroundLayer.borderColor = tintColor.CGColor
                backgroundLayer.backgroundColor = tintColor.CGColor
            } else {
                backgroundLayer.borderColor = disabledBorderColor.CGColor
                backgroundLayer.backgroundColor = disabledBackgroundColor.CGColor
            }
            
            // ------------------------------- Animate Enabled-Disabled state
            if enabled {
                rootLayer.opacity = enabledOpacity
            } else {
                rootLayer.opacity = disabledOpacity
            }
            
            // ------------------------------- Animate Frame
            if !hasDragged {
                let function = CAMediaTimingFunction(controlPoints: 0.25, 1.5, 0.5, 1)
                CATransaction.setAnimationTimingFunction(function)
            }
            
            knobLayer.frame = rectForKnob()
            knobInsideLayer.frame = knobLayer.bounds
        
        
        CATransaction.commit()
    }
    
    func reloadLayerSize() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
            knobLayer.frame = rectForKnob()
            knobInsideLayer.frame = knobLayer.bounds
        
            backgroundLayer.cornerRadius = backgroundLayer.bounds.size.height / 2
            knobLayer.cornerRadius = knobLayer.bounds.size.height / 2
            knobInsideLayer.cornerRadius = knobLayer.bounds.size.height / 2
        
        CATransaction.commit()
    }

    
    func rectForKnob() -> CGRect {
        let knobHeight = knobHeightForSize(backgroundLayer.bounds.size)
        let knobWidth = knobWidthForSize(backgroundLayer.bounds.size)
        let knobX = knobXForSize(backgroundLayer.bounds.size, knobWidth: knobWidth)
        return CGRect(x: knobX, y: borderLineWidth, width: knobWidth, height: knobHeight)
    }
    
    
    func knobHeightForSize(size: NSSize) -> CGFloat {
        return size.height - (borderLineWidth * 2)
    }
    
    func knobWidthForSize(size: NSSize) -> CGFloat {
        if isActive {
            return (size.width - (2 * borderLineWidth)) * (1 / decreasedGoldenRatio)
        } else {
            return (size.width - (2 * borderLineWidth)) * (1 / goldenRatio)
        }
    }
    
    func knobXForSize(size: NSSize, knobWidth: CGFloat) -> CGFloat {
        if (!hasDragged && !on) || (hasDragged && !isDraggingTowardsOn) {
            return borderLineWidth
        } else {
            return size.width - knobWidth - borderLineWidth
        }
    }
    
    // MARK: NSResponder
    
    override var acceptsFirstResponder: Bool {
        return true
    }

    override func mouseDown(theEvent: NSEvent) {
        if !enabled { return }
        
        isActive = true
        
        reloadLayer()
    }

    override func mouseDragged(theEvent: NSEvent) {
        if !enabled { return }
        
        hasDragged = true
        
        let draggingPoint = convertPoint(theEvent.locationInWindow, fromView: nil)
        isDraggingTowardsOn = draggingPoint.x >= bounds.size.width / 2
        
        reloadLayer()
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if !enabled { return }
        
        isActive = false
        
        let newOnValue: Bool
        if !hasDragged {
            newOnValue = !on
        } else {
            newOnValue = isDraggingTowardsOn
        }
        let shouldInvokeTargetAction = on != newOnValue

        on = newOnValue
        
        if shouldInvokeTargetAction {
            invokeTargetAction()
        }
        
        // Reset
        hasDragged = false
        isDraggingTowardsOn = false
        
        reloadLayer()
    }
    
    // MARK: Helpers
    
    func invokeTargetAction() {
        if target != nil && action != "" {
            sendAction(action, to: target!)
        }
    }
    
}