//
//  LZRecordButton.h
//  LZRecordButton
//
//  Created by Artron_LQQ on 2017/2/14.
//  Copyright © 2017年 Artup. All rights reserved.
//
// 模仿微信小视频录制按钮

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LZRecordButtonStyle) {
    
    LZRecordButtonStyleWhite = 0,
    LZRecordButtonStyleGray ,
    LZRecordButtonStyleBlack ,
};

typedef NS_ENUM(NSInteger, LZRecordButtonState) {
    
    LZRecordButtonStateBegin = 0,// 开始长按
    LZRecordButtonStateMoving, // 移动
    LZRecordButtonStateWillCancel,// 将要取消
    LZRecordButtonStateDidCancel,// 已经取消
    LZRecordButtonStateEnd, // 正常结束
    
    LZRecordButtonStateClick, // 单击
};

typedef void(^recordBlock)(LZRecordButtonState state);
@interface LZRecordButton : UIView

/**
 计时时长
 */
@property (nonatomic, assign) NSTimeInterval interval;

/**
 按钮的样式, 预定义了三种颜色
 */
@property (nonatomic, assign) LZRecordButtonStyle style;

/**
 中间圆点的颜色
 */
@property (nonatomic, strong) UIColor *centerColor;

/**
 圆环的颜色
 */
@property (nonatomic, strong) UIColor *ringColor;

/**
 进度条的颜色
 */
@property (nonatomic, strong) UIColor *progressColor;

- (void)actionWithBlock:(recordBlock)block;
@end
