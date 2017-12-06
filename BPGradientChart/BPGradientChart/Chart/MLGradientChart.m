//
//  MLGradientChart.m
//  BPGradientChart
//
//  Created by liumin on 2017/12/6.
//  Copyright © 2017年 Gomtel. All rights reserved.
//

#import "MLGradientChart.h"

#define kSquareChartFontSize            [UIFont smallSystemFontSize]
#define kSquareChartAnimationDuration   .4f

#pragma mark - UILabel

@implementation NSString (Extended)

- (CGSize)fitSizeWithFont:(UIFont *)font
{
    if (!font) {
        return CGSizeZero;
    }
    UILabel *label = [UILabel new];
    label.font = font;
    label.text = self;
    [label sizeToFit];
    return label.bounds.size;
}

@end

#pragma mark - UILabel

@implementation UILabel (Extended)

- (void)rotateLabel
{
    CGRect orig = self.frame;
    self.transform = CGAffineTransformMakeRotation(M_PI * 3/2); // 270
    self.frame = orig;
}

@end

#pragma mark - UIView

@implementation UIView (Extended)

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width   * anchorPoint.x,
                                   self.bounds.size.height  * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width   * self.layer.anchorPoint.x,
                                   self.bounds.size.height  * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}
   

@interface MLGradientChart ()
{
    UIView *chartView;
}
@end

@implementation MLGradientChart

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self draw];
}

- (void)setItems:(NSArray<MLGradientChartItem *> *)items {
    NSMutableArray<MLGradientChartItem *> *sortedItems = [NSMutableArray new];
    for (MLGradientChartItem *item in items) {
        BOOL sorted = NO;
        for (MLGradientChartItem *sortedItem in sortedItems) {
            if ([self distanceFromZeroPoint:item.point] > [self distanceFromZeroPoint:sortedItem.point]) {
                [sortedItems insertObject:item
                                  atIndex:[sortedItems indexOfObject:sortedItem]];
                sorted = YES;
                break;
            }
        }
        if (!sorted) { [sortedItems addObject:item]; }
    }
    _items = sortedItems;
}

- (void)setPoints:(NSArray<MLGradientChartPoint *> *)points
{
    NSMutableArray<MLGradientChartPoint *> *sortedPoints = [NSMutableArray new];
    for (MLGradientChartPoint *point in points) {
        BOOL sorted = NO;
        for (MLGradientChartPoint *sortedPoint in sortedPoints) {
            if ([self distanceFromZeroPoint:point.point] < [self distanceFromZeroPoint:sortedPoint.point]) {
                [sortedPoints insertObject:point
                                   atIndex:[sortedPoints indexOfObject:sortedPoint]];
                sorted = YES;
                break;
            }
        }
        if (!sorted) { [sortedPoints addObject:point]; }
    }
    _points = sortedPoints;
}

#pragma mark - Methods

- (CGFloat)distanceFromZeroPoint:(CGPoint)point
{
    CGFloat dx = (point.x - _zeroPoint.x);
    if (dx < 0) {
        return .0f;
    }
    
    CGFloat dy = (point.y - _zeroPoint.y);
    if (dy < 0) {
        return .0f;
    }
    
    return sqrt(dx * dx + dy * dy);
}

- (CGPoint)maxPoint
{
    CGPoint maxPoint = _zeroPoint;
    for (MLGradientChartItem *item in _items) {
        CGPoint itemPoint = item.point;
        if (itemPoint.x > maxPoint.x) {
            maxPoint.x = itemPoint.x;
        }
        if (itemPoint.y > maxPoint.y) {
            maxPoint.y = itemPoint.y;
        }
    }
    return maxPoint;
}

