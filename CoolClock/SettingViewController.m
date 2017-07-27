//
//  SettingViewController.m
//  CoolClock
//
//  Created by socoolby on 23/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import "SettingViewController.h"
#import <MJExtension.h>
#import "Func.h"
#include "AboutMe.h"
@interface SettingViewController ()<ActionSheetCustomPickerDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,strong) ActionSheetCustomPicker *picker;
@property(nonatomic,strong) NSMutableArray *timeArr;
@property(nonatomic,assign) BOOL IS_ReportTimeSelected;
@property (nonatomic,assign) NSInteger reportTimeStartIndex;
@property (nonatomic,assign) NSInteger reportTimeEndIndex;
@end

@implementation SettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults =[NSUserDefaults standardUserDefaults];
    
    [self.PlayTick setOn:[self.userDefaults boolForKey:PERFERENCE_TICK]];
    [self.motoText setText:[self.userDefaults valueForKey:PERFERENCE_MOTTO]];
    self.province=[self.userDefaults valueForKey:PERFERENCE_PROVINCE];
    self.city=[self.userDefaults valueForKey:PERFERENCE_CITY];
    self.reportTimeStart=[self.userDefaults valueForKey:PERFERENCE_TIMEREPORT_START];
    self.reportTimeEnd=[self.userDefaults valueForKey:PERFERENCE_TIMEREPORT_END];
    
    self.cityText.delegate=self;
    self.timeReportExceptText.delegate=self;
    if(self.city!=nil)
        [self.cityText setText:[NSString stringWithFormat:@"%@ - %@",self.province,self.city]];
    NSInteger timeReportType=[self.userDefaults integerForKey:PERFERENCE_TIME_REPORT_TYPE];
    switch (timeReportType) {
        case 0:
            [self.timeReportHalfAnHour setSelected:YES];
            break;
        case 1:
            [self.timeReportHours setSelected:YES];
            break;
        case 2:
            [self.timeReportNoReport setSelected:YES];
            break;
        default:
            break;
    }
    if (self.selections.count) {
        self.index1 = [self.selections[0] integerValue];
        self.index2 = [self.selections[1] integerValue];
    }
    [self calculateFirstData];
    
    
    for(int i=0;i<48;i++){
        int hours=i/2;
        int minutes=i%2*30;
        NSString *timeString=[NSString stringWithFormat:@"%02d:%02d",hours,minutes+1];
        [self.timeArr addObject:timeString];
    }
        NSString *reportTimeExceptString=[NSString stringWithFormat:@"%@-%@",self.reportTimeStart,self.reportTimeEnd];
    [self.timeReportExceptText setText:reportTimeExceptString];
}
- (void)loadFirstData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    NSLog(@"%@",path);
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    self.addressArr = [jsonStr mj_JSONObject];
    
    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
        NSString *name = dict.allKeys.firstObject;
        [firstName addObject:name];
        
    }
    self.provinceArr = firstName;
}
- (void)calculateFirstData
{
    [self loadFirstData];
    
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    for (NSDictionary *cityName in [self.addressArr[self.index1] allValues].firstObject) {
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
    }
    self.countryArr = cityNameArr;
}
-(void)showRegionSelectView{
    self.IS_ReportTimeSelected=YES;
    if(self.province!=nil&&self.city!=nil)
    {
        int selectIndex=0;
        for(NSString *firstName in self.provinceArr){
            if(self.province!=nil && [firstName isEqualToString:self.province])
            {
                _index1=selectIndex;
            }else{
                selectIndex++;
            }
        }
        [self calculateFirstData];
    }
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    int selectIndex=0;
    for (NSDictionary *cityName in [self.addressArr[self.index1] allValues].firstObject) {
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
        if(self.city!=nil && [name1 isEqualToString:self.city])
        {
            _index2=selectIndex;
        }else{
            selectIndex++;
        }
    }
    
    
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2)]];
    self.picker.tapDismissAction  = TapActionCancel;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    [self.picker showActionSheetPicker];
}
-(void)showTimeReportExceptSelectView{
    self.IS_ReportTimeSelected=FALSE;
    int startSelectIndex=0;
    int endSelectIndex=0;
    for(int i=0;i<self.timeArr.count;i++){
        if([self.reportTimeStart isEqualToString:[self.timeArr objectAtIndex:i]])
        {
            startSelectIndex=i;
        }
        if([self.reportTimeEnd isEqualToString:[self.timeArr objectAtIndex:i]]){
            endSelectIndex=i;
        }
        
    }
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"时间段选择" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(startSelectIndex),@(endSelectIndex)]];
    self.picker.tapDismissAction  = TapActionCancel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(0, 0, 44, 44);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:button]];
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:button1]];
    
    [self.picker showActionSheetPicker];
    
}
-(IBAction)cityTouchDown:(id)sender
{
}
-(IBAction)timeReportExceptTouchDown:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction)saveListener:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
    if (self.didDismiss)
        self.didDismiss(@"some extra data");
}
-(IBAction)aboutListener:(id)sender{
    AboutMe *aboutMe=[[AboutMe alloc]initWithNibName:@"AboutMe" bundle:[NSBundle mainBundle]];
    [aboutMe setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:aboutMe animated:YES completion:^{}];
//    [self.navigationController pushViewController:aboutMe animated:YES];
}
-(IBAction)regionSelect:(id)sender{
    
}
-(IBAction)switchPlayTickListner:(id)sender
{
    UISwitch *switchButton=(UISwitch*)sender;
    [self.userDefaults setBool: [switchButton isOn]forKey:PERFERENCE_TICK];
    NSLog(@"switch:%i",[switchButton isOn]);
    [self.userDefaults synchronize];
}
-(IBAction)mottoTextChangeListner:(id)sender{
    UITextField *motto=(UITextField*)sender;
    int _maxTextLength=50;
    if (motto.text.length >=_maxTextLength) {
        motto.text = [motto.text substringToIndex:_maxTextLength];
    }
    [self.userDefaults setObject:motto.text forKey:PERFERENCE_MOTTO];
    [self.userDefaults synchronize];
    NSLog(@"%@",[motto text]);
}
-(IBAction)onRadioBtn:(id)sender{
    DLRadioButton *selectRadio=(DLRadioButton*)sender;
    switch (selectRadio.tag) {
        case 0:
            [self.userDefaults setInteger:TR_HALF_AN_HOUR forKey:PERFERENCE_TIME_REPORT_TYPE];
            
            break;
        case 1:
            [self.userDefaults setInteger:TR_HOURS forKey:PERFERENCE_TIME_REPORT_TYPE];
            
            break;
        case 2:
            [self.userDefaults setInteger:TR_NO_REPORT forKey:PERFERENCE_TIME_REPORT_TYPE];
            break;
        default:
            break;
    }
    [self.userDefaults synchronize];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(!self.IS_ReportTimeSelected){
        return self.timeArr.count;
    }
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        default:break;
    }
    return 0;
}
#pragma mark UIPickerViewDelegate Implementation
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(!self.IS_ReportTimeSelected){
        return self.timeArr[row];
    }
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    if(self.IS_ReportTimeSelected)
    {
        switch (component)
        {
            case 0: title =   self.provinceArr[row];break;
            case 1: title =   self.countryArr[row];break;
            default:break;
        }
    }else
        title=self.timeArr[row];
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.IS_ReportTimeSelected)
    {
        switch (component)
        {
            case 0:
            {
                self.index1 = row;
                self.index2 = 0;
                [self calculateFirstData];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
            }
                break;
                
            case 1:
            {
                self.index2 = row;
                [self calculateFirstData];
            }
                break;
            default:break;
        }
    }else{
        switch (component) {
            case 0:
                self.reportTimeStartIndex=row;
                break;
            case 1:
                self.reportTimeEndIndex=row;
                
            default:
                break;
        }
        
    }
}

- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = YES;
}
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
    
    if(self.IS_ReportTimeSelected)
    {
        NSMutableString *detailAddress = [[NSMutableString alloc] init];
        if (self.index1 < self.provinceArr.count) {
            NSString *firstAddress = self.provinceArr[self.index1];
            [detailAddress appendString:firstAddress];
            self.province=firstAddress;
            [self.userDefaults setValue:firstAddress forKey:PERFERENCE_PROVINCE];
            
        }
        if (self.index2 < self.countryArr.count) {
            NSString *secondAddress = self.countryArr[self.index2];
            [detailAddress appendString:@" - "];
            [detailAddress appendString:secondAddress];
            self.city=secondAddress;
            [self.userDefaults setValue:secondAddress forKey:PERFERENCE_CITY];
        }
        [self.userDefaults synchronize];
        [self.cityText setText:detailAddress];
    }else{
        NSString *select=[NSString stringWithFormat:@"%@-%@",[self.timeArr objectAtIndex:self.reportTimeStartIndex],[self.timeArr objectAtIndex:self.reportTimeEndIndex]];
        self.reportTimeStart=[self.timeArr objectAtIndex:self.reportTimeStartIndex];
        self.reportTimeEnd=[self.timeArr objectAtIndex:self.reportTimeEndIndex];
        [self.userDefaults setValue:self.reportTimeStart forKey:PERFERENCE_TIMEREPORT_START];
        [self.userDefaults setValue:self.reportTimeEnd forKey:PERFERENCE_TIMEREPORT_END];
        [self.userDefaults synchronize];
        [self.timeReportExceptText setText:select];
        
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField==self.cityText)
        [self showRegionSelectView];
    else
        [self showTimeReportExceptSelectView];
    return NO;
}
- (NSArray *)provinceArr
{
    if (_provinceArr == nil) {
        _provinceArr = [[NSArray alloc] init];
    }
    return _provinceArr;
}
-(NSArray *)countryArr
{
    if(_countryArr == nil)
    {
        _countryArr = [[NSArray alloc] init];
    }
    return _countryArr;
}

-(NSArray *)addressArr
{
    if (_addressArr == nil) {
        _addressArr = [[NSArray alloc] init];
    }
    return _addressArr;
}
-(NSArray*)timeArr{
    if(_timeArr==nil){
        _timeArr=[[NSMutableArray alloc]init];
    }
    return _timeArr;
}
//-(id<ActionSheetCustomPickerDelegate>) timeReportDelegate{
//
//}
@end
