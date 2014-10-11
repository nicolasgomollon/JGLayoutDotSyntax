//
//  JGViewController.m
//  LayoutDotSyntaxExample
//
//  Created by Jaden Geller on 11/30/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import "JGViewController.h"
#import "JGLayoutDotSyntax.h"
#import "NSObject+DynamicConstraint.h"

@interface JGViewController ()

@property (nonatomic) NSInteger value;

@end

@implementation JGViewController

- (void)viewDidLoad {
	_value = 20;
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
	
	UIView *blueView = [[UIView alloc]init];
	blueView.backgroundColor = [UIColor blueColor];
	blueView.translatesAutoresizingMaskIntoConstraints = NO;
	
	UIView *greenView = [[UIView alloc]init];
	greenView.backgroundColor = [UIColor greenColor];
	greenView.translatesAutoresizingMaskIntoConstraints = NO;
	
	UIView *yellowView = [[UIView alloc] init];
	yellowView.backgroundColor = [UIColor yellowColor];
	yellowView.translatesAutoresizingMaskIntoConstraints = NO;
	
	UIView *redView = [[UIView alloc] init];
	redView.backgroundColor = [UIColor redColor];
	redView.translatesAutoresizingMaskIntoConstraints = NO;

	UIView *purpleView = [[UIView alloc] init];
	purpleView.backgroundColor = [UIColor purpleColor];
	purpleView.translatesAutoresizingMaskIntoConstraints = NO;
	
	JGDynamicSizeLabel *label = [[JGDynamicSizeLabel alloc]init];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	label.text = @"Touch Me!";
	label.textAlignment = NSTextAlignmentCenter;

	[self.view addSubview:purpleView];
	[self.view addSubview:blueView];
	[self.view addSubview:greenView];
	[blueView addSubview:yellowView];
	[self.view addSubview:redView];
	[greenView addSubview:label];
	
	//Set up layout constraints using dot syntax
	
	float size = 40;
	float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	purpleView.layout.height = [self constraintForKeyPath:@"value"];
	purpleView.layout.width = [purpleView.layout.height add:@(10)];
	purpleView.layout.right = self.view.layout.right;
	purpleView.layout.top = [self.view.layout.top add:@(statusBarHeight)];
	
	blueView.layout.left = self.view.layout.left;
	blueView.layout.centerY = self.view.layout.centerY;
	blueView.layout.height = @(size);
	blueView.layout.width = @190;
	
	redView.layout.width = @(size);
	redView.layout.height = @(size);
	redView.layout.centerX = self.view.layout.centerX[JGLayoutPriorityDefaultHigh];
	redView.layout.centerY = self.view.layout.centerY;
	redView.layout.left = [[blueView.layout.right add:@(10)] withRelation:NSLayoutRelationGreaterThanOrEqual];
	
	CGFloat margin = 10;
	
	yellowView.layout.left = [blueView.layout.left add:@(margin)];
	yellowView.layout.right = [blueView.layout.right add:@(-margin)];
	yellowView.layout.top = [blueView.layout.top add:@(margin)];
	yellowView.layout.bottom = [blueView.layout.bottom add:@(-margin)];
	
	greenView.layout.bottom = self.view.layout.bottom;
	greenView.layout.height = [self.view.layout.height multiply:@.2];
	greenView.layout.left = self.view.layout.left;
	greenView.layout.right = self.view.layout.right;
	
	label.layout.alignment = greenView.layout.alignment;
	label.fontSize = [greenView.layout.height multiply:@.5];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.value += 10;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