- (void)draw
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat duration = _animationSpeedFactor ? kSquareChartAnimationDuration / _animationSpeedFactor : 0;
    
    NSArray<MLGradientChartItem *>  *itemsCopy  = [self.items copy];
    NSArray<MLGradientChartPoint *>   *pointsCopy = [self.points copy];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = _maximumFractionDigits;
    
    CGPoint maxPoint    = [self maxPoint];
    CGFloat maxPointX   = maxPoint.x - _zeroPoint.x;
    CGFloat maxPointY   = maxPoint.y - _zeroPoint.y;
    
    CGFloat fontSize = self.font ? self.font.pointSize : kSquareChartFontSize;
    UIColor *color   = self.color ? self.color : [UIColor darkTextColor];
    UIFont  *font    = [UIFont systemFontOfSize:fontSize];
    
    CGSize horizontalLabelSize = [[NSString stringWithFormat:@"%@+",
                                   [formatter stringFromNumber:@(maxPoint.x)]] fitSizeWithFont:font];
    CGSize verticalLabelSize = [[NSString stringWithFormat:@"%@+",
                                 [formatter stringFromNumber:@(maxPoint.y)]] fitSizeWithFont:font];
    CGFloat spacingFactor = _spacing * 4;
    chartView = [[UIView alloc] initWithFrame:
                 CGRectMake(self.bounds.origin.x + verticalLabelSize.width + fontSize + spacingFactor,
                            self.bounds.origin.y + fontSize * .5f,
                            self.bounds.size.width - verticalLabelSize.width - horizontalLabelSize.width / 2 - fontSize - spacingFactor,
                            self.bounds.size.height - fontSize * 2.5f - spacingFactor)];
    
    CGFloat chartX      = chartView.bounds.origin.x;
    CGFloat chartY      = chartView.bounds.origin.y;
    CGFloat chartWidth  = chartView.bounds.size.width;
    CGFloat chartHeight = chartView.bounds.size.height;
    NSUInteger i = 0;
    NSUInteger j = 0;
    
    if (itemsCopy.count) {
        
        // Zero Point
        UILabel *zeroPointHorizontalLabel;
        UILabel *zeroPointVerticalLabel;
        if (_zeroPoint.x == _zeroPoint.y) {
            zeroPointHorizontalLabel = [[UILabel alloc] initWithFrame:chartView.bounds];
            zeroPointHorizontalLabel.text = [formatter stringFromNumber:@(_zeroPoint.x)];
            zeroPointHorizontalLabel.font = font;
            zeroPointHorizontalLabel.textColor = color;
            zeroPointHorizontalLabel.textAlignment = NSTextAlignmentCenter;
            [zeroPointHorizontalLabel sizeToFit];
            zeroPointHorizontalLabel.frame = CGRectMake(chartX - zeroPointHorizontalLabel.bounds.size.width - _spacing,
                                                        chartY + chartHeight + _spacing,
                                                        zeroPointHorizontalLabel.bounds.size.width,
                                                        zeroPointHorizontalLabel.bounds.size.height);
            [chartView addSubview:zeroPointHorizontalLabel];
        } else {
            zeroPointHorizontalLabel = [[UILabel alloc] initWithFrame:chartView.bounds];
            zeroPointHorizontalLabel.text = [formatter stringFromNumber:@(_zeroPoint.x)];
            zeroPointHorizontalLabel.font = font;
            zeroPointHorizontalLabel.textColor = color;
            zeroPointHorizontalLabel.textAlignment = NSTextAlignmentCenter;
            [zeroPointHorizontalLabel sizeToFit];
            zeroPointHorizontalLabel.frame = CGRectMake(chartX,
                                                        chartY + chartHeight + _spacing,
                                                        zeroPointHorizontalLabel.bounds.size.width,
                                                        zeroPointHorizontalLabel.bounds.size.height);
            
            zeroPointVerticalLabel = [[UILabel alloc] initWithFrame:chartView.bounds];
            zeroPointVerticalLabel.text = [formatter stringFromNumber:@(_zeroPoint.y)];
            zeroPointVerticalLabel.font = font;
            zeroPointVerticalLabel.textColor = color;
            zeroPointVerticalLabel.textAlignment = NSTextAlignmentRight;
            [zeroPointVerticalLabel sizeToFit];
            zeroPointVerticalLabel.frame = CGRectMake(chartX - zeroPointVerticalLabel.bounds.size.width - _spacing,
                                                      chartY + chartHeight - zeroPointVerticalLabel.bounds.size.height + _spacing,
                                                      zeroPointHorizontalLabel.bounds.size.width,
                                                      zeroPointHorizontalLabel.bounds.size.height);
            
            [chartView addSubview:zeroPointHorizontalLabel];
            [chartView addSubview:zeroPointVerticalLabel];
            
        }
        
        if (duration) {
            
            zeroPointHorizontalLabel.transform = CGAffineTransformMakeScale(1.f, .0f);
            zeroPointHorizontalLabel.alpha = .0f;
            if (zeroPointVerticalLabel) {
                zeroPointVerticalLabel.transform = CGAffineTransformMakeScale(1.f, .0f);
                zeroPointVerticalLabel.alpha = .0f;
            }
            [UIView animateWithDuration:duration
                                  delay:duration * 3
                                options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCrossDissolve
                             animations:^ {
                                 zeroPointHorizontalLabel.transform = CGAffineTransformIdentity;
                                 zeroPointHorizontalLabel.alpha = 1.f;
                                 if (zeroPointVerticalLabel) {
                                     zeroPointVerticalLabel.transform = CGAffineTransformIdentity;
                                     zeroPointVerticalLabel.alpha = 1.f;
                                 }
                             } completion:nil];
        }
        
        
#pragma mark Squares
        for (MLGradientChartItem *item in itemsCopy) {
            CGFloat newX  = MIN(maxPointX, MAX(0, (item.point.x - _zeroPoint.x)));
            CGFloat newY  = MIN(maxPointY, MAX(0, (item.point.y - _zeroPoint.y)));
            CGFloat scaleX  = maxPointX ? (newX / maxPointX) : 0;
            CGFloat scaleY  = maxPointY ? (newY / maxPointY) : 0;
            CGFloat newWidth  = chartWidth * scaleX;
            CGFloat newHeight = chartHeight * scaleY;
            
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(chartX,
                                                                       chartY + chartHeight - newHeight,
                                                                       newWidth,
                                                                       newHeight)];
            
            if (item.backgroundColor) { newView.backgroundColor = item.backgroundColor; }
            
            UILabel *horizontalLabel;
            UILabel *verticalLabel;
            if (newWidth > 0 &&
                newHeight > 0) {
                
                // Horizontal
                horizontalLabel = [[UILabel alloc] initWithFrame:newView.bounds];
                horizontalLabel.text = [NSString stringWithFormat:@"%@%@",
                                        [formatter stringFromNumber:@(item.point.x)],
                                        item.point.x == maxPoint.x ? @"+" : @""];
                horizontalLabel.font = font;
                horizontalLabel.textColor = color;
                horizontalLabel.textAlignment = NSTextAlignmentCenter;
                [horizontalLabel sizeToFit];
                horizontalLabel.frame = CGRectMake(newView.bounds.origin.x + newView.bounds.size.width - horizontalLabel.bounds.size.width / 2,
                                                   newView.bounds.origin.y + newView.bounds.size.height + _spacing,
                                                   horizontalLabel.bounds.size.width,
                                                   horizontalLabel.bounds.size.height);
                [newView addSubview:horizontalLabel];
                
                // Vertical
                verticalLabel = [[UILabel alloc] initWithFrame:newView.bounds];
                verticalLabel.text = [NSString stringWithFormat:@"%@%@",
                                      [formatter stringFromNumber:@(item.point.y)],
                                      item.point.y == maxPoint.y ? @"+" : @""];
                verticalLabel.font = font;
                verticalLabel.textColor = color;
                verticalLabel.textAlignment = NSTextAlignmentRight;
                [verticalLabel sizeToFit];
                verticalLabel.frame = CGRectMake(newView.bounds.origin.x - verticalLabel.bounds.size.width - _spacing,
                                                 newView.bounds.origin.y - verticalLabel.bounds.size.height / 2,
                                                 verticalLabel.bounds.size.width,
                                                 verticalLabel.bounds.size.height);
                [newView addSubview:verticalLabel];
                
            }
            
            // Title
            UILabel *newLabel;
            if (item.title) {
                newLabel = [[UILabel alloc] initWithFrame:newView.bounds];
                newLabel.text = item.title;
                newLabel.font = item.font ? item.font : [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
                newLabel.textColor = item.color ? item.color : [UIColor darkTextColor];
                newLabel.textAlignment = NSTextAlignmentLeft;
                [newLabel sizeToFit];
                
                NSInteger count = itemsCopy.count - 1;
                NSInteger index = [itemsCopy indexOfObject:item];
                if (index != count) {
                    MLGradientChartItem *nextItem = [itemsCopy objectAtIndex:index + 1];
                    CGFloat nextY  = MIN(maxPointY, MAX(0, (nextItem.point.y - _zeroPoint.y)));
                    CGFloat nextHeight = maxPointY ? chartHeight * (nextY / maxPointY) : 0;
                    newLabel.frame = CGRectMake(newView.bounds.origin.x + _spacing * 2,
                                                newView.bounds.origin.y,
                                                newLabel.bounds.size.width,
                                                newView.bounds.size.height - nextHeight);
                } else {
                    newLabel.frame = CGRectMake(newView.bounds.origin.x + _spacing * 2,
                                                newView.bounds.origin.y,
                                                newLabel.bounds.size.width,
                                                newView.bounds.size.height);
                }
                [newView addSubview:newLabel];
            }
            
            [chartView addSubview:newView];
            
            if (duration) {
                
                [newView setAnchorPoint:CGPointMake(.0f, 1.f)];
                newView.transform = CGAffineTransformMakeScale(.0f, .0f);
                if (newLabel) {
                    newLabel.transform = CGAffineTransformMakeScale(1.f, .0f);
                    newLabel.alpha = .0f;
                }
                if (horizontalLabel && verticalLabel) {
                    horizontalLabel.transform = CGAffineTransformMakeScale(1.f, .0f);
                    horizontalLabel.alpha = .0f;
                    verticalLabel.transform = CGAffineTransformMakeScale(1.f, .0f);
                    verticalLabel.alpha = .0f;
                }
                
                CGFloat delay = duration * 2 / itemsCopy.count;
                [UIView animateWithDuration:duration
                                      delay:delay * i
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^ {
                                     newView.transform = CGAffineTransformIdentity;
                                 } completion:^ (BOOL finished) {
                                     [UIView animateWithDuration:duration
                                                           delay:.0f
                                                         options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^ {
                                                          if (newLabel) {
                                                              newLabel.transform = CGAffineTransformIdentity;
                                                              newLabel.alpha = 1.f;
                                                          }
                                                          if (horizontalLabel && verticalLabel) {
                                                              horizontalLabel.transform = CGAffineTransformIdentity;
                                                              horizontalLabel.alpha = 1.f;
                                                              verticalLabel.transform = CGAffineTransformIdentity;
                                                              verticalLabel.alpha = 1.f;
                                                          }
                                                      } completion:nil];
                                 }];
                i++;
            }
            
        }
        
#pragma mark Points
        for (MLGradientChartPoint *point in pointsCopy) {
            CGFloat newX  = MIN(maxPointX, MAX(0, (point.point.x - _zeroPoint.x)));
            CGFloat newY  = MIN(maxPointY, MAX(0, (point.point.y - _zeroPoint.y)));
            CGFloat newWidth  = maxPointX ? chartWidth  * (newX / maxPointX) : 0;
            CGFloat newHeight = maxPointY ? chartHeight * (newY / maxPointY) : 0;
            CGFloat borderWidth = MAX(0, point.borderWidth);
            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(newWidth - point.radius,
                                                                       chartY + chartHeight - newHeight - point.radius,
                                                                       point.radius * 2,
                                                                       point.radius * 2)];
            newView.layer.cornerRadius = point.radius;
            if (borderWidth) {
                newView.layer.borderWidth  = borderWidth;
                newView.layer.borderColor  = point.borderColor.CGColor;
            }
            if (point.backgroundColor) { newView.backgroundColor = point.backgroundColor; }
            
            // Title
            UILabel *newLabel;
            if (point.title) {
                newLabel = [[UILabel alloc] initWithFrame:newView.bounds];
                newLabel.text = point.title;
                newLabel.font = point.font ? point.font : font;
                newLabel.textColor = point.color ? point.color : color;
                newLabel.textAlignment = NSTextAlignmentLeft;
                [newLabel sizeToFit];
                newLabel.frame = CGRectMake(newView.bounds.origin.x + point.radius - newLabel.bounds.size.width / 2,
                                            newView.bounds.origin.y + point.radius + borderWidth + _spacing,
                                            newLabel.bounds.size.width,
                                            newLabel.bounds.size.height);
                [newView addSubview:newLabel];
            }
            [chartView addSubview:newView];
            
            if (duration) {
                newView.transform = CGAffineTransformMakeScale(.0f, .0f);
                newView.alpha = 0.f;
                if (newLabel) {
                    newLabel.transform = CGAffineTransformMakeScale(.0f, .0f);
                    newLabel.alpha = 0.f;
                }
                CGFloat delay = duration * 2 / pointsCopy.count;
                [UIView animateWithDuration:duration
                                      delay:delay * j + duration * 3
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^ {
                                     newView.transform = CGAffineTransformIdentity;
                                     newView.alpha = 1.f;
                                 } completion:nil];
                if (newLabel) {
                    [UIView animateWithDuration:duration
                                          delay:delay * j + duration * 3.1
                                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCrossDissolve
                                     animations:^ {
                                         newLabel.transform = CGAffineTransformIdentity;
                                         newLabel.alpha = 1.f;
                                     } completion:nil];
                    
                }
                j++;
            }
        }
        
