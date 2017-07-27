//
//  SoundPlay.h
//  CoolClock
//
//  Created by socoolby on 22/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
@interface SoundPlay : NSObject
+(instancetype)ShareSoundPlay;
@property(strong) AVAudioSession *audioSession;
@property(strong) NSMutableArray *soundArray;
@property(strong) NSMutableDictionary *NUM_AUDIO;
@property(strong) NSMutableDictionary *WEEK_AUDIO;
-(void)playTick;
-(void)reportTime:(NSUInteger)year withMonth:(NSInteger)month withDay:(NSInteger)day withHour:(NSInteger)hour \
withMinute:(NSInteger)minute withTody:(NSInteger)today;
-(void)playSound:(NSString*)fileName;
@end
