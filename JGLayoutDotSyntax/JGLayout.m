//
//  JGLayout.m
//
//  Created by Jaden Geller on 8/26/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import "JGLayout.h"
#import "JGLayoutParameter.h"
#import "UIView+Layout.h"
#import <objc/runtime.h>

@implementation JGLayout

@synthesize left, right, top, bottom, leading, trailing, width, height, centerX, centerY, baseline, alignment, size, center;

- (id)init {
	return [self initWithObject:nil];
}

- (id)initWithObject:(id)_object {
	self = [super init];
	if (self) {
		// Initialization code
		object = _object;
	}
	return self;
}

#pragma mark - Getters

- (id)left {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeLeft];
}

- (id)right {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeRight];
}

- (id)top {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeTop];
}

- (id)bottom {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeBottom];
}

- (id)leading {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeLeading];
}

- (id)trailing {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeTrailing];
}

- (id)width {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeWidth];
}

- (id)height {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeHeight];
}

- (id)centerX {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeCenterX];
}

- (id)centerY {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeCenterY];
}

- (id)baseline {
    return [JGLayoutParameter layoutParameterWithObject:object attribute:NSLayoutAttributeBaseline];
}

#pragma mark - Setters

- (void)setLeft:(id)_left {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeLeft parameter:_left];
}

- (void)setRight:(id)_right {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeRight parameter:_right];
}

- (void)setTop:(id)_top {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeTop parameter:_top];
}

- (void)setBottom:(id)_bottom {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeBottom parameter:_bottom];
}

- (void)setLeading:(id)_leading {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeLeading parameter:_leading];
}

- (void)setTrailing:(id)_trailing {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeTrailing parameter:_trailing];
}

- (void)setWidth:(id)_width {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeWidth parameter:_width];
}

- (void)setHeight:(id)_height {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeHeight parameter:_height];
}

- (void)setCenterX:(id)_centerX {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeCenterX parameter:_centerX];
}

- (void)setCenterY:(id)_centerY {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeCenterY parameter:_centerY];
}

- (void)setBaseline:(id)_baseline {
    [(UIView *)object addLayoutConstraintWithAttribute:NSLayoutAttributeBaseline parameter:_baseline];
}

- (void)setAlignment:(NSArray *)_alignment {
    if (_alignment.count == 4) {
        for (JGLayoutParameter *parameter in _alignment) {
            switch (parameter.attribute) {
                case NSLayoutAttributeTop:
                    self.top = parameter;
                    break;
                    
                case NSLayoutAttributeBottom:
                    self.bottom = parameter;
                    break;
                    
                case NSLayoutAttributeLeft:
                    self.left = parameter;
                    break;
                    
                case NSLayoutAttributeRight:
                    self.right = parameter;
                    break;
                    
                case NSLayoutAttributeLeading:
                    self.leading = parameter;
                    break;
                    
                case NSLayoutAttributeTrailing:
                    self.trailing = parameter;
                    break;
                    
                default:
                    break;
            }
        }
    }
    else [NSException raise:@"Invalid alignment" format:@"Alignment array does not contain 4 objects"];
}

- (void)setSize:(NSArray *)_size {
    if (_size.count == 2) {
        for (JGLayoutParameter *parameter in _size) {
            switch (parameter.attribute) {
                case NSLayoutAttributeWidth:
                    self.width = parameter;
                    break;
                    
                case NSLayoutAttributeHeight:
                    self.height = parameter;
                    break;
                
                default:
                    break;
            }
        }
    }
    else [NSException raise:@"Invalid size" format:@"Size array does not contain 2 objects"];
}

- (void)setCenter:(NSArray *)_center {
    if (_center.count == 2) {
        for (JGLayoutParameter *parameter in _center) {
            switch (parameter.attribute) {
                case NSLayoutAttributeCenterX:
                    self.centerX = parameter;
                    break;
                    
                case NSLayoutAttributeCenterY:
                    self.centerY = parameter;
                    break;
                    
                default:
                    break;
            }
        }
    }
    else [NSException raise:@"Invalid center" format:@"Center array does not contain 2 objects"];
}

- (NSArray *)alignment {
    return @[self.top, self.bottom, self.left, self.right];
}

- (NSArray *)size {
    return @[self.width, self.height];
}

- (NSArray *)center {
    return @[self.centerX, self.centerY];
}

@end
