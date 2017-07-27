//
//  Func.m
//  HiTalk
//
//  Created by socoolby on 5/22/14.
//  Copyright (c) 2014 YZXZYH. All rights reserved.
//

#import "Func.h"

@implementation Func
static Func* _funcInstance=nil;
+(Func*)shareInstance
{
    if(!_funcInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            _funcInstance=[[Func alloc]init];
        });
    }
    return _funcInstance;
}
-(void)Log:(NSString*)log
{

#if isDebug
        NSLog(@"%@",log);
#endif
}
@end
