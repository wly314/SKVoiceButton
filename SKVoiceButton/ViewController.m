//
//  ViewController.m
//  SKVoiceButton
//
//  Created by LeouWang on 16/5/4.
//  Copyright © 2016年 Duoqingjie. All rights reserved.
//

#import "ViewController.h"

#import "SKVoicePlayButton.h"

#import <AVFoundation/AVAudioPlayer.h>

#import "SKSecondViewController.h"

@interface ViewController ()<AVAudioPlayerDelegate> {
    
    NSInteger           startTime;
    SKVoicePlayButton   *skVoicePlayButton;
    AVAudioPlayer       *_defaultPlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *mp4Path = [[NSBundle mainBundle] pathForResource:@"morningexmp3" ofType:@"mp3"];
    NSURL *url=[NSURL URLWithString:mp4Path];
    _defaultPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];//使用本地URL创建
    _defaultPlayer.delegate = self;
    _defaultPlayer.numberOfLoops = 0;
    _defaultPlayer.volume = 0.8;//0.0-1.0之间
    [_defaultPlayer prepareToPlay];
    
    
    /**
     *  使用方法
     */
    SKVoicePlayButton *oVoicePlayButton = [[SKVoicePlayButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40) handler:^(id obj, NSInteger currentTime) {
        
        SKVoicePlayButton *voiceBtn = (SKVoicePlayButton *)obj;
        /* 此处作为外部使用 在view销毁的时候用于销毁 */
        skVoicePlayButton = voiceBtn;
        if (!voiceBtn.skSelected) {
            
            [voiceBtn playOfStartTime:currentTime complete:^(BOOL complete) {
                if (complete) {
                    
                    [_defaultPlayer play];
                }
            }];
        }else {
            
            [_defaultPlayer pause];
        }
    }];
    oVoicePlayButton.backgroundColor = [UIColor clearColor];
    oVoicePlayButton.skVoiceTime = 91;
    [self.view addSubview:oVoicePlayButton];
    
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    jumpBtn.frame = CGRectMake(10, 200, 100, 40);
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [jumpBtn setTitle:@"Jump" forState:UIControlStateNormal];
    jumpBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:jumpBtn];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    /* 页面消失 停止计时 停止播放 */
    if (skVoicePlayButton) {
        
        [skVoicePlayButton pauseTime];
    }
    if (_defaultPlayer) {
        
        [_defaultPlayer pause];
    }
}

- (void)jump {
    
    SKSecondViewController *skSecVC = [[SKSecondViewController alloc] init];
    [self presentViewController:skSecVC animated:YES completion:^{
        
    }];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    //处理中断的代码
}

//audioPlayerEndInterruption:，当程序被应用外部打断之后，重新回到应用程序的时候触发。在这里当回到此应用程序的时候，继续播放音乐。
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
