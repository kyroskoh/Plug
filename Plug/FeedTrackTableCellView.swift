import Cocoa
import HypeMachineAPI
import SnapKit

final class FeedTrackTableCellView: LoveCountTrackTableCellView {
	let sourceTypeColor = NSColor(red256: 175, green256: 179, blue256: 181)
	let sourceColor = NSColor(red256: 138, green256: 146, blue256: 150)

	var sourceTypeTextField: SelectableTextField!
	var sourceButton: HyperlinkButton!

	override func objectValueChanged() {
		super.objectValueChanged()

		guard objectValue != nil else {
			return
		}

		updateSourceType()
		updateSource()
	}

	override func playStateChanged() {
		super.playStateChanged()

		updateSourceType()
		updateSource()
	}

	override func updateTrackAvailability() {
		super.updateTrackAvailability()

		guard let track else {
			return
		}

		if track.audioUnavailable {
			sourceTypeTextField.textColor = disabledArtistColor
			sourceButton.textColor = disabledArtistColor
		} else {
			sourceTypeTextField.textColor = sourceTypeColor
			sourceButton.textColor = sourceColor
		}
	}

	func updateSourceType() {
		guard let track else {
			return
		}

		if track.viaUser != nil {
			sourceTypeTextField.stringValue = "Loved by"
		} else if track.viaQuery != nil {
			sourceTypeTextField.stringValue = "Matched query"
		} else {
			sourceTypeTextField.stringValue = "Posted by"
		}

		switch playState {
		case .playing, .paused:
			sourceTypeTextField.isSelected = true
		case .notPlaying:
			sourceTypeTextField.isSelected = false
		}
	}

	func updateSource() {
		guard let track else {
			return
		}

		if let viaUser = track.viaUser {
			sourceButton.title = viaUser
		} else if let viaQuery = track.viaQuery {
			sourceButton.title = "\(viaQuery) →"
		} else {
			sourceButton.title = track.postedBy
		}

		switch playState {
		case .playing, .paused:
			sourceButton.isSelected = true
		case .notPlaying:
			sourceButton.isSelected = false
		}
	}

	// swiftlint:disable:next private_action
	@IBAction func sourceButtonClicked(_ sender: NSButton) {
		guard let track else {
			return
		}

		if track.viaUser != nil {
			loadSingleFriendPage()
		} else if track.viaQuery != nil {
			loadQuery()
		} else {
			loadSingleBlogPage()
		}
	}

	func loadSingleFriendPage() {
		guard let track else {
			return
		}

		let viewController = UserViewController(username: track.viaUser!)
		NavigationController.shared!.pushViewController(viewController, animated: true)
	}

	func loadQuery() {
		guard let track else {
			return
		}

		"https://hypem.com/search/\(track.viaQuery!)".openURL()
	}

	func loadSingleBlogPage() {
		guard let track else {
			return
		}

		let viewController = BlogViewController(blogID: track.postedById, blogName: track.postedBy)
		NavigationController.shared!.pushViewController(viewController, animated: true)
	}
}
