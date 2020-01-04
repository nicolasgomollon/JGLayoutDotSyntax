//
//  UIViewExtension.swift
//  JGLayoutDotSyntax
//
//  Objective-C code Copyright (c) 2014 Jaden Geller. All rights reserved.
//  Swift adaptation Copyright (c) 2014 Nicolas Gomollon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	var layout: JGLayout {
		return JGLayout(object: self)
	}
	
	func removeLayoutConstraintsForAttribute(_ attribute: NSLayoutConstraint.Attribute) {
		var view: UIView? = self
		
		// Remove all constraints relating to self and attribute from all superviews of self
		repeat {
			if let view: UIView = view {
				for constraint in view.constraints {
					let firstItem: UIView? = constraint.firstItem as? UIView
					let secondItem: UIView? = constraint.secondItem as? UIView
					if ((firstItem == self) && (constraint.firstAttribute == attribute)) ||
						((secondItem == self) && (constraint.secondAttribute == attribute)) {
							view.removeConstraint(constraint)
					}
				}
			}
			view = view?.superview
		} while view?.superview != nil
	}
	
	func addLayoutConstraintWithAttribute(_ attribute: NSLayoutConstraint.Attribute, parameter: AnyObject?) {
		removeLayoutConstraintsForAttribute(attribute)
		guard parameter != nil else { return }
		
		var layoutParameter: JGLayoutParameter!
		if let layoutParam: JGLayoutParameter = parameter as? JGLayoutParameter {
			layoutParameter = layoutParam
		} else if let constant: Double = parameter as? Double {
			layoutParameter = JGLayoutParameter(constant)
		}
		assert(layoutParameter != nil, "Bad parameter input: Parameter input must be either a JGLayoutParameter, NSNumber, Double, Float, or Int.")
		
		var receiver: UIView!
		var layoutConstraint: NSLayoutConstraint!
		
		if let object: UIView = layoutParameter.object as? UIView {
			receiver = nearestCommonView([self, object])
			
			layoutConstraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: layoutParameter.relation, toItem: object, attribute: layoutParameter.attribute, multiplier: CGFloat(layoutParameter.multiplier), constant: CGFloat(layoutParameter.constant))
		} else {
			receiver = self
			
			layoutConstraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: layoutParameter.relation, toItem: self, attribute: attribute, multiplier: 0.0, constant: CGFloat(layoutParameter.constant))
		}
		
		if layoutParameter.priority != .required {
			layoutConstraint.priority = layoutParameter.priority
		}
		
		receiver.addConstraint(layoutConstraint)
	}
	
}

// MARK: Private Helper Methods
private extension UIView {
	
	func nearestCommonView(_ views: [UIView]) -> UIView {
		var closestView: Int = .max
		for view in views {
			closestView = min(closestView, view.displacementFromTopOfHierarchy)
		}
		
		var slice: [UIView] = []
		for view in views {
			slice += [view.viewWithDisplacementFromTopOfHierarchy(closestView)]
		}
		
		while !UIView.allObjectsInArrayAreEqual(slice) {
			for i in 0..<slice.count {
				slice[i] = slice[i].superview!
			}
		}
		return slice[0]
	}
	
	class func allObjectsInArrayAreEqual(_ array: [NSObject]) -> Bool {
		var arrayGenerator: IndexingIterator<[NSObject]> = array.makeIterator()
		let firstObject: NSObject? = arrayGenerator.next()
		for object in arrayGenerator {
			if object != firstObject { return false }
		}
		return true
	}
	
	func viewWithDisplacementFromTopOfHierarchy(_ displacement: Int) -> UIView! {
		return superviewOfOrder(displacementFromTopOfHierarchy - displacement)
	}
	
	func superviewOfOrder(_ order: Int) -> UIView! {
		var view: UIView! = self
		for _ in 0..<order {
			view = view.superview
		}
		return view
	}
	
	var displacementFromTopOfHierarchy: Int {
		var count: Int = 0
		var i: UIView? = superview
		while i != nil {
			count += 1
			i = i?.superview
		}
		return count
	}
	
}
