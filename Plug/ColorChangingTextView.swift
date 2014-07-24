//
//  ColorChangingTextView.swift
//  Plug
//
//  Created by Alexander Marchant on 7/16/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa

class ColorChangingTextField: NSTextField {
    
    func setColorForStringValue() {
        let numberValue = numberValueForStringValue()
        let gradientLocation = gradientLocationForNumberValue(numberValue)
        let gradient = makeGradient()
        let newColor = gradient.interpolatedColorAtLocation(gradientLocation)
        textColor = newColor
    }
    
    func gradientLocationForNumberValue(numberValue: Int) -> CGFloat {
        let highEnd: CGFloat = 8000
        var location = CGFloat(numberValue) / highEnd
        if location > 1 {
            location = 1.0
        }
        return 1.0 - location
    }
    
    func numberValueForStringValue() -> Int {
        if stringValue.hasSuffix("k") {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.format = "####k"
            let numberValue = numberFormatter.numberFromString(stringValue).integerValue
            return numberValue * 1000
        } else {
            return stringValue.bridgeToObjectiveC().integerValue
        }
    }
    
    func makeGradient() -> NSGradient {
        let redColor = NSColor(red256: 255, green256: 95, blue256: 82)
        let purpleColor = NSColor(red256: 183, green256: 101, blue256: 212)
        let darkBlueColor = NSColor(red256: 28, green256: 121, blue256: 219)
        let lightBlueColor = NSColor(red256: 158, green256: 236, blue256: 255)
        return NSGradient(colorsAndLocations: (redColor, 0), (purpleColor, 0.333), (darkBlueColor, 0.666), (lightBlueColor, 1))
    }
    
    override func viewDidMoveToWindow()  {
        setColorForStringValue()
    }
}