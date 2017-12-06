//
//  MLGradientChartItem.m
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import "MLGradientChartItem.h"

@implementation MLGradientChartItem
 
- (instancetype)initWithPoint:(CGPoint)point title:(NSString *)title font:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor
{
    if (self = [super init]) {
        _point = point;
        _title = title;
        _font  = font;
        _color = color;
        _backgroundColor = backgroundColor;
    }
    return self;
}

@end
