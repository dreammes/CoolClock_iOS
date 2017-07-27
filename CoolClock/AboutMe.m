//
//  AboutMe.m
//  CoolClock
//
//  Created by socoolby on 27/07/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import "AboutMe.h"

@interface AboutMe ()

@end

@implementation AboutMe

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* buildNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    [_version setText:[NSString stringWithFormat:@"Version:%@.%@",versionNum,buildNum]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)githubListener:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/socoolby/CoolClock_iOS"]];
}
-(IBAction)mailListener:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:socoolby@gmail.com"]];
}
-(IBAction)blogListener:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://socoolby.com"]];
}
-(IBAction)backgroundClickListener:(id)sender{
     [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
