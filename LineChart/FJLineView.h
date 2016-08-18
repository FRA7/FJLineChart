//
//  FJLineView.h
//  AntRice
//
//  Created by JYH on 16/7/14.
//  Copyright © 2016年 FRAJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJLineView : UIView
/**
 @brief x 轴上的值
 */
@property(nonatomic,strong)NSArray* xValues;
/**
 @brief y 轴上的值
 */
@property(nonatomic,strong)NSArray* yValues;
/**
 @brief x 轴的刻度值
 */
@property(nonatomic,strong)NSArray* xKeDuValus;
/**
 @brief y 轴的刻度值
 */
@property(nonatomic,strong)NSArray* yKeDuValus;
/**
 @brief x 轴上文字颜色
 */
@property(nonatomic,strong)UIColor* xValueColor;
/**
 @brief y 轴上文字颜色
 */
@property(nonatomic,strong)UIColor* yValueColor;

@end
