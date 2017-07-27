//
//  NetController.h
//  RESideMenuExample
//
//  Created by socoolby on 4/2/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Func.h"
@interface NetUnit : NSObject
@property(nonatomic,strong) NSOperationQueue *mainQueue;
@property(nonatomic,strong) NSOperationQueue *picQueue;
//@property(nonatomic,strong) AFHTTPClient     *client;
+(NetUnit*) shareAdapter;
@end
