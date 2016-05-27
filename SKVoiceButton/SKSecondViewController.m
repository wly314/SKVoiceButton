//
//  SKSecondViewController.m
//  SKVoiceButton
//
//  Created by LeouWang on 16/5/5.
//  Copyright © 2016年 Duoqingjie. All rights reserved.
//

#import "SKSecondViewController.h"

#import <AVFoundation/AVAudioPlayer.h>

#import "SKDownloadButton.h"

/** Mp3下载回调 */
typedef void (^SKDownloadComplete)(NSURL *path);

@interface SKSecondViewController () {
    
    AVAudioPlayer       *_defaultPlayer;
}

@end

@implementation SKSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *mp3Path1 = @"http://img.tiantianshangke.com/cast/mp3/2/1.mp3";
//    NSString *mp3Path2 = @"http://img.tiantianshangke.com/cast/mp3/2/15.mp3";
//    NSString *mp3Path3 = @"http://img.tiantianshangke.com/cast/mp3/2/16.mp3";
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"morningexmp3" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:mp3Path];
    _defaultPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];//使用本地URL创建
    _defaultPlayer.numberOfLoops = 0;
    _defaultPlayer.volume = 0.8;//0.0-1.0之间
    [_defaultPlayer prepareToPlay];
    
    /**
     *  使用方法
     */
    SKDownloadButton *downLoadBtn = [[SKDownloadButton alloc] initWithVoiceTime:100 handler:^(id obj, NSInteger currentTime) {
        
        SKDownloadButton *voiceBtn = (SKDownloadButton *)obj;
        
        if (!voiceBtn.skSelected) {
            
            /** 开始下载 加载下载动画 */
            [voiceBtn downloadNow];
            
            /** 下载回复mp3 **/
            [self downloadMp3WithPath:mp3Path status:^(NSURL *path) {
                
                /** 下载完成 取消下载动画 */
                [voiceBtn downloadFinish];
                
                if (path) {
                    
                    /** 停止其他播放 */
                    if (_defaultPlayer) {
                        
                        [_defaultPlayer stop];
                    }
                    
                    /** 播放Mp3 设置按钮动画 **/
                    [_defaultPlayer play];
                    
                    /** 按钮播放动画 */
                    [voiceBtn playOfStartTime:0 complete:^(BOOL complete) {
                        /** 此处处理：当前按钮成功播放 停止其他按钮播放动画 */
                    }];
                }else {
                    voiceBtn.skSelected = NO;
                }
            }];
        }else {
            /*再次点击 停止播放*/
            if (_defaultPlayer) {
                
                [_defaultPlayer stop];
            }
        }
    }];
    downLoadBtn.frame = CGRectMake(10, 300, 300, 40);
    downLoadBtn.tag = 200001;
    downLoadBtn.backgroundColor = [UIColor greenColor];
    downLoadBtn.isCanPlay = YES;
    [self.view addSubview:downLoadBtn];
    
    downLoadBtn.isRight = 1;
    downLoadBtn.playButtonBackgroundColor = [UIColor grayColor];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(10, 200, 100, 40);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:backBtn];
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Download Reply MP3
- (void)downloadMp3WithPath:(NSString *)path status:(SKDownloadComplete)downloadPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    /** 逻辑：判断文件是否存在，存在的话不再下载，否则下载文件 */
    if (![fileManager fileExistsAtPath:path]) {
        
        
    }else {
        
        downloadPath([NSURL fileURLWithPath:path]);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
