//
//	FriendTableCellView.swift
//	Plug
//
//	Created by Alex Marchant on 9/5/14.
//	Copyright (c) 2014 Plug. All rights reserved.
//

import Cocoa
import HypeMachineAPI
import Alamofire

class UserTableCellView: IOSStyleTableCellView {
	var avatarView: NSImageView!
	var fullNameTextField: NSTextField!
	var usernameTextField: NSTextField!

	override var objectValue: Any! {
		didSet {
			objectValueChanged()
		}
	}

	var user: HypeMachineAPI.User {
		objectValue as! HypeMachineAPI.User
	}

	func objectValueChanged() {
		guard objectValue != nil else {
			return
		}

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

		guard user.avatarURL != nil else {
			return
		}

		Alamofire
			.request(user.avatarURL!, method: .get)
			.validate()
			.responseImage { response in
				switch response.result {
				case let .success(image):
					self.avatarView.image = image
				case let .failure(error):
					Notifications.post(name: Notifications.DisplayError, object: self, userInfo: ["error": error as NSError])
					Swift.print(error as NSError)
				}
			}
	}
}
