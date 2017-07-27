//
//  SoundPlay.m
//  CoolClock
//
//  Created by socoolby on 22/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import "SoundPlay.h"

@implementation SoundPlay
static SoundPlay *_SoundPlay=nil;
+(instancetype)ShareSoundPlay{
    if(!_SoundPlay){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _SoundPlay=[[SoundPlay alloc]init];
            _SoundPlay.audioSession=[AVAudioSession sharedInstance];
            [_SoundPlay.audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
            [_SoundPlay.audioSession setActive:YES error:nil];
            
            _SoundPlay.NUM_AUDIO=[[NSMutableDictionary alloc]init ];
            [_SoundPlay.NUM_AUDIO setValue:@"n0" forKey:@"0"];
            [_SoundPlay.NUM_AUDIO setValue:@"n1" forKey:@"1"];
            [_SoundPlay.NUM_AUDIO setValue:@"n2" forKey:@"2"];
            [_SoundPlay.NUM_AUDIO setValue:@"n3" forKey:@"3"];
            [_SoundPlay.NUM_AUDIO setValue:@"n4" forKey:@"4"];
            [_SoundPlay.NUM_AUDIO setValue:@"n5" forKey:@"5"];
            [_SoundPlay.NUM_AUDIO setValue:@"n6" forKey:@"6"];
            [_SoundPlay.NUM_AUDIO setValue:@"n7" forKey:@"7"];
            [_SoundPlay.NUM_AUDIO setValue:@"n8" forKey:@"8"];
            [_SoundPlay.NUM_AUDIO setValue:@"n9" forKey:@"9"];
            [_SoundPlay.NUM_AUDIO setValue:@"n10" forKey:@"10"];
            [_SoundPlay.NUM_AUDIO setValue:@"n20" forKey:@"20"];
            [_SoundPlay.NUM_AUDIO setValue:@"n30" forKey:@"30"];
            [_SoundPlay.NUM_AUDIO setValue:@"n40" forKey:@"40"];
            [_SoundPlay.NUM_AUDIO setValue:@"n50" forKey:@"50"];
            [_SoundPlay.NUM_AUDIO setValue:@"n60" forKey:@"60"];
            
            _SoundPlay.WEEK_AUDIO=[[NSMutableDictionary alloc]init];
            [_SoundPlay.WEEK_AUDIO setValue:@"sunday" forKey:@"0"];
            [_SoundPlay.WEEK_AUDIO setValue:@"monday" forKey:@"1"];
            [_SoundPlay.WEEK_AUDIO setValue:@"tuesday" forKey:@"2"];
            [_SoundPlay.WEEK_AUDIO setValue:@"wednesday" forKey:@"3"];
            [_SoundPlay.WEEK_AUDIO setValue:@"thursday" forKey:@"4"];
            [_SoundPlay.WEEK_AUDIO setValue:@"friday" forKey:@"5"];
            [_SoundPlay.WEEK_AUDIO setValue:@"saturday" forKey:@"6"];
            
            
        });
    }
    return _SoundPlay;
}
-(void)playTick{
    [self playSound:@"tick"];
}
-(void)playList{
    
    if([_soundArray count]>0){
        SystemSoundID soundID;
        NSURL *filePath ;
        filePath= [[NSBundle mainBundle] URLForResource:[_soundArray objectAtIndex:0] withExtension: @"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        [_soundArray removeObjectAtIndex:0];
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
            [self playList];
        });
        
    }
}


-(void)reportTime:(NSUInteger)year withMonth:(NSInteger)month withDay:(NSInteger)day withHour:(NSInteger)hour \
withMinute:(NSInteger)minute withTody:(NSInteger)today
{
    _soundArray=[[NSMutableArray alloc]initWithObjects:@"todayis", nil];
    
    int monthTendigit=(int)(month/10*10);
    int monthUnit=month%10;
    if(monthTendigit>10)
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",monthTendigit]]];
    if(monthUnit>0)
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",monthUnit]]];
    [_soundArray addObject:@"month"];
    
    int dayTenDigit=(int)(day/10*10);
    int dayUnit=day%10;
    if(dayTenDigit>=10)
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",dayTenDigit]]];
    if(dayUnit>0)
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",dayUnit]]];
    [_soundArray addObject:@"day"];
    
    [_soundArray addObject:[_WEEK_AUDIO objectForKey:[NSString stringWithFormat:@"%d",(int)today-1]]];
    
    
    int hourUnit;
    if(hour>=20){
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",20]]];
        hourUnit=hour%20;
        if(hourUnit>0){
            [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",hourUnit]]];
        }
    }else if(hour>=10){
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",10]]];
        hourUnit=hour%10;
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",hourUnit]]];
    }else{
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",(int)hour]]];
    }
    [_soundArray addObject:@"hour"];
    
    int minuteTenDigit=(int)(minute/10*10);
    int minuteUnit=minute%10;
    if(minuteTenDigit>=10){
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",minuteTenDigit]]];
    }
    if((minuteTenDigit>=10 && minuteUnit!=0)||minuteTenDigit==0)
        [_soundArray addObject:[_NUM_AUDIO objectForKey:[NSString stringWithFormat:@"%d",minuteUnit]]];
    [_soundArray addObject:@"minute"];
    [self playList];
    
    
    
}
-(void)playSound:(NSString*)fileName
{
    SystemSoundID soundID;
    NSURL *filePath ;
    filePath= [[NSBundle mainBundle] URLForResource:fileName withExtension: @"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

@end
