//
//  SKDownloadButton.h
//  Vickey_NCE
//
//  Created by Leou on 16/5/25.
//  Copyright © 2016年 网赢天下. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 停止播放时间 播放动画 用于在外部有多个播放按钮时，只允许一个按钮在播放状态 */
#define STOP_PLAYER_TIMER @"OTHER_BUTTON_PLAY_NOW"

//BLOCK
/** 回调绑定, id obj是将自身传过去，传过去之后可以用来调用该类的方法 */
typedef void (^SKButtonHandler)(id obj, NSInteger currentTime);
typedef void (^SKComplete)(BOOL complete);

@interface SKDownloadButton : UIView {
    
    /*播放按钮*/
    UIButton            *skButton;
    /*计时器*/
    dispatch_source_t   _timer;
    /*计时器当前计算的时间， 通过SKButtonHandler回调可以传给外部使用*/
    NSInteger           skCurrentTime;
    
    /**按钮图片**/
    NSArray *animationImages;
    
    /** 下载动画 */
    UIActivityIndicatorView *activityIndicatorView;
}

/** 在Button点击事件实现传self，可以将block绑定到button的点击事件上 */
@property (nonatomic, copy)SKButtonHandler skHandler;

/** 初始化方法，将block绑定到button的点击事件上 */
- (instancetype)initWithVoiceTime:(NSInteger)skVoiceTime handler:(SKButtonHandler)skHandler;

/** 播放时长, 单位:s */
@property (nonatomic, assign)NSInteger  skVoiceTime;

/** 选中状态，用于区分播放还是暂停 */
@property (nonatomic, assign)BOOL       skSelected;

#pragma mark - isCanPlay 必实现方法
/** 控制是否可以播放 例如外部音频下载失败则不可播放 */
@property (nonatomic, assign)BOOL       isCanPlay;

/**判断是否为右边播放*/
@property (nonatomic, assign)BOOL       isRight;

/** 暂停之后再次重新播放的时候，通过此方法传开始播放的时间位置(如从第10秒开始播放) */
- (void)playOfStartTime:(NSInteger)seconds complete:(SKComplete)complete;

/** 正在下载 改变按钮的指示 */
- (void)downloadNow;
/** 下载完成 改变按钮的指示 */
- (void)downloadFinish;


/** 播放器的背景颜色：如若需在外部设置则需要在isRight设置之后设置才生效 默认灰色 */
@property (nonatomic, strong)UIColor *playButtonBackgroundColor;

@end
