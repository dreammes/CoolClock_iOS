//
//  ViewController.m
//  CoolClock
//
//  Created by socoolby on 19/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import "ViewController.h"
#include <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController
-(void)loadPerferenceData{
    
    isPlayTick=[userDefaults boolForKey:PERFERENCE_TICK];
    mottoText=[userDefaults valueForKey:PERFERENCE_MOTTO];
    timeReportType=[userDefaults integerForKey:PERFERENCE_TIME_REPORT_TYPE];
    city=[userDefaults valueForKey:PERFERENCE_CITY];
    if(city==nil){
        city=@"深圳市";
        [userDefaults setValue:@"广东省" forKey:PERFERENCE_PROVINCE];
        [userDefaults setValue:city forKey:PERFERENCE_CITY];
        [userDefaults setValue:@"12:31" forKey:PERFERENCE_TIMEREPORT_START];
        [userDefaults setValue:@"14:01" forKey:PERFERENCE_TIMEREPORT_END];
        [userDefaults setValue:@"Just do it" forKey:PERFERENCE_MOTTO];
        [userDefaults synchronize];
    }
    timeReportStart=[userDefaults valueForKey:PERFERENCE_TIMEREPORT_START];
    timeReportEnd=[userDefaults valueForKey:PERFERENCE_TIMEREPORT_END];
    [self getWeater];
    [descreptionLabel setText:mottoText];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viwDidLoad");
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    userDefaults =[NSUserDefaults standardUserDefaults];
    [self loadPerferenceData];
    [timeView setTextAlias:DN_ALIGH_CENTER];
    [timeView setBackgroundColor:[UIColor clearColor]];
    [timeView setFontColor:[UIColor whiteColor]];
    [timeView setFontSize:110];
    [timeView setFontPadding:8];
    [timeView setViewController:self];
    
    if(IS_IPHONE_5 || IS_IPHONE_4_OR_LESS){
        [timeView setFontSize:80];
    }else if(IS_IPHONE_6)
        [timeView setFontSize:100];
    else if(IS_IPHONE_6P)
        [timeView setFontSize:110];
    else
        [timeView setFontSize:75];
    
    soundPlay=[SoundPlay ShareSoundPlay];
    
    formatter=[[NSDateFormatter alloc]init];
    [descreptionLabel setText:mottoText];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:TRUE block:^(NSTimer * _Nonnull timer) {
        NSDate *now=[NSDate date];
        formatter.dateFormat=@"HH:mm:ss";
        NSString *timeString=[formatter stringFromDate:now];
        
        if([timeString characterAtIndex:0]=='1')
            timeString=[timeString stringByAppendingString:@" "];
        [timeView setContent:timeString];
        formatter.dateFormat=@"yyyy-MM-dd";
        NSString *dateString=[formatter stringFromDate:now];
        dateString=[dateString stringByReplacingOccurrencesOfString:@"1" withString:@" 1"];
        formatter.dateFormat=@"EE";
        NSString *dayString=[formatter stringFromDate:now];
        [dateLabel setText:dateString];
        [weekLable setText:dayString];
        
        formatter.dateFormat=@"yyyy";
        NSInteger year=[[formatter stringFromDate:now] integerValue];
        formatter.dateFormat=@"MM";
        NSInteger month=[[formatter stringFromDate:now] integerValue];
        formatter.dateFormat=@"dd";
        NSInteger day=[[formatter stringFromDate:now] integerValue];
        formatter.dateFormat=@"HH";
        int hour=(int)[[formatter stringFromDate:now] integerValue];
        formatter.dateFormat=@"mm";
        int minute=(int)[[formatter stringFromDate:now] integerValue];
        formatter.dateFormat=@"ss";
        NSInteger second=[[formatter stringFromDate:now] integerValue];
        formatter.dateFormat=@"e";
        NSInteger today=[[formatter stringFromDate:now] integerValue];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        if((minute==30||minute==0)&&second==0)
        {
            if((minute==30&&timeReportType==TR_HALF_AN_HOUR)||(timeReportType== TR_HOURS))
                if([self isReport:hour minute:minute]){
                    [soundPlay reportTime:year withMonth:month withDay:day withHour:hour withMinute:minute withTody:today];
                }
        }
        
        if(isPlayTick){
            [soundPlay playTick];
            
        }
    }];
    [self getWeater];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)getWeater{
    WeatherRequest *weatherRequest=[WeatherRequest shareNetworkTools];
    [weatherRequest getWeather:city WithBlock:^(NSString *todayWeatherString){
        NSLog(@"call Block back:%@",todayWeatherString);
        [weatherLable setText:todayWeatherString];
    }];
    
}
-(BOOL)isReport:(int)hour minute:(int)minutes{
    if([timeReportStart isEqualToString:timeReportEnd])
        return true;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat=@"HH:mm";
    NSDate *dateStart=[timeFormatter dateFromString:timeReportStart];
    NSDate *dateEnd=[timeFormatter dateFromString:timeReportEnd];
    NSDate *dateNow=[timeFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d",hour,minutes]];
    NSTimeInterval interval=[dateEnd timeIntervalSinceDate:dateStart];
    NSString *nowString=[NSString stringWithFormat:@"%02d:%02d",hour,minutes];
    NSString *info=[NSString stringWithFormat:@"start:%@ end:%@ now:%@",timeReportStart,timeReportEnd,nowString];
    NSLog(@"%@",info);
    NSLog(@"interval:%f",interval);
    if(interval>0){
        NSTimeInterval startInterval=[dateStart timeIntervalSinceDate:dateNow];
        NSTimeInterval endInterval=[dateEnd timeIntervalSinceDate:dateNow];
        NSLog(@"interval start:%f  End:%f",startInterval,endInterval);
        if(startInterval<=0 &&endInterval>=0)
            return false;
    }
    
    return true;
    
}
-(IBAction)ContainerTouch:(id)sender{
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
    [setting setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    setting.didDismiss = ^(NSString *data) {
        [self loadPerferenceData];
        NSLog(@"Dismissed SecondViewController");
    };
    [self presentViewController:setting animated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if(timer) {
        [timer invalidate];
        timer=nil;
    }
}
- (void)timeUpdate{
    
}
-(void)dealloc{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}



@end
