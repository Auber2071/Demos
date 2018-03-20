//
//  UIView+HKTExtension.h
//  VencentDeepPockets
//
//  Created by hankai on 2018/1/29.
//  Copyright © 2018年 Vencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HKTExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;


/// 边线颜色
@property (nonatomic, strong) UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) CGFloat borderWidth;
/// 脚半径
@property (nonatomic, assign) CGFloat cornerRadius;


/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/

@end
