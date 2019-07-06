//
//  JGLayoutParameter.swift
//  JGLayoutDotSyntax
//
//  Objective-C code Copyright (c) 2014 Jaden Geller. All rights reserved.
//  Swift adaptation Copyright (c) 2014 Nicolas Gomollon. All rights reserved.
//

import Foundation
import UIKit

typealias JGLP = JGLayoutParameter

class JGLayoutParameter: NSObject, JGLayoutConstruction {
	
	var object: AnyObject?
	var attribute: NSLayoutConstraint.Attribute
	var relation: NSLayoutConstraint.Relation
	var priority: UILayoutPriority
	var constant: Double
	var multiplier: Double
	
	override var description: String {
		return "<JGLayoutParameter; object = \(String(describing: object)); constant = \(constant); multiplier = \(multiplier)>"
	}
	
	/** Returns an initialized JGLayoutParameter with all its parameters set. */
	init(object: AnyObject?, attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, priority: UILayoutPriority, constant: Double, multiplier: Double) {
		self.object = object
		self.attribute = attribute
		self.relation = relation
		self.priority = priority
		self.constant = constant
		self.multiplier = multiplier
		super.init()
	}
	
	/** Returns an initialized JGLayoutParameter. */
	convenience override init() {
		self.init(object: nil, attribute: .notAnAttribute, relation: .equal, priority: .required, constant: 0.0, multiplier: 1.0)
	}
	
	/** Returns an initialized JGLayoutParameter with the constant set. It is not necessary to use this, however, as the JGLayoutConstruction protocol for the NSNumber class allows NSNumbers to be used as constant JGLayoutParameters.
 
 @param constant A Double representing the desired NSLayoutConstraint constant.
 
 @see https://github.com/JadenGeller/JGLayoutDotSyntax for more information.
 
	*/
	convenience init(_ constant: Double) {
		self.init()
		self.constant = constant
	}
	
	/** Returns an initialized JGLayoutParameter with the constant set. It is not necessary to use this, however, as the JGLayoutConstruction protocol for the NSNumber class allows NSNumbers to be used as constant JGLayoutParameters.
 
 @param number A number object (e.g. Double, Float, Int, NSNumber) representing the desired NSLayoutConstraint constant.
 
 @see https://github.com/JadenGeller/JGLayoutDotSyntax for more information.
 
	*/
	convenience init(number: NSNumber) {
		self.init(number.doubleValue)
	}
	
	/** Returns an initialized JGLayoutParameter with the object and attribute set. It is not necessary to use this, however, as the Layout category for the UIView class adds properties with getters that return JGLayoutParameters with the requested attributes.
 
 @param object An AnyObject representing the desired secondary view for the NSLayoutConstraint.
 @param attribute A NSLayoutAttribute representing the desired NSLayoutConstraint relationship.
 
 @see https://github.com/JadenGeller/JGLayoutDotSyntax for more information.
 
	*/
	convenience init(object: AnyObject, attribute: NSLayoutConstraint.Attribute) {
		self.init()
		self.object = object
		self.attribute = attribute
	}
	
	subscript(priority: UILayoutPriority) -> JGLayoutParameter {
		self.priority = priority
		return self
	}
	
	func withRelation(_ relation: NSLayoutConstraint.Relation) -> JGLayoutParameter {
		self.relation = relation
		return self
	}
	
}

extension JGLayoutParameter: NSCopying {
	
	func copy(with zone: NSZone?) -> Any {
		return JGLayoutParameter(object: object, attribute: attribute, relation: relation, priority: priority, constant: constant, multiplier: multiplier)
	}
	
}


extension Double {
	
	var layoutParameter: JGLayoutParameter {
		return JGLayoutParameter(self)
	}
	
	func withRelation(_ relation: NSLayoutConstraint.Relation) -> JGLayoutParameter {
		return layoutParameter.withRelation(relation)
	}
	
}

extension Float {
	
	var layoutParameter: JGLayoutParameter {
		return JGLayoutParameter(Double(self))
	}
	
	func withRelation(_ relation: NSLayoutConstraint.Relation) -> JGLayoutParameter {
		return layoutParameter.withRelation(relation)
	}
	
}

extension Int {
	
	var layoutParameter: JGLayoutParameter {
		return JGLayoutParameter(Double(self))
	}
	
	func withRelation(_ relation: NSLayoutConstraint.Relation) -> JGLayoutParameter {
		return layoutParameter.withRelation(relation)
	}
	
}

extension NSNumber {
	
	var layoutParameter: JGLayoutParameter {
		return JGLayoutParameter(self.doubleValue)
	}
	
	func withRelation(_ relation: NSLayoutConstraint.Relation) -> JGLayoutParameter {
		return layoutParameter.withRelation(relation)
	}
	
}



func + (left: JGLayoutParameter, right: Double) -> JGLayoutParameter {
	let parameter = left.copy() as! JGLayoutParameter
	parameter.constant += right
	return parameter
}

func + (left: JGLayoutParameter, right: Float) -> JGLayoutParameter {
	return left + Double(right)
}

