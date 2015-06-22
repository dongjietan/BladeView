//
//  BladeView.m
//  BladeView
//
//  Created by Jay on 15/6/20.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "BladeView.h"

#define pt_count    16

void triangle(CGPoint* vertex, CGPoint p1, CGPoint p2, GLfloat w1);

@interface BladeView(){
    CGPoint path[pt_count];
    NSInteger _animationFrameInterval;
    NSTimeInterval timer;
}

@property (nonatomic, weak) CADisplayLink *displayLink;
@end

@implementation BladeView

- (CGPoint *)path{
    return path;
}

- (NSInteger)animationFrameInterval{
    return _animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval{
    if (frameInterval >= 1){
        _animationFrameInterval = frameInterval;
        
        if (_animating){
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation{
    if (!_animating){
        CADisplayLink *aDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:_animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        _animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (_animating){
        [self.displayLink invalidate];
        self.displayLink = nil;
        _animating = FALSE;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.backgroundColor = [UIColor grayColor];
    
    timer = 0.0;
    _animating = FALSE;
    _animationFrameInterval = 1;
    self.displayLink = nil;
}

- (void)easeNail {
    if (self.index < 4 && !self.send) {
        return;
    }
    
    if (self.index < 2) {
        return;
    }
    
    CGPoint *p = self.path;
    self.index--;
    
    memmove(p, &(p[1]), sizeof(CGPoint)*(self.index));
}

- (void)drawFrame
{
    NSTimeInterval dt = CACurrentMediaTime();
    
    if (self.send) {
        timer += dt;
        if (timer > 4) {
            timer = 0.0;
            [self easeNail];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // 画线
    if (self.index < 2) {
        return;
    }
    
    CGPoint *p = self.path;
    CGPoint vertex[1024] = {0.0};
//    memcpy(vertex, p, sizeof(CGPoint)*self.index);
    CGPoint pt = ccpSub(p[self.index-1], p[self.index-2]);
    GLfloat angle = ccpToAngle(pt);
    vertex[self.index-1].x += cosf(angle)*10;
    vertex[self.index-1].y += sinf(angle)*10;
    
    float w = (pt_count/(self.index-1)*0.5);
    vertex[0].x = p[self.index-1].x + cosf(angle)*10;
    vertex[0].y = p[self.index-1].y + sinf(angle)*10;
    GLint count = 1;
    for (NSUInteger i = (self.index-2); i>0; --i) {
        triangle(&(vertex[count]),p[i],p[i-1], w*i);
        count++;
    }
    vertex[count++] = p[0];
    
    for (NSUInteger i = 0; i < (self.index-2); ++i) {
        triangle(&(vertex[count]),p[i],p[i-1], -w*i);
        count++;
    }
    vertex[count++] = vertex[0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < 1024; i++) {
        CGPoint point = vertex[i];
        //            NSLog(@"index:%d point = %@",i,NSStringFromCGPoint(point));
        if (!CGPointEqualToPoint(point, CGPointZero)) {
            if (i == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            }
            else{
                CGContextAddLineToPoint(context, point.x, point.y);
            }
            
        }
    }

    // Set fill color
    CGContextSetRGBFillColor(context, (255/255.0), (255/255.0), (255/255.0), 1);
    
    // Fill it
    CGContextDrawPath(context, kCGPathFill);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _send = NO;
    _index = 0;
    memset(path, 0, sizeof(path));
    path[_index++] = [[touches anyObject] locationInView:self];
//    NSLog(@"point = %@",NSStringFromCGPoint(path[_index - 1]));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    GLfloat dis = ccpDistance(pt, path[_index-1]);
    if (dis < 2.0) {
        return;
    }
    
    if (_index < pt_count) {
        path[_index++] = pt;
//        NSLog(@"point = %@",NSStringFromCGPoint(path[_index - 1]));
    }
    else {
        memmove(path, &(path[1]), sizeof(CGPoint)*(pt_count-1));
        path[_index-1] = pt;
//        NSLog(@"point = %@",NSStringFromCGPoint(path[_index - 1]));
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _send = YES;
}

@end

void triangle(CGPoint* vertex, CGPoint p1, CGPoint p2, GLfloat w) {
    
    CGPoint pt = ccpSub(p1, p2);
    GLfloat angle = ccpToAngle(pt);
    
    GLfloat x = sinf(angle) * w;
    GLfloat y = cosf(angle) * w;
    vertex->x = p1.x+x;
    vertex->y = p1.y-y;
}
