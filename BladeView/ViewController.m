//
//  ViewController.m
//  BladeView
//
//  Created by Jay on 15/6/20.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "ViewController.h"
#import "BladeView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [(BladeView *)self.view startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
