//
//  ViewController.m
//  MyScrollView
//
//  Created by Alex Lee on 2017-06-12.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic)UIView *firstView;

@property (strong, nonatomic)MyScrollView *scroll;

@property (nonatomic)CGFloat x;

@property (nonatomic)CGFloat y;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //initialize the view to match the screen resolution of the iPhone 5
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 1136)];
    self.firstView = view;
    
    MyScrollView *scroll = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scroll];
    self.scroll = scroll;
    [scroll addSubview:view];
    
    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveWhenPanned:)];
    
    [self.scroll setUserInteractionEnabled:YES];
    [self.scroll addGestureRecognizer:panner];
    
    //match the size of the scroll's content to the frame of the view
    self.scroll.contentSize = CGSizeMake(640, 1136);
    
    
    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    red.backgroundColor = [UIColor redColor];
    [scroll addSubview:red];
    
    UIView *green = [[UIView alloc] initWithFrame:CGRectMake(150, 150, 150, 200)];
    green.backgroundColor = [UIColor greenColor];
    [scroll addSubview:green];
    
    UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(40, 400, 200, 150)];
    blue.backgroundColor = [UIColor blueColor];
    [scroll addSubview:blue];
    
    
    UIView *yellow = [[UIView alloc] initWithFrame:CGRectMake(100, 600, 180, 150)];
    yellow.backgroundColor = [UIColor yellowColor];
    [scroll addSubview:yellow];
    
}


- (void)moveWhenPanned:(UIPanGestureRecognizer *)panGestureRecognizer {
    //re-set the intermediate x and y values if the user just started panning
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.x = self.scroll.bounds.origin.x;
        self.y = self.scroll.bounds.origin.y;
    }
    
    CGPoint location = [panGestureRecognizer translationInView:self.firstView];
    
    CGRect newBounds = self.scroll.bounds;
    //tentatively set the new bounds to be the 'scroll' position, may be overwritten if the following conditions are met
    newBounds.origin.x = self.x - location.x;
    newBounds.origin.y = self.y - location.y;
    
    //prevent case where a 'scroll' would go above the initial y coordinates
    if ((self.y - location.y) < 0) {
        newBounds.origin.y = 0;
    }
    //prevent case where a 'scroll' would go below the y coordinates of the content
    if (((self.y - location.y) + self.scroll.frame.size.height) > self.scroll.contentSize.height) {
        newBounds.origin.y = self.scroll.contentSize.height - self.scroll.frame.size.height;
    }
    //prevent the user from 'scrolling' past the far left of the content
    if ((self.x - location.x) < 0) {
        newBounds.origin.x = 0;
    }
    //prevent the user from 'scrolling' past all of the content
    if (((self.x - location.x) + self.scroll.frame.size.width) > self.scroll.contentSize.width) {
        newBounds.origin.x = self.scroll.contentSize.width - self.scroll.frame.size.width;
    }
    //finally, set the scroll's bounds to be the determined bounds
    self.scroll.bounds = newBounds;
}


- (void)viewDidAppear:(BOOL)animated {
//    CGRect frame = self.view.bounds;
//    frame.origin.y += 100;
//    self.view.bounds = frame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
