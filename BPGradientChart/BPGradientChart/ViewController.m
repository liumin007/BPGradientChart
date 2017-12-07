//
//  ViewController.m
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import "ViewController.h"
#import "MLGradientChart.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//低血压 x(收缩压)  y(舒张压)
#define CONST_BP_HYPO_X                 90.f
#define CONST_BP_HYPO_Y                 60.f

//理想血压
#define CONST_BP_IDEAL_X                110.f
#define CONST_BP_IDEAL_Y                80.f

//正常血压
#define CONST_BP_NORM_X                 130.f
#define CONST_BP_NORM_Y                 85.f

//正常高值
#define CONST_BP_NORM_HIGH_X            140.f
#define CONST_BP_NORM_HIGH_Y            90.f

//轻度高血压 Mild Hypertension
#define CONST_BP_MILD_HYPE_X            160.f
#define CONST_BP_MILD_HYPE_Y            100.f

//中度高血压 Moderate hypertension
#define CONST_BP_MODERATE_HYPE_X            180.f
#define CONST_BP_MODERATE_HYPE_Y            110.f

//高度高血压 High hypertension
#define CONST_BP_HIGH_HYPE_X            190.f
#define CONST_BP_HIGH_HYPE_Y            120.f

#define COLOR_WHT_NOR     [UIColor whiteColor]

@interface ViewController ()
{
    MLGradientChart *chart;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    chart = [[MLGradientChart alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 260)];
    
    [self.view addSubview:chart];
    [self loadSquareChart];
    [self loadPoints];
}


- (void)loadSquareChart
{
    NSArray<MLGradientChartItem *> *items =
    @[[[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_HYPO_X, CONST_BP_HYPO_Y)
                                           title:@"低血压"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0x62BFE1)],
      [[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_IDEAL_X, CONST_BP_IDEAL_Y)
                                           title:@"理想血压"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0xA3C874)],
      [[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_NORM_X, CONST_BP_NORM_Y)
                                           title:@"正常"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0xA3CD86)],
      [[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_NORM_HIGH_X, CONST_BP_NORM_HIGH_Y)
                                           title:@"正常高值"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0xF7C867)],
      [[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_MILD_HYPE_X, CONST_BP_MILD_HYPE_Y)
                                           title:@"轻度高血压"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0xED7865)],
      [[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_MODERATE_HYPE_X, CONST_BP_MODERATE_HYPE_Y)
                                           title:@"中度高血压"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0xED78C8)],
      [[MLGradientChartItem alloc] initWithPoint:CGPointMake(CONST_BP_HIGH_HYPE_X, CONST_BP_HIGH_HYPE_Y)
                                           title:@"高度高血压"
                                            font:nil
                                           color:COLOR_WHT_NOR
                                 backgroundColor:UIColorFromRGB(0xED78A3)]];
    
    chart.zeroPoint    = CGPointMake(40, 40);
    chart.font         = [UIFont systemFontOfSize:12.f];
    chart.color        = [UIColor darkGrayColor];
    chart.spacing      = 4.f;
    chart.labelColor   = [UIColorFromRGB(0x6A6A6A) colorWithAlphaComponent:.7f];
    chart.horizontalLabel  = @"SBP";
    chart.verticalLabel    = @"DBP";
    chart.items        = items;
    [chart draw];
}

- (void)loadPoints {
    CGPoint point = CGPointMake(86, 110);
    
    NSMutableArray<MLGradientChartPoint *> *points =
    [NSMutableArray arrayWithArray:
     @[[[MLGradientChartPoint alloc] initWithPoint:point
                                            radius:5.f
                                       borderWidth:2.f
                                             title:nil
                                              font:[UIFont systemFontOfSize:8.f]
                                             color:nil
                                   backgroundColor:[UIColor whiteColor]
                                       borderColor:UIColorFromRGB(0x6A6A6A)]]];
    
    chart.points = points;
}

@end
