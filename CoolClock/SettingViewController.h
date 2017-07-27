//
//  SettingViewController.h
//  CoolClock
//
//  Created by socoolby on 23/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Func.h"
#include "DLRadioButton/DLRadioButton.h"
#import "ActionSheetPicker.h"
@interface SettingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwitch *PlayTick;
@property (strong, nonatomic) IBOutlet UITextField *motoText;
@property (strong, nonatomic) IBOutlet UITextField *weather;
@property (strong, nonatomic) IBOutlet UITextField *cityText;
@property (strong, nonatomic) IBOutlet UITextField *timeReportExceptText;
@property (nonatomic,strong) IBOutlet DLRadioButton *timeReportHalfAnHour;
@property (nonatomic,strong) IBOutlet DLRadioButton *timeReportHours;
@property (nonatomic,strong) IBOutlet DLRadioButton *timeReportNoReport;
@property (nonatomic, copy) void (^didDismiss)(NSString *data);
@property(nonatomic,strong)NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSArray *sections;

@property (nonatomic,strong) NSArray *selections;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,copy) NSString *pushAddress;
@property (nonatomic,strong) NSString *reportTimeStart;
@property (nonatomic,strong) NSString *reportTimeEnd;

-(IBAction)saveListener:(id)sender;
-(IBAction)aboutListener:(id)sender;
-(IBAction)regionSelect:(id)sender;
-(IBAction)switchPlayTickListner:(id)sender;
-(IBAction)mottoTextChangeListner:(id)sender;
-(IBAction)onRadioBtn:(id)sender;


-(IBAction)cityTouchDown:(id)sender;
-(IBAction)timeReportExceptTouchDown:(id)sender;
@end
