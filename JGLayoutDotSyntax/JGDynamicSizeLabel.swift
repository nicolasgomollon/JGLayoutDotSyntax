//
//  JGDynamicSizeLabel.swift
//  JGLayoutDotSyntax
//
//  Objective-C code Copyright (c) 2014 Jaden Geller. All rights reserved.
//  Swift adaptation Copyright (c) 2014 Nicolas Gomollon. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class JGDynamicSizeLabel: UILabel {
	
	/** The font size of the label. Used as a setter, this creates and adds a "constraint" based upon the specification of the assigned JGLayoutParameter. The label's original font size is ignored, and replaced by this constraint. Can only be used with the width and the height attribute. Used as a getter, will return any associated constraint. If none exists, will return nil. Note that, in order to add a font size constraint, the label must be the sender.
 
 @code
 
 label.fontSize = view.layoutHeight // sets viewA's baseline to match that of viewB
 
 @endcode
 
 @see https://github.com/JadenGeller/JGLayoutDotSyntax for more information.
 
	*/
	var fontSize: AnyObject! {
		get {
			return parameter
		}
		set {
			if newValue == nil {
				parameter = nil
			} else if let fontSizeMultiplier = newValue as? JGLayoutParameter {
				if (fontSizeMultiplier.attribute == .width) || (fontSizeMultiplier.attribute == .height) {
					parameter = fontSizeMultiplier
				}
			} else if let fontSizeMultiplier = newValue as? Double {
				font = font.withSize(font.pointSize * CGFloat(fontSizeMultiplier))
			}
		}
	}
	
	var parameter: JGLayoutParameter! {
		willSet {
			guard let p = parameter,
				let view = p.object as? UIView else { return }
			view.layer.removeObserver(self, forKeyPath: "bounds")
		}
		didSet {
			guard let p = parameter,
				let view = p.object as? UIView else { return }
			view.layer.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
		}
	}
	
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard let keyPath = keyPath,
			let p = parameter,
			let view = p.object as? UIView,
			let viewObject = object as? CALayer else { return }
		if (viewObject == view.layer) && (keyPath == "bounds") {
			var size: CGFloat = 0.0
			switch p.attribute {
			case .width:
				size = view.bounds.size.width
			case .height:
				size = view.bounds.size.height
			default:
				break
			}
			font = font.withSize(size * CGFloat(p.multiplier) + CGFloat(p.constant))
		}
	}
	
}
