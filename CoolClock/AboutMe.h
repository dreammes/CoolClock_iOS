//
//  AboutMe.h
//  CoolClock
//
//  Created by socoolby on 27/07/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutMe : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *version;
-(IBAction)githubListener:(id)sender;
-(IBAction)mailListener:(id)sender;
-(IBAction)blogListener:(id)sender;
-(IBAction)backgroundClickListener:(id)sender;
@end
