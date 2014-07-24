//
//  TitleBarView.swift
//  Plug
//
//  Created by Alexander Marchant on 7/15/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa

class TitleBarView: DraggableVisualEffectsView {
    override var mouseDownCanMoveWindow : Bool {
        return true
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}