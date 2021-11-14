import Cocoa

final class UnderlinedTabButtonCell: NSButtonCell {
	var highlightColor = NSColor(red256: 69, green256: 159, blue256: 255)
	var hightlightWidth = 4.0
	var fixedTextFrame = CGRect(x: 5, y: 40, width: 50, height: 15)
	let maxImageHeight = 36.0

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		highlightsBy = .contentsCellMask
	}

	override func drawBezel(withFrame frame: CGRect, in controlView: NSView) {
		if state == .on {
			let highlightRect = CGRect(x: 0, y: frame.size.height - hightlightWidth, width: frame.size.width, height: hightlightWidth)
			highlightColor.set()
			highlightRect.fill()
		}
	}

	override func drawTitle(_ title: NSAttributedString, withFrame frame: CGRect, in controlView: NSView) -> CGRect {
		// Consistent vertical placement
		super.drawTitle(title, withFrame: fixedTextFrame, in: controlView)
	}

	override func drawImage(_ image: NSImage, withFrame frame: CGRect, in controlView: NSView) {
		// Center image vertically
		var newFrame = frame

		if maxImageHeight > image.size.height {
			let spacer = (maxImageHeight - image.size.height) / 2
			newFrame.origin.y += spacer
			newFrame.size.height += spacer
		}

		image.draw(in: newFrame)
	}
}
