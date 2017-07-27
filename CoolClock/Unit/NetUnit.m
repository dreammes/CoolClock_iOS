//
//  NetController.m
//  RESideMenuExample
//
//  Created by socoolby on 4/2/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "NetUnit.h"


static NetUnit* _sharedNetController=nil;
@implementation NetUnit
+(NetUnit*)shareAdapter
{
    if(!_sharedNetController)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _sharedNetController=[[NetUnit alloc]init];
        });
    }
    return _sharedNetController;
}

- (id) init
{
    if (self = [super init])
    {
        self.mainQueue = [[NSOperationQueue alloc] init];
        self.mainQueue.maxConcurrentOperationCount = 5;
        
        self.picQueue = [[NSOperationQueue alloc] init];
        self.picQueue.maxConcurrentOperationCount = 2;
        
//        self.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBasedServerURL]];
    }
    return self;
}
//
//-(void)requestWithGET:(NSString*)UrlString params:(NSMutableDictionary*)params success:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))failue;
//{
//    NSLog(@"requestWithGet url:%@\nParams:%@",UrlString,params);
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestSerializer *request=[[AFHTTPRequestSerializer alloc]init];
////    [request setValue:@"AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B507 Safari/9537.53" forKey:@"User-Agent"];
////    [request setTimeoutInterval:15000];
////    [request setValue:@"AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B507 Safari/9537.53"  forHTTPHeaderField:@"User-Agent"];
//    [manager setRequestSerializer:request];
//    [manager GET:UrlString parameters:params success:success failure:failue];
//}
@end
