//
//  HKVInputTextFieldView.h
//  MovePortal_Base
//
//  Created by hankai on 2018/3/19.
//  Copyright © 2018年 hankai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKVInputTextFieldView;

@protocol HKVInputTextFieldViewDelegate <NSObject>

-(void)inputTextFieldView:(HKVInputTextFieldView *)View VerificationCode:(NSString *)code;

@end


@interface HKVInputTextFieldView : UIView

- (instancetype)initWithLengthUnit:(NSInteger)lengthUnit;
- (instancetype)initWithFrame:(CGRect)frame withLenghtUnit:(NSInteger)lengthUnit;

@property (nonatomic, assign) id<HKVInputTextFieldViewDelegate> delegate;

//默认颜色为grayColor
@property (nonatomic, strong) UIColor *lineColor;

-(void)setupFirstResponse;


@end
