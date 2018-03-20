//
//  HKVInputTextFieldView.m
//  MovePortal_Base
//
//  Created by hankai on 2018/3/19.
//  Copyright © 2018年 hankai. All rights reserved.
//

#import "HKVInputTextFieldView.h"
#import "UIView+HKTExtension.h"
#import "HKVTextField.h"

#define numbers @"0123456789\n"

@interface HKVInputTextFieldView()<UITextFieldDelegate,HKVTextFieldDelegate>

//验证码位数
@property (nonatomic, assign) NSInteger lengthUnit;

@property (nonatomic, strong) NSMutableArray *lineMutArr;
@property (nonatomic, strong) NSMutableArray *textFieldMutArr;
@property (nonatomic, strong) NSMutableArray *authCodeArr;
@property (nonatomic, assign) BOOL isLastTextField;

@end

@implementation HKVInputTextFieldView

- (instancetype)initWithLengthUnit:(NSInteger)lengthUnit
{
    self = [super init];
    if (self) {
        _lengthUnit = lengthUnit>4?lengthUnit:4;
        [self p_initializeParams];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withLenghtUnit:(NSInteger)lengthUnit
{
    self = [super initWithFrame:frame];
    if (self) {
        _lengthUnit = lengthUnit>4?lengthUnit:4;
        [self p_initializeParams];
    }
    return self;
}

-(void)p_initializeParams{
    [self.authCodeArr removeAllObjects];
    [self p_setupSubViews];
    self.isLastTextField = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_authCodeChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets inputInset = UIEdgeInsetsMake(5, 25, 5, 25);
    CGFloat padding = 10.f;
    CGFloat inputWidth = (CGRectGetWidth(self.frame)-inputInset.left-inputInset.right-padding*5)/6;
    CGFloat tempInputHeight = CGRectGetHeight(self.frame)-inputInset.top-inputInset.bottom;
    inputWidth = MIN(inputWidth, tempInputHeight);
    CGFloat tempLeftPadding = (CGRectGetWidth(self.frame) - inputWidth*self.lengthUnit-padding*(self.lengthUnit-1))/2.f;
    inputInset = UIEdgeInsetsMake(inputInset.top, tempLeftPadding, inputInset.bottom, tempLeftPadding);
    
    for (int i = 0; i<self.lengthUnit; i++) {
        HKVTextField *textField = (HKVTextField *)self.textFieldMutArr[i];
        [textField setFrame:CGRectMake(inputInset.left+i*(padding+inputWidth), inputInset.top, inputWidth, inputWidth)];
        textField.centerY = CGRectGetHeight(self.frame)/2.f;
        
        UIView *line = (UIView *)self.lineMutArr[i];
        [line setFrame:CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(textField.frame)+inputInset.bottom/2.f, CGRectGetWidth(textField.frame), 1)];
    }
}

-(void)setupFirstResponse{
    if (self.textFieldMutArr.count>0) {
        HKVTextField *textField = self.textFieldMutArr[0];
        [textField becomeFirstResponder];
    }
}

#pragma mark - Private Method

-(void)p_setupSubViews{
    [self.textFieldMutArr removeAllObjects];
    [self.lineMutArr removeAllObjects];
    for (int i = 0; i<self.lengthUnit; i++) {
        HKVTextField *textField = [[HKVTextField alloc] init];
        textField.delegate = self;
        textField.HKV_delegate = self;
        textField.tag = i;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.tintColor =[UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:35.f];
        textField.keyboardType = UIKeyboardTypePhonePad;
        [self addSubview:textField];
        [self.textFieldMutArr addObject:textField];
        
        //bottom line
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        [self addSubview:line];
        [self.lineMutArr addObject:line];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSInteger index;
    if (self.authCodeArr.count == self.lengthUnit) {
        index = self.lengthUnit-1;
    }else{
        index = self.authCodeArr.count;
    }
    if (textField.tag != index) {
        HKVTextField *firstTextField = (HKVTextField *)self.textFieldMutArr[index];
        if ([textField canResignFirstResponder]) {
            [textField resignFirstResponder];
        }
        [firstTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //筛选输入的内容是否符合要求
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers]invertedSet];
    //按characterSet分离出数组,数组按@""分离出字符串
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange) {
        if (textField.text.length>0 && range.length>0) {
            self.isLastTextField = YES;
        }else{
            [self.authCodeArr addObject:string];
        }
        [self p_sendVerificationCode];
    }
    return canChange;
}

-(void)HKV_TextFieldDeleteBackward:(HKVTextField *)textField{
    if (self.isLastTextField) {//针对最后一个TextFidld
        [textField becomeFirstResponder];
        [self.authCodeArr removeLastObject];
        self.isLastTextField = NO;
        [self p_sendVerificationCode];
        return;
    }
    if (textField.tag>0 && textField.tag == self.authCodeArr.count) {//非最后一个TextField的删除操作
        HKVTextField *deleteTextField = (HKVTextField *)self.textFieldMutArr[self.authCodeArr.count-1];
        [self.authCodeArr removeLastObject];
        deleteTextField.text = @"";
        [deleteTextField becomeFirstResponder];
        [self p_sendVerificationCode];
        return;
    }
}

-(void)p_authCodeChange{
    if (self.authCodeArr.count<self.lengthUnit) {
        HKVTextField *nextTextField = (HKVTextField *)self.textFieldMutArr[self.authCodeArr.count];
        [nextTextField becomeFirstResponder];
    }else{
        [self endEditing:YES];
    }
}


-(void)p_sendVerificationCode{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextFieldView:VerificationCode:)]) {
        NSString *string;
        if (self.authCodeArr.count>0) {
            string = [self.authCodeArr componentsJoinedByString:@""];
        }else{
            string = @"";
        }        [self.delegate inputTextFieldView:self VerificationCode:string];
    }
}


#pragma mark - Set Method

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    for (UIView *line in self.lineMutArr) {
        line.backgroundColor = _lineColor;
    }
}

#pragma mark - Get Method

-(NSMutableArray *)lineMutArr{
    if (!_lineMutArr) {
        _lineMutArr = [NSMutableArray array];
    }
    return _lineMutArr;
}
-(NSMutableArray *)textFieldMutArr{
    if (!_textFieldMutArr) {
        _textFieldMutArr = [NSMutableArray array];
    }
    return _textFieldMutArr;
}
-(NSMutableArray *)authCodeArr{
    if (!_authCodeArr) {
        _authCodeArr = [NSMutableArray array];
    }
    return _authCodeArr;
}
@end
