//
//  FeedTableCellView.swift
//  Plug
//
//  Created by Alex Marchant on 8/14/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa

class FeedTableCellView: PlaylistTableCellView {
    @IBOutlet var usernameOrBlogNameTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var lovedByOrPostedByWidthConstraint: NSLayoutConstraint!
    @IBOutlet var lovedByOrPostedBy: NSTextField!
    @IBOutlet var usernameOrBlogName: NSTextField!
    
    override func objectValueChanged() {
        super.objectValueChanged()
        
        updateLovedByOrPostedBy()
    }
    
    func updateLovedByOrPostedBy() {
        var lovedByWidth: CGFloat = 52
        var postedByWidth: CGFloat = 57
        
        if trackValue.lovedBy != nil {
            lovedByOrPostedByWidthConstraint.constant = lovedByWidth
            lovedByOrPostedBy.stringValue = "Loved by"
            usernameOrBlogName.stringValue = trackValue.lovedBy
        } else {
            lovedByOrPostedByWidthConstraint.constant = postedByWidth
            lovedByOrPostedBy.stringValue = "Posted by"
            usernameOrBlogName.stringValue = trackValue.postedBy
        }
    }
    
    override func updateTextFieldsSpacing() {
        super.updateTextFieldsSpacing()
        
        var mouseOutSpacing: CGFloat = 32
        var mouseInSpacing: CGFloat = 20
        
        if mouseInside {
            usernameOrBlogNameTrailingConstraint.constant = mouseInSpacing
        } else {
            usernameOrBlogNameTrailingConstraint.constant = mouseOutSpacing
        }
    }
}
