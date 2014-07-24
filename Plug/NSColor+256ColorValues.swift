//
//  NSColor+255ColorValues.swift
//  Plug
//
//  Created by Alex Marchant on 6/12/14.
//  Copyright (c) 2014 Alex Marchant. All rights reserved.
//

import Foundation
import Cocoa

extension NSColor {
    convenience init(red256 red: Int, green256 green: Int, blue256 blue: Int) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
    convenience init(red256 red: Int, green256 green: Int, blue256 blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
}