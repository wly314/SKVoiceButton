## SKVoiceButton
Voice 音频播放按钮，计时
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

