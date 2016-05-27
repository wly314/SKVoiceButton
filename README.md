## SKVoiceButton
![Alt text](https://github.com/wly314/SKVoiceButton/blob/master/ReadMeImage/Simulator%20Screen%20Shot%202016年5月27日%20下午4.23.02.png "Optional title")
Voice 音频播放按钮，计时
## SKVoicePlayButton
### 使用方法
    SKVoicePlayButton *oVoicePlayButton = [[SKVoicePlayButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40) handler:^(id obj, NSInteger currentTime) {
        
        SKVoicePlayButton *voiceBtn = (SKVoicePlayButton *)obj;
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
    
### 注意事项：在使用时候，页面销毁时候要主动销毁定时器：
/** 停止计时，在外部需要主动停止定时器时调用(如页面销毁时候) */
- (void)stopTime;

－－－－－－－－－－－

## SKDownloadButton
### 使用方法

```

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

```
### 注意事项：在使用时候，页面销毁时候要主动销毁定时器：
/** 停止计时，在外部需要主动停止定时器时调用(如页面销毁时候) **/

```
- (void)stopTime;
```

/** 
 *	播放器的背景颜色：
 *	如若需在外部设置则需要在isRight设置之后设置才生效 默认灰色 
 **/
 
 ```
 playButtonBackgroundColor//设置语音条颜色
 backgroundColor		   //设置播放器颜色
```

