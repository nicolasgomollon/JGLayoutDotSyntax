//
//  UIView+Layout.m
//
//  Created by Jaden Geller on 11/29/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import "UIView+Layout.h"
#import "JGLayoutParameter.h"
#import "JGLayout.h"
#import "JGDynamicSizeLabel.h"
#import "JGDynamicConstraint.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic) JGDynamicConstraintObserver *dynamicConstraintObserver;

@end

@implementation UIView (Layout)

- (JGLayout *)layout {
    return [[JGLayout alloc] initWithObject:self];
}

#pragma mark - Adding Constraint

- (void)removeLayoutConstraintsForAttribute:(NSLayoutAttribute)attribute {
    
    if ([self hasConstraintObserver]) [self.dynamicConstraintObserver stopUpdatingConstraintWithAttribute:attribute];

    UIView *view = self;
    
    // Remove all constraints relating to self and attribute from all superviews of self
    do {
        for (NSLayoutConstraint *constraint in view.constraints) {
            if (([constraint.firstItem isEqual:self] && constraint.firstAttribute == attribute) || ([constraint.secondItem isEqual:self] && constraint.secondAttribute == attribute)) {
                [view removeConstraint:constraint];
            }
        }
        view = view.superview;
    } while (view.superview);
}

// parameter argument may be either a JGLayoutParameter or a NSNumber
- (void)addLayoutConstraintWithAttribute:(NSLayoutAttribute)attribute parameter:(id)theParameter {
    
    //[self removeLayoutConstraintsForAttribute:attribute];
    
    // if they were just setting it to nil, we are done here
    if (!theParameter) {
        return;
    }
    
    JGLayoutParameter *parameter;
    
    //Checks class of parameter input
    if ([theParameter isKindOfClass:[JGLayoutParameter class]]) {
        parameter = (JGLayoutParameter*)theParameter;
    }
    else if ([theParameter isKindOfClass:[NSNumber class]]) {
        // Creates a JGLayoutParameter out of NSNumber input
        parameter = [JGLayoutParameter constant:[(NSNumber *)theParameter floatValue]];
    }
    else {
        [NSException raise:@"Bad parameter input" format:@"Parameter input must be either a NSNumber or a JGLayoutParameter or a dynamic constraint."];
    }
    
    // Gets pointer to the view to which the NSLayoutConstraint should be added
    UIView *receiver = parameter.object?[UIView nearestCommonView:@[self,parameter.object]]:self;
    
    // Creates constraint
    NSLayoutConstraint *constraint;
    if (parameter.object) constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:parameter.relation toItem:parameter.object attribute:parameter.attribute multiplier:parameter.currentMultiplier constant:parameter.currentConstant];
    else constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:attribute multiplier:0 constant:parameter.currentConstant];
    
    // Sets priority, if specified
    if (parameter.priority) constraint.priority = parameter.priority;
    
    // Adds constraint
    [receiver addConstraint:constraint];
    
    // Add dynamic constraints
    if ([parameter.constant isKindOfClass:[JGDynamicConstraint class]]) {
        [self.dynamicConstraintObserver startUpdatingConstraint:constraint withDynamicConstraint:parameter.constant forMultiplier:NO];
    }
    if ([parameter.multiplier isKindOfClass:[JGDynamicConstraint class]]) {
        [NSException raise:@"Not yet supported" format:@"Support for dynamic multipliers has not yet been implemented."];
        [self.dynamicConstraintObserver startUpdatingConstraint:constraint withDynamicConstraint:parameter.multiplier forMultiplier:YES];
    }

}

+ (UIView *)nearestCommonView:(NSArray *)views {
    int closestView = INT_MAX;
    for (UIView *view in views) {
        closestView = MIN(closestView, [view displacementFromTopOfHeirachy]);
    }
    
    NSMutableArray *slice = [NSMutableArray array];
    for (UIView *view in views) {
        [slice addObject:[view viewWithDisplacementFromTopOfHeirachy:closestView]];
    }
    
    while (![UIView allObjectsInArrayAreEqual:slice]) {
        for (int i = 0; i < slice.count; i++) {
            slice[i] = [slice[i] superview];
        }
    }
    return slice[0]; //all equal or all nil
}

+ (BOOL)allObjectsInArrayAreEqual:(NSArray *)array {
    BOOL returnValue = YES;
    NSObject *firstObject = array[0];
    for (int i = 1; i < array.count && returnValue; i++) {
        returnValue = [array[i] isEqual:firstObject];
    }
    return returnValue;
}

- (UIView *)viewWithDisplacementFromTopOfHeirachy:(int)displacement {
    return [self superviewOfOrder:[self displacementFromTopOfHeirachy]-displacement];
}

- (UIView *)superviewOfOrder:(int)order {
    UIView *view = self;
    for (int i = 0; i < order; i++) {
        view = [view superview];
    }
    return view;
}

- (int)displacementFromTopOfHeirachy {
    int count = 0;
    for (UIView *i = [self superview]; i; i = [i superview]) {
        count++;
    }
    return count;
}

- (JGDynamicConstraintObserver *)dynamicConstraintObserver {
    JGDynamicConstraintObserver *observer = objc_getAssociatedObject(self, @selector(dynamicConstraintObserver));
    if (!observer) {
        observer = [[JGDynamicConstraintObserver alloc]init];
        observer.delegate = self;
        self.dynamicConstraintObserver = observer;
    }
    return observer;
}

- (void)setDynamicConstraintObserver:(JGDynamicConstraintObserver *)dynamicConstraintObserver {
    objc_setAssociatedObject(self, @selector(dynamicConstraintObserver), dynamicConstraintObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasConstraintObserver {
    return objc_getAssociatedObject(self, @selector(dynamicConstraintObserver)) != nil;
}

- (void)updatedValue:(NSNumber *)value forConstraint:(NSLayoutConstraint *)constraint forMultiplier:(BOOL)useMultiplier {
    if (useMultiplier){
        
    }
    else constraint.constant = value.doubleValue;
}

@end
