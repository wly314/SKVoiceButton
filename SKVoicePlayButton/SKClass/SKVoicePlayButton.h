//
//  SKVoicePlayButton.h
//  SKVoiceButton
//
//  Created by LeouWang on 16/5/4.
//  Copyright © 2016年 Duoqingjie. All rights reserved.
//

#import <UIKit/UIKit.h>

//BLOCK
/** 回调绑定, id obj是将自身传过去，传过去之后可以用来调用该类的方法 */
typedef void (^SKButtonHandler)(id obj, NSInteger currentTime);
typedef void (^SKComplete)(BOOL complete);

@interface SKVoicePlayButton : UIView {
    
    /*播放按钮*/
    UIButton            *skButton;
    /*计时器*/
    dispatch_source_t   _timer;
    /*计时器当前计算的时间， 通过SKButtonHandler回调可以传给外部使用*/
    NSInteger           skCurrentTime;
}

/** 在Button点击事件实现传self，可以将block绑定到button的点击事件上 */
@property (nonatomic, copy)SKButtonHandler skHandler;

/** 初始化方法，将block绑定到button的点击事件上 */
- (instancetype)initWithFrame:(CGRect)frame handler:(SKButtonHandler)skHandler;

/** 初始化方法，将block绑定到button的点击事件上 */
- (instancetype)initWithFrame:(CGRect)frame voiceTime:(NSInteger)skVoiceTime handler:(SKButtonHandler)skHandler;

/** 播放时长, 单位:s */
@property (nonatomic, assign)NSInteger  skVoiceTime;

/** 选中状态，用于区分播放还是暂停 */
@property (nonatomic, assign)BOOL       skSelected;

/** 暂停之后再次重新播放的时候，通过此方法传开始播放的时间位置(如从第10秒开始播放) */
- (void)playOfStartTime:(NSInteger)seconds complete:(SKComplete)complete;

@end
