//
//  DigitNumberFont.m
//  CoolClock
//
//  Created by socoolby on 24/07/2017.
//  Copyright © 2017 YZXZYH. All rights reserved.
//

#import "DigitNumberFont.h"

@implementation DigitNumberFont

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.viewController)
        [self.viewController performSelector:@selector(ContainerTouch:) withObject:touches];
}

@end