#pragma mark Unit Labels
        if (_horizontalLabel) {
            UILabel *horizontalLabel = [[UILabel alloc] initWithFrame:self.bounds];
            horizontalLabel.text = _horizontalLabel;
            horizontalLabel.font = _labelFont ? _labelFont : font;
            horizontalLabel.textColor = _labelColor ? _labelColor : color;
            horizontalLabel.textAlignment = NSTextAlignmentCenter;
            [horizontalLabel sizeToFit];
            horizontalLabel.frame = CGRectMake(self.bounds.origin.x,
                                               self.bounds.origin.y + self.bounds.size.height - horizontalLabel.bounds.size.height,
                                               self.bounds.size.width,
                                               horizontalLabel.bounds.size.height);
            [self addSubview:horizontalLabel];
            
            if (duration) {
                horizontalLabel.alpha = .0f;
                [UIView animateWithDuration:duration
                                      delay:duration * 3
                                    options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^ {
                                     horizontalLabel.alpha = 1.f;
                                 } completion:nil];
            }
        }
        if (_verticalLabel) {
            UILabel *verticalLabel = [[UILabel alloc] initWithFrame:self.bounds];
            verticalLabel.text = _verticalLabel;
            verticalLabel.font = _labelFont ? _labelFont : font;
            verticalLabel.textColor = _labelColor ? _labelColor : color;
            verticalLabel.textAlignment = NSTextAlignmentCenter;
            [verticalLabel sizeToFit];
            verticalLabel.frame = CGRectMake(self.bounds.origin.x,
                                             self.bounds.origin.y,
                                             verticalLabel.bounds.size.height,
                                             self.bounds.size.height);
            [verticalLabel rotateLabel];
            [self addSubview:verticalLabel];
            
            if (duration) {
                verticalLabel.alpha = .0f;
                [UIView animateWithDuration:duration
                                      delay:duration * 3
                                    options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCrossDissolve
                                 animations:^ {
                                     verticalLabel.alpha = 1.f;
                                 } completion:nil];
            }
            
        }
    }
    
    [self addSubview:chartView];
    [self setNeedsDisplay];
    
    itemsCopy = nil;
    pointsCopy = nil;
}
@end
