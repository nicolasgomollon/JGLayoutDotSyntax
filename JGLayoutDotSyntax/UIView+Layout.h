//
//  UIView+Layout.h
//
//  Created by Jaden Geller on 11/29/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGDynamicConstraintObserver.h"

@class JGLayoutParameter, JGLayout;

@interface UIView (Layout) <JGDynamicConstraintObserverDelegate>

- (JGLayout *)layout;
- (void)removeLayoutConstraintsForAttribute:(NSLayoutAttribute)attribute;
- (void)addLayoutConstraintWithAttribute:(NSLayoutAttribute)attribute parameter:(id)theParameter;
- (JGDynamicConstraintObserver *)dynamicConstraintObserver;
- (void)setDynamicConstraintObserver:(JGDynamicConstraintObserver *)dynamicConstraintObserver;
- (BOOL)hasConstraintObserver;
- (void)updatedValue:(NSNumber *)value forConstraint:(NSLayoutConstraint *)constraint forMultiplier:(BOOL)useMultiplier;

@end
