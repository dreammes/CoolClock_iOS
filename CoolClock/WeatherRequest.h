//
//  WeatherRequest.h
//  CoolClock
//
//  Created by socoolby on 21/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//#import "AFNetworking/AFNetworking.h"
//#import <AFNetworking/AFNetworking.h>
#import <AFNetworking.h>
@interface WeatherRequest : NSObject
typedef void(^WeatherBlock)(NSString *weatherString);
+(instancetype)shareNetworkTools;
-(void)getWeather:(NSString*)city WithBlock:(WeatherBlock)weatherBlock;
@end
