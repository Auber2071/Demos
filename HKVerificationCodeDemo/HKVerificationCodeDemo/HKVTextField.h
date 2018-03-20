//
//  HKVTextField.h
//  HKVerificationCodeDemo
//
//  Created by hankai on 2018/3/19.
//  Copyright © 2018年 hankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKVTextField;
@protocol HKVTextFieldDelegate <NSObject>

- (void)HKV_TextFieldDeleteBackward:(HKVTextField *)textField;

@end



@interface HKVTextField : UITextField

@property (nonatomic, assign) id <HKVTextFieldDelegate> HKV_delegate;

@end
