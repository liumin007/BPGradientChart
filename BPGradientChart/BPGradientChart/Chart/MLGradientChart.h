//
//  MLGradientChart.h
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLGradientChartItem.h"
#import "MLGradientChartPoint.h"

@interface MLGradientChart : UIView

@property (nonatomic)           CGFloat animationSpeedFactor;
@property (nonatomic)           CGFloat spacing;
@property (nonatomic)           NSUInteger maximumFractionDigits;
@property (nonatomic)           CGPoint zeroPoint;
@property (nonatomic, strong)   NSArray<MLGradientChartItem *> *items;
@property (nonatomic, strong)   NSArray<MLGradientChartPoint *> *points;
@property (nonatomic, strong)   UIFont  *font;

/** 坐标轴label颜色*/
@property (nonatomic, strong)   UIColor *color;

//轴标签
@property (nonatomic, strong)   UIFont  *labelFont;
@property (nonatomic, strong)   UIColor *labelColor;
@property (nonatomic, strong)   NSString *horizontalLabel;
@property (nonatomic, strong)   NSString *verticalLabel;

- (CGPoint)maxPoint;
- (void)draw;

@end
