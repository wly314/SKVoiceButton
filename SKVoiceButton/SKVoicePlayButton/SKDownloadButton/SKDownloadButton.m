//
//  SKDownloadButton.m
//  Vickey_NCE
//
//  Created by Leou on 16/5/25.
//  Copyright © 2016年 网赢天下. All rights reserved.
//

#import "SKDownloadButton.h"

@implementation SKDownloadButton

@synthesize skHandler = _skHandler;

@synthesize skVoiceTime = _skVoiceTime;

@synthesize skSelected = _skSelected;

@synthesize isCanPlay = _isCanPlay;

- (instancetype)initWithVoiceTime:(NSInteger)skVoiceTime handler:(SKButtonHandler)skHandler {
    
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //设置回调绑定
        self.skHandler = skHandler;
        
        _skSelected = NO;
        skCurrentTime = 0;
        
        _skVoiceTime = skVoiceTime;
    }
    
    return self;
}

- (void)setIsRight:(BOOL)isRight {
    
    _isRight = isRight;
    
    [self initPlayBtnSubviews];
}

#pragma mark - 播放按钮
/** 初始化 */
- (void)initPlayBtnSubviews {
    
    /** 
     *  设置播放按钮长度
     *      最长150距离 最小50
     *      小于5s 大于100s都固定不再增减
     */
    CGFloat wConstant = 0;
    if (_skVoiceTime < 5) {
        
        wConstant = 50;
    }else if (_skVoiceTime < 100) {
        wConstant = 50 + _skVoiceTime;
    }else {
        wConstant = 150;
    }
    
    if (_isRight) {
        
        /** 播放动画的图片 */
        animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"recode_1_right"], [UIImage imageNamed:@"recode_2_right"], [UIImage imageNamed:@"recode_3_right"], nil];
        skButton = [UIButton buttonWithType:UIButtonTypeCustom];
        skButton.translatesAutoresizingMaskIntoConstraints = NO;
        skButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        /** 此处之所以设置负值，是因为在Button上同时设置title和image时，默认image在title左侧，那么设置水平居右时，image的默认偏移的位置是距离＋title的宽度，所以设置的时候要减去title的宽度 */
        skButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
        [skButton setImage:[UIImage imageNamed:@"recode_3_right"] forState:UIControlStateNormal];
        skButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        [skButton setTitle:[NSString stringWithFormat:@"%ld\"", _skVoiceTime] forState:UIControlStateNormal];
        skButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [skButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        skButton.backgroundColor = [UIColor grayColor];
        skButton.layer.cornerRadius = (45.0/2)/2;
        [self addSubview:skButton];
        [self constraintItem:skButton toItem:self topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:0 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:wConstant heightMultiplier:1 height:-5];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:skButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        activityIndicatorView.hidesWhenStopped = YES;
        [skButton addSubview:activityIndicatorView];
        [self constraintItem:activityIndicatorView toItem:skButton topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:0 leftConstant:0 rightMultiplier:1 rightConstant:-5 widthMultiplier:0 width:45.0/2 heightMultiplier:0 height:45.0/2];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:skButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
    }else {
        
        /** 播放动画的图片 */
        animationImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"recode_1"], [UIImage imageNamed:@"recode_2"], [UIImage imageNamed:@"recode_3"], nil];
        skButton = [UIButton buttonWithType:UIButtonTypeCustom];
        skButton.translatesAutoresizingMaskIntoConstraints = NO;
        skButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [skButton setImage:[UIImage imageNamed:@"recode_3"] forState:UIControlStateNormal];
        skButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        skButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [skButton setTitle:[NSString stringWithFormat:@"%ld\"", _skVoiceTime] forState:UIControlStateNormal];
        skButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [skButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        skButton.backgroundColor = [UIColor grayColor];
        skButton.layer.cornerRadius = (45.0/2)/2;
        [self addSubview:skButton];
        
        [self constraintItem:skButton toItem:self topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:wConstant heightMultiplier:1 height:-5];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:skButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        activityIndicatorView.hidesWhenStopped = YES;
        [skButton addSubview:activityIndicatorView];
        
        [self constraintItem:activityIndicatorView toItem:skButton topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:1 leftConstant:5 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:45.0/2 heightMultiplier:0 height:45.0/2];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:skButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    
    /** 添加暂停动画通知 **/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer:) name:STOP_PLAYER_TIMER object:nil];
}

- (void)setPlayButtonBackgroundColor:(UIColor *)playButtonBackgroundColor {
    
    skButton.backgroundColor = playButtonBackgroundColor;
}

- (void)stopTimer:(NSNotification *)sender {
    
    /** 点击暂停计时结束，再次点击播放重新开始计时 */
    if (_timer) {
        
        dispatch_source_cancel(_timer);
    }
    UIView *currentPlayBtn = (UIView *)sender.object;
    if (currentPlayBtn != self) {
        
        /** 设置按钮选中状态 ＝ 设置播放器选中状态 NO */
        skButton.selected = NO;
        _skSelected = NO;
    }
}

/** 正在下载 改变按钮的指示 */
- (void)downloadNow {
    
    [activityIndicatorView startAnimating];
    
    [skButton setImage:[UIImage imageNamed:@"recode_noemal.png"] forState:UIControlStateNormal];
    [skButton setImage:[UIImage imageNamed:@"recode_noemal.png"] forState:UIControlStateSelected];
}

/** 下载完成 改变按钮的指示 */
- (void)downloadFinish {
    
    [activityIndicatorView stopAnimating];
    [skButton setImage:[animationImages objectAtIndex:2] forState:UIControlStateNormal];
}


/** button点击事件 */
- (void)playOrPause:(UIButton *)aBtn {
    
    if (!_isCanPlay) {
        
        return;
    }
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
    
    /** 每次跳转的时间 */
    CGFloat time = 0.5;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /** 定时器，全局的方便在外部销毁 */
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /** 每秒执行 1.0 * NSEC_PER_SEC, */
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), time * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if(currentTime > _skVoiceTime / time) {
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
                
                [skButton setImage:[animationImages objectAtIndex:skCurrentTime%animationImages.count] forState:UIControlStateSelected];
                
                currentTime ++;
            });
        }
    });
    dispatch_resume(_timer);
}

- (void)setSkSelected:(BOOL)skSelected {
    
    _skSelected = skSelected;
    
    skButton.selected = _skSelected;
}

- (void)setSkVoiceTime:(NSInteger)skVoiceTime {
    
    _skVoiceTime = skVoiceTime;
    
    [skButton setTitle:[NSString stringWithFormat:@"%ld\"", _skVoiceTime] forState:UIControlStateNormal];
    
    CGFloat wConstant = 0;
    if (_skVoiceTime < 5) {
        
        wConstant = 50;
    }else if (_skVoiceTime < 100) {
        wConstant = 50 + _skVoiceTime;
    }else {
        wConstant = 150;
    }
    
    NSArray *allConstrains = self.constraints;
    for (NSLayoutConstraint* constraint in allConstrains) {
        if (constraint.firstItem == skButton) {
            
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                
                constraint.constant = (wConstant);
            }
        }
    }
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
