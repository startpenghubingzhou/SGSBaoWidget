//
//  TodayViewController.h
//  BaoWidget
//
//  Created by phbz on 2024/3/22.
//  Copyright © 2024 phbz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <NotificationCenter/NotificationCenter.h>

// define string
#define kLaoBaoStr                              @"laobao"
#define kXiaoBaoStr                             @"xiaobao"
#define kWuShuangStr                            @"wushuang"
#define kDianKuangStr                           @"diankuangtulu"
#define kWinStr                                 @"win"
#define kSoundFileExtStr                        @"mp3"
#define kSoundFileName(name, num)               [[NSString alloc] initWithFormat:@"%@%d", name, num]
#define kImageFileName(name)                    [[NSString alloc] initWithFormat:@"%@.jpg", name]

// random value
#define kRandomValue(rangeSmall, rangeBig)      arc4random() % (rangeBig - rangeSmall + 1) + rangeSmall

@interface TodayViewController : NSViewController  <NCWidgetProviding>

@end
