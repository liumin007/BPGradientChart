//
//  MLGradientChartPoint.m
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import "MLGradientChartPoint.h"

@implementation MLGradientChartPoint
 
- (instancetype)initWithPoint:(CGPoint)point radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth title:(NSString *)title font:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor
{
    if (self = [super init]) {
        _point  = point;
        _radius = radius;
        _title  = title;
        _font   = font;
        _color  = color;
        _backgroundColor = backgroundColor;
        _borderWidth = borderWidth;
        _borderColor = borderColor;
    }
    return self;
}
@end
