//
//  TodayViewController.m
//  BaoWidget
//
//  Created by phbz on 2024/3/22.
//  Copyright © 2024 phbz. All rights reserved.
//

#import "TodayViewController.h"

@interface TodayViewController() {
    AVAudioPlayer* mVoicePlayer;
    AVAudioPlayer* mEffectPlayer;
    AVAudioPlayer* mWinPlayer;
    NSURL* mVoicePlayURL;
    NSURL* mEffectPlayURL;
    NSURL* mWinPlayURL;
    dispatch_semaphore_t mSemaphore;
}

@property (weak) IBOutlet NSButton* mXiaobaoImageBtn;
@property (weak) IBOutlet NSButton* mLaobaoImageBtn;

@end

@implementation TodayViewController

@synthesize mXiaobaoImageBtn, mLaobaoImageBtn;

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Initialize the picture of Dabao and Xiaobao
    mXiaobaoImageBtn.image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForImageResource:kImageFileName(kXiaoBaoStr)]];
    
    mLaobaoImageBtn.image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForImageResource:kImageFileName(kLaoBaoStr)]];
    
    completionHandler(NCUpdateResultNoData);
}

- (void)setVoiceSoundURLWithName:(NSString*) name {
    int fRandValue;
    
    // Get random value.
    fRandValue = kRandomValue(0, 1);
    
    switch (fRandValue) {
        case 0:
            mVoicePlayURL = [[NSBundle mainBundle] URLForResource:kSoundFileName(name, 1) withExtension:kSoundFileExtStr];
            break;
        case 1:
            mVoicePlayURL = [[NSBundle mainBundle] URLForResource:kSoundFileName(name, 2) withExtension:kSoundFileExtStr];
            break;
        default:
            break;
    }
    
}

-(void)playSoundWithEffectName:(NSString*) name{
    mSemaphore = dispatch_semaphore_create(0);
    
    // Set audio player
    mVoicePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:mVoicePlayURL error:nil];
    
    mEffectPlayURL = [[NSBundle mainBundle] URLForResource:name withExtension:kSoundFileExtStr];
    
    mEffectPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:mEffectPlayURL error:nil];
    
    mWinPlayURL = [[NSBundle mainBundle] URLForResource:kWinStr withExtension:kSoundFileExtStr];
    
    mWinPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:mWinPlayURL error:nil];
    
    [mVoicePlayer prepareToPlay];
    
    [mEffectPlayer prepareToPlay];
    
    [mWinPlayer prepareToPlay];
    
    // Play voice and effect audio asynchronously.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->mVoicePlayer play];
        
        sleep(1);
        
        [self->mEffectPlayer play];
        
        do {
            continue;
        } while (self->mEffectPlayer.isPlaying == YES);
        
        dispatch_semaphore_signal(self->mSemaphore);
    });
    
    dispatch_semaphore_wait(mSemaphore, DISPATCH_TIME_FOREVER);
    
    // Play win audio asynchronously.
    [mWinPlayer play];
}

- (IBAction)playXiaoBaoSound:(id)sender {
    [self setVoiceSoundURLWithName:kXiaoBaoStr];
    
    [self playSoundWithEffectName:kDianKuangStr];
}


- (IBAction)playLaoBaoSound:(id)sender {
    [self setVoiceSoundURLWithName:kLaoBaoStr];
    
    [self playSoundWithEffectName:kWuShuangStr];
}

@end

