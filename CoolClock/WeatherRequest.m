//
//  WeatherRequest.m
//  CoolClock
//
//  Created by socoolby on 21/06/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import "WeatherRequest.h"

static WeatherRequest *_weatherRequest=nil;
@implementation WeatherRequest
+(instancetype)shareNetworkTools{
    if(!_weatherRequest)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _weatherRequest=[[WeatherRequest alloc]init];
        });
    }
    return _weatherRequest;
}
-(void)getWeather:(NSString*)city WithBlock:(WeatherBlock)weatherBlock{
    NSString *WEATHER_URL=[[NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&ak=vEWCgIndW4S8U6ANY3CIs2Wo",city] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"Get Weather:\n%@",WEATHER_URL);
    AFHTTPSessionManager *manage=[AFHTTPSessionManager manager];
    [manage.securityPolicy setAllowInvalidCertificates:YES];
    [manage GET:WEATHER_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        int errorCode=[[jsonDict objectForKey:@"error"] intValue];
        if(errorCode==0){
            NSArray *results=[jsonDict objectForKey:@"results"];
            NSDictionary *summary=[results objectAtIndex:0];
            NSString *city=[summary objectForKey:@"currentCity"];
            int pm25=[[summary objectForKey:@"pm25"] intValue];
            NSArray *weathers=[summary objectForKey:@"weather_data"];
            NSDictionary *todayWeather=[weathers objectAtIndex:0];
            
            NSString *todayWeatherString=[todayWeather objectForKey:@"weather"];
            NSString *todyWind=[todayWeather objectForKey:@"wind"];
            NSString *temperature=[todayWeather objectForKey:@"temperature"];
            NSLog(@"currentCity:%@  pm25:%d todayWeather:%@ todayWind:%@,temperature:%@",city,pm25,todayWeatherString,todyWind,temperature);
            weatherBlock(todayWeatherString);
        }
    }failure:^(NSURLSessionTask *operation,NSError *error){
        NSLog(@"Error:%@",error);
    }];
}
@end
