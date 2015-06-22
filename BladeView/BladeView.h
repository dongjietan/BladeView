//
//  BladeView.h
//  BladeView
//
//  Created by Jay on 15/6/20.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGPointExtension.h"

@interface BladeView : UIView

@property (nonatomic, readonly) CGPoint *path;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, readonly) BOOL send;

@property (nonatomic, readonly) BOOL animating;
@property (nonatomic, assign) NSInteger animationFrameInterval;

- (void)startAnimation;
- (void)stopAnimation;

@end
