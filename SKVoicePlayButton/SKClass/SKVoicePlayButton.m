//
//  SKVoicePlayButton.m
//  SKVoiceButton
//
//  Created by LeouWang on 16/5/4.
//  Copyright © 2016年 Duoqingjie. All rights reserved.
//

#import "SKVoicePlayButton.h"

@implementation SKVoicePlayButton

@synthesize skHandler = _skHandler;

@synthesize skVoiceTime = _skVoiceTime;

@synthesize skSelected = _skSelected;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.layer.cornerRadius = 5;
        
        [self initPlayBtn];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame handler:(SKButtonHandler)skHandler {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.skHandler = skHandler;
        
        self.layer.cornerRadius = 5;
        
        [self initPlayBtn];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame voiceTime:(NSInteger)skVoiceTime handler:(SKButtonHandler)skHandler {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //设置回调绑定
        self.skHandler = skHandler;
        
        self.layer.cornerRadius = 5;
        
        _skVoiceTime = skVoiceTime;
        
        _skSelected = NO;
        _skVoiceTime = 0;
        skCurrentTime = 0;
        
        [self initPlayBtn];
    }
    
    return self;
}

#pragma mark - 播放按钮
/** 初始化 */
- (void)initPlayBtn {
    
    skButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skButton.translatesAutoresizingMaskIntoConstraints = NO;
    skButton.layer.cornerRadius = 5;
    [skButton setBackgroundImage:[UIImage imageNamed:@"newplayer_play.png"] forState:UIControlStateNormal];
    [skButton setBackgroundImage:[UIImage imageNamed:@"newplayer_pause.png"] forState:UIControlStateSelected];
    skButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    skButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [skButton setTitle:@"00:00" forState:UIControlStateNormal];
    [skButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skButton];
    
    [self setupPlayBtnConstraint:skButton];//设置约束
}

/** 设置约束 */
- (void)setupPlayBtnConstraint:(UIButton *)btn {
    
    [self constraintItem:btn toItem:self topMultiplier:1 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
}

/** button点击事件 */
- (void)playOrPause:(UIButton *)aBtn {
    
    /** 先进行回调，然后再进行设置seleted属性 */
    /** 设置回调绑定, 将自身传过去，传过去之后可以用来调用该类的方法 */
    _skHandler(self, skCurrentTime);
    
    aBtn.selected = !aBtn.selected;
    _skSelected = aBtn.selected;
    
    if (!aBtn.selected) {
        
        /** 点击暂停计时结束，再次点击播放重新开始计时 */
        if (_timer) {
            
            dispatch_source_cancel(_timer);
        }
    }
}

- (void)playOfStartTime:(NSInteger)seconds complete:(SKComplete)complete {
    
    /** complete(YES／NO)可以使内部时间与外部要进行的操作同时进行，比如内部时间变化同时，外部播放音乐 */
    complete(YES);
    
    [self skPlayButtonTimeAction:skButton startTime:seconds];
}

#pragma mark - 计时器
- (void)skPlayButtonTimeAction:(id)sender startTime:(NSInteger)walltime {
    
    __block NSInteger currentTime = walltime;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /** 定时器，全局的方便在外部销毁 */
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /** 每秒执行 1.0 * NSEC_PER_SEC, */
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        /*根据秒，计算要显示的时间*/
        NSInteger minutes = currentTime / 60;
        NSInteger seconds = currentTime % 60;
        
        if(currentTime > _skVoiceTime) {
            /*计时结束，关闭计时器。*/
            dispatch_source_cancel(_timer);
            /*
             *  计时结束，重置播放按钮（回主线程）。
             *      1.skButton设置非选中状态
             *      2._skSelected设置非选中状态
             *      3.skCurrentTime置为0
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                
                skButton.selected = NO;
                _skSelected = skButton.selected;
                skCurrentTime = 0;
            });
        }else {
            
            /*计时进行时，在主线程队列刷新UI，即设置展示的时间。*/
            dispatch_async(dispatch_get_main_queue(), ^{
                
                skCurrentTime = currentTime;
                [skButton setTitle:[NSString stringWithFormat:@"%.2ld:%.2ld", minutes, seconds] forState:UIControlStateNormal];
                
                currentTime ++;
            });
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 依赖于superView的约束
- (void)constraintItem:(id)view1 toItem:(id)view2 topMultiplier:(CGFloat)topMultiplier topConstant:(CGFloat)top bottomMultiplier:(CGFloat)bottomMultiplier bottomConstant:(CGFloat)bottom leftMultiplier:(CGFloat)leftMultiplier leftConstant:(CGFloat)left rightMultiplier:(CGFloat)rightMultiplier rightConstant:(CGFloat)right widthMultiplier:(CGFloat)widthMultiplier width:(CGFloat)width heightMultiplier:(CGFloat)heightMultiplier height:(CGFloat)height {
    
    if (top != 0 || topMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeTop
                             multiplier:topMultiplier
                             constant:top]];
    }
    
    if (bottom != 0 || bottomMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeBottom
                             multiplier:bottomMultiplier
                             constant:bottom]];
    }
    
    if (left != 0 || leftMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeLeft
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeLeft
                             multiplier:leftMultiplier
                             constant:left]];
    }
    
    if (right != 0 || rightMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeRight
                             multiplier:rightMultiplier
                             constant:right]];
    }
    
    if (widthMultiplier != 0 || width != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeWidth
                             multiplier:widthMultiplier
                             constant:width]];
    }
    
    if (heightMultiplier != 0 || height != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeHeight
                             multiplier:heightMultiplier
                             constant:height]];
    }
}

@end