func + (left: JGLayoutParameter, right: Int) -> JGLayoutParameter {
	return left + Double(right)
}

func + (left: JGLayoutParameter, right: Bool) -> JGLayoutParameter {
	return left + Double(right ? 1 : 0)
}

func + (left: JGLayoutParameter, right: CGFloat) -> JGLayoutParameter {
	return left + Double(right)
}

func + (left: JGLayoutParameter, right: NSNumber) -> JGLayoutParameter {
	return left + right.doubleValue
}


func + (left: Double, right: JGLayoutParameter) -> JGLayoutParameter {
	return right + left
}

func + (left: Float, right: JGLayoutParameter) -> JGLayoutParameter {
	return right + left
}

func + (left: Int, right: JGLayoutParameter) -> JGLayoutParameter {
	return right + left
}

func + (left: Bool, right: JGLayoutParameter) -> JGLayoutParameter {
	return right + left
}

func + (left: CGFloat, right: JGLayoutParameter) -> JGLayoutParameter {
	return right + left
}

func + (left: NSNumber, right: JGLayoutParameter) -> JGLayoutParameter {
	return right + left
}


func - (left: JGLayoutParameter, right: Double) -> JGLayoutParameter {
	return left + -right
}

func - (left: JGLayoutParameter, right: Float) -> JGLayoutParameter {
	return left + -Double(right)
}

func - (left: JGLayoutParameter, right: Int) -> JGLayoutParameter {
	return left + -Double(right)
}

func - (left: JGLayoutParameter, right: Bool) -> JGLayoutParameter {
	return left + -Double(right ? 1 : 0)
}

func - (left: JGLayoutParameter, right: CGFloat) -> JGLayoutParameter {
	return left + -Double(right)
}

func - (left: JGLayoutParameter, right: NSNumber) -> JGLayoutParameter {
	return left + -right.doubleValue
}



func += (left: JGLayoutParameter, right: Double) {
	left.constant += right
}

func += (left: JGLayoutParameter, right: Float) {
	left += Double(right)
}

func += (left: JGLayoutParameter, right: Int) {
	left += Double(right)
}

func += (left: JGLayoutParameter, right: Bool) {
	left += Double(right ? 1 : 0)
}

func += (left: JGLayoutParameter, right: CGFloat) {
	left += Double(right)
}

func += (left: JGLayoutParameter, right: NSNumber) {
	left += right.doubleValue
}


func -= (left: JGLayoutParameter, right: Double) {
	left.constant -= right
}

func -= (left: JGLayoutParameter, right: Float) {
	left -= Double(right)
}

func -= (left: JGLayoutParameter, right: Int) {
	left -= Double(right)
}

func -= (left: JGLayoutParameter, right: Bool) {
	left -= Double(right ? 1 : 0)
}

func -= (left: JGLayoutParameter, right: CGFloat) {
	left -= Double(right)
}

func -= (left: JGLayoutParameter, right: NSNumber) {
	left -= right.doubleValue
}



func * (left: JGLayoutParameter, right: Double) -> JGLayoutParameter {
	let parameter = left.copy() as! JGLayoutParameter
	parameter.multiplier = right
	return parameter
}

func * (left: JGLayoutParameter, right: Float) -> JGLayoutParameter {
	return left * Double(right)
}

func * (left: JGLayoutParameter, right: Int) -> JGLayoutParameter {
	return left * Double(right)
}

func * (left: JGLayoutParameter, right: Bool) -> JGLayoutParameter {
	return left * Double(right ? 1 : 0)
}

func * (left: JGLayoutParameter, right: CGFloat) -> JGLayoutParameter {
	return left * Double(right)
}

func * (left: JGLayoutParameter, right: NSNumber) -> JGLayoutParameter {
	return left * right.doubleValue
}


func * (left: Double, right: JGLayoutParameter) -> JGLayoutParameter {
	return right * left
}

func * (left: Float, right: JGLayoutParameter) -> JGLayoutParameter {
	return right * left
}

func * (left: Int, right: JGLayoutParameter) -> JGLayoutParameter {
	return right * left
}

func * (left: Bool, right: JGLayoutParameter) -> JGLayoutParameter {
	return right * left
}

func * (left: CGFloat, right: JGLayoutParameter) -> JGLayoutParameter {
	return right * left
}

func * (left: NSNumber, right: JGLayoutParameter) -> JGLayoutParameter {
	return right * left
}



func *= (left: JGLayoutParameter, right: Double) {
	left.multiplier = right
}

func *= (left: JGLayoutParameter, right: Float) {
	left *= Double(right)
}

func *= (left: JGLayoutParameter, right: Int) {
	left *= Double(right)
}

func *= (left: JGLayoutParameter, right: Bool) {
	left *= Double(right ? 1 : 0)
}

func *= (left: JGLayoutParameter, right: CGFloat) {
	left *= Double(right)
}

func *= (left: JGLayoutParameter, right: NSNumber) {
	left *= right.doubleValue
}
