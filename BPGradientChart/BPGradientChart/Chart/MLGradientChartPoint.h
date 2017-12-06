//
//  MLGradientChartPoint.h
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit; 
@interface MLGradientChartPoint : NSObject
@property (nonatomic)           CGPoint     point;
@property (nonatomic)           CGFloat     radius;
@property (nonatomic, strong)   NSString    *title;
@property (nonatomic, strong)   UIFont      *font;
@property (nonatomic, strong)   UIColor     *color;
@property (nonatomic, strong)   UIColor     *backgroundColor;
@property (nonatomic)           CGFloat     borderWidth;
@property (nonatomic, strong)   UIColor     *borderColor;


- (instancetype)initWithPoint:(CGPoint)point radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth title:(NSString *)title font:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor;
@end
