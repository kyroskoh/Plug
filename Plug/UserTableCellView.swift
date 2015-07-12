//
//  FriendTableCellView.swift
//  Plug
//
//  Created by Alex Marchant on 9/5/14.
//  Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa
import HypeMachineAPI
import Alamofire

class UserTableCellView: IOSStyleTableCellView {
    @IBOutlet var avatarView: NSImageView!
    @IBOutlet var fullNameTextField: NSTextField!
    @IBOutlet var usernameTextField: NSTextField!

    override var objectValue: AnyObject! {
        didSet {
            objectValueChanged()
        }
    }
    var user: HypeMachineAPI.User {
        return objectValue as! HypeMachineAPI.User
    }
    
    func objectValueChanged() {
        if objectValue == nil { return }
        
        updateFullName()
        updateUsername()
        updateImage()
    }
    
    func updateFullName() {
        fullNameTextField.stringValue = user.fullName ?? user.username
    }
    
    func updateUsername() {
        usernameTextField.stringValue = user.username
    }
    
    func updateImage() {
        avatarView.image = NSImage(named: "Avatar-Placeholder")
        if user.avatarURL == nil { return }
        
        Alamofire.request(.GET, user.avatarURL!).validate().responseImage {
            (_, _, image, error) in
            
            if error != nil {
                Notifications.post(name: Notifications.DisplayError, object: self, userInfo: ["error": error!])
                println(error!)
                return
            }
            
            self.avatarView.image = image
        }
    }
}