//
//  ViewController.m
//  HKVerificationCodeDemo
//
//  Created by hankai on 2018/3/19.
//  Copyright © 2018年 hankai. All rights reserved.
//

#import "ViewController.h"
#import "HKVInputTextFieldView.h"

@interface ViewController ()<HKVInputTextFieldViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIEdgeInsets inputTextInset = UIEdgeInsetsMake(100, 0, 0, 0);

    HKVInputTextFieldView *inputView = [[HKVInputTextFieldView alloc] initWithFrame:CGRectMake(inputTextInset.left, inputTextInset.top, CGRectGetWidth(self.view.frame)-inputTextInset.left-inputTextInset.right, 80) withLenghtUnit:6];
    inputView.delegate = self;
    [self.view addSubview:inputView];
}

-(void)inputTextFieldView:(HKVInputTextFieldView *)View VerificationCode:(NSString *)code{
    NSLog(@"code:%@",code);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
