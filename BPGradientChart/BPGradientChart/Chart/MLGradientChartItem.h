//
//  MLGradientChartItem.h
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit; 
@interface MLGradientChartItem : NSObject

@property (nonatomic) CGPoint point;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backgroundColor;

- (instancetype)initWithPoint:(CGPoint)point title:(NSString *)title font:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

@end
