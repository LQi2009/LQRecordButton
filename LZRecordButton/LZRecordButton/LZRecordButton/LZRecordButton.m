//
//  LZRecordButton.m
//  LZRecordButton
//
//  Created by Artron_LQQ on 2017/2/14.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "LZRecordButton.h"

@interface LZRecordButton () {
    
    BOOL __isPressed;
    BOOL __isCancel;
    BOOL __isTimeOut;
    CGFloat __progress;
    NSTimeInterval __tempInterval;
    CGRect __circleFrame;
}

@property (nonatomic, strong) CAShapeLayer *centerLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) recordBlock record;
@end
@implementation LZRecordButton
- (void)actionWithBlock:(recordBlock)block {
    
    self.record = block;
}

- (void)dealloc {
    
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        __isPressed = NO;
        __isCancel = NO;
        __isTimeOut = NO;
        __progress = 0.0;
        __tempInterval = 0;
        _style = LZRecordButtonStyleWhite;
        _interval = 10;
        self.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}
- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.record) {
        self.record(LZRecordButtonStateClick);
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            [self link];
            __isPressed = YES;
            if (self.record) {
                self.record(LZRecordButtonStateBegin);
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [gesture locationInView:self];
            if (CGRectContainsPoint(__circleFrame, point)) {
                __isCancel = NO;
                if (self.record) {
                    self.record(LZRecordButtonStateMoving);
                }
            } else {
                __isCancel = YES;
                if (self.record) {
                    self.record(LZRecordButtonStateWillCancel);
                }
            }
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            
            __isCancel = YES;
            if (self.record) {
                self.record(LZRecordButtonStateDidCancel);
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
         
            if (__isCancel) {
                
                if (self.record) {
                    self.record(LZRecordButtonStateDidCancel);
                }
            } else if(!__isTimeOut){
                
                if (self.record) {
                    self.record(LZRecordButtonStateEnd);
                }
            }
            
            __isTimeOut = NO;
            [self stop];
            [self setNeedsDisplay];
        }
            break;
            
        default:
            break;
    }
}

- (void)beginRun:(CADisplayLink *)link {
    
    __tempInterval += 1/60.0;
    __progress = __tempInterval/self.interval;
    
    if (__tempInterval >= self.interval) {
        
        __isTimeOut = YES;
        if (self.record) {
            self.record(LZRecordButtonStateEnd);
        }
        [self stop];
    }
    
    [self setNeedsDisplay];
    
    NSLog(@">>>>>%f", __progress);
}

- (void)stop {
    
    [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.link invalidate];
    self.link = nil;
    
    __isPressed = NO;
    __isCancel = NO;
    __tempInterval = 0;
    __progress = 0;
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer = nil;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    CGFloat mainWidth = width * 0.5;
    CGRect mainFrame = CGRectMake(mainWidth/2.0, mainWidth/2.0, mainWidth, mainWidth);
    
    CGRect circleFrame = CGRectInset(mainFrame, -0.2*mainWidth/2.0, -0.2*mainWidth/2.0);
    if (__isPressed) {
        circleFrame = CGRectInset(mainFrame, -0.4*mainWidth/2.0, -0.4*mainWidth/2.0);
    }
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleFrame cornerRadius:CGRectGetWidth(circleFrame)/2.0];
    
    self.circleLayer.path = circlePath.CGPath;
    
    
    if (__isPressed) {
        
        mainWidth *= 0.8;
        mainFrame = CGRectMake((width - mainWidth)/2.0, (width - mainWidth)/2.0, mainWidth, mainWidth);
    }
    
    UIBezierPath *mainPath = [UIBezierPath bezierPathWithRoundedRect:mainFrame cornerRadius:mainWidth/2.0];
    self.centerLayer.path = mainPath.CGPath;
    
    
    if (__isPressed) {
        
        CGRect progressFrame = CGRectInset(circleFrame, 2.0, 2.0);
        
        UIBezierPath *progressPath = [UIBezierPath bezierPathWithRoundedRect:progressFrame cornerRadius:CGRectGetWidth(progressFrame)/2.0];
        self.progressLayer.path = progressPath.CGPath;
        self.progressLayer.strokeEnd = __progress;
        
        __circleFrame = progressFrame;
    }
}

- (void)setStyle:(LZRecordButtonStyle)style {
    _style = style;
    
    switch (style) {
        case LZRecordButtonStyleWhite:
            self.centerLayer.fillColor = [UIColor whiteColor].CGColor;
            self.circleLayer.fillColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8].CGColor;
            break;
        case LZRecordButtonStyleGray:
            self.centerLayer.fillColor = [UIColor grayColor].CGColor;
            self.circleLayer.fillColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.6].CGColor;
            break;
        case LZRecordButtonStyleBlack:
            self.centerLayer.fillColor = [UIColor blackColor].CGColor;
            self.circleLayer.fillColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.6].CGColor;
            break;
        default:
            break;
    }
}

- (void)setCenterColor:(UIColor *)centerColor {
    _centerColor = centerColor;
    self.centerLayer.fillColor = centerColor.CGColor;
}

- (void)setRingColor:(UIColor *)ringColor {
    _ringColor = ringColor;
    self.circleLayer.fillColor = ringColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.progressLayer.strokeColor = progressColor.CGColor;
}
#pragma mark - getter
- (CAShapeLayer *)centerLayer {
    if (_centerLayer == nil) {
        
        _centerLayer = [CAShapeLayer layer];
        _centerLayer.frame = self.bounds;
        _centerLayer.fillColor = [UIColor whiteColor].CGColor;
        
        [self.layer addSublayer:_centerLayer];
    }
    
    return _centerLayer;
}

- (CAShapeLayer *)circleLayer {
    if (_circleLayer == nil) {
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.fillColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.8].CGColor;
        
        [self.layer addSublayer:_circleLayer];
    }
    
    return _circleLayer;
}

- (CAShapeLayer *)progressLayer {
    if (_progressLayer == nil) {
        _progressLayer = [CAShapeLayer layer];
        
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor colorWithRed:31/255.0 green:185/255.0 blue:34/255.0 alpha:1.0].CGColor;
        _progressLayer.lineWidth = 4;
        _progressLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_progressLayer];
    }
    
    return _progressLayer;
}

- (CADisplayLink *)link {
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(beginRun:)];
        _link.preferredFramesPerSecond = 60;
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return _link;
}
@end
