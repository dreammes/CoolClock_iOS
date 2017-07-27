//
//  ViewController.h
//  CoolClock
//
//  Created by socoolby on 19/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "WeatherRequest.h"
#include "SoundPlay.h"
#include "Func.h"
#include "SettingViewController.h"
#include "DigitNumber/DigitNumber.h"
#include "Toast/UIView+Toast.h"
#include "DigitNumberFont.h"
@interface ViewController : UIViewController
{
    IBOutlet UIView *container;
    IBOutlet DigitNumberFont *timeView;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *weatherLable;
    IBOutlet UILabel *weekLable;
    IBOutlet UILabel *descreptionLabel;
    NSTimer *timer;
    NSDateFormatter *formatter;
    BOOL isPlayTick;
    NSString *mottoText;
    NSString *city;
    NSInteger timeReportType;
    NSString *timeReportStart;
    NSString *timeReportEnd;
    NSUserDefaults *userDefaults;
    SoundPlay *soundPlay;
}
-(IBAction)ContainerTouch:(id)sender;
- (void)timeUpdate;
-(void)loadPerferenceData;
-(BOOL)isReport:(int)hour minute:(int)minutes;
@end

