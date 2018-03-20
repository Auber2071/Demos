//
//  HKVTextField.m
//  HKVerificationCodeDemo
//
//  Created by hankai on 2018/3/19.
//  Copyright © 2018年 hankai. All rights reserved.
//

#import "HKVTextField.h"

@implementation HKVTextField

- (void)deleteBackward {
    [super deleteBackward];
    
    if ([self.HKV_delegate respondsToSelector:@selector(HKV_TextFieldDeleteBackward:)]) {
        [self.HKV_delegate HKV_TextFieldDeleteBackward:self];
    }
}
@end
