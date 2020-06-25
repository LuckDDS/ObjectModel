//
//  CanvasBezierPath.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/24.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CanvasBezierPath.h"

@implementation CanvasBezierPath

- (CGPathRef)buildBezierPathWith:(NSMutableArray *)pointsArr{
    
    if (pointsArr.count == 2) {
        [self moveToPoint:CGPointFromString(pointsArr.lastObject)];
        float x = CGPointFromString(pointsArr[0]).x;
        float x1 = CGPointFromString(pointsArr[1]).x;
        float y = CGPointFromString(pointsArr[0]).y;
        float y1 = CGPointFromString(pointsArr[1]).y;
        float pointx = 0;
        float pointy = 0;
        pointx = x - (x1 - x)/2;
        pointy = y - (y1 - y)/2;
        [pointsArr insertObject:NSStringFromCGPoint(CGPointMake(pointx, pointy)) atIndex:0];
    }
    
    NSMutableArray * xArr = [NSMutableArray new];
    NSMutableArray * yArr = [NSMutableArray new];
    if (pointsArr.count > 4) {
        for (int m = 5; m > 1; m --) {
            @autoreleasepool {
                float x = CGPointFromString(pointsArr[pointsArr.count-m]).x;
                float x1 = CGPointFromString(pointsArr[pointsArr.count-m+1]).x;
                float y = CGPointFromString(pointsArr[pointsArr.count-m]).y;
                float y1 = CGPointFromString(pointsArr[pointsArr.count-m+1]).y;
                [xArr addObject:[NSString stringWithFormat:@"%f",(x + x1)/2]];
                [yArr addObject:[NSString stringWithFormat:@"%f",(y + y1)/2]];
            }
        }
    }
  
    if (xArr.count > 3) {
        [self getControlPointx0:[xArr[xArr.count-4] floatValue] andy0:[yArr[yArr.count-4] floatValue] x1:[xArr[xArr.count-3] floatValue] andy1:[yArr[yArr.count-3] floatValue] x2:[xArr[xArr.count-2] floatValue] andy2:[yArr[yArr.count-2] floatValue] x3:[xArr[xArr.count-1] floatValue] andy3:[yArr[yArr.count-1] floatValue]];
    }
    return self.CGPath;
}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
{
    @autoreleasepool {
        //smooth_value光滑度
        CGFloat smooth_value =0.75;
        CGFloat ctrl1_x;
        CGFloat ctrl1_y;
        CGFloat ctrl2_x;
        CGFloat ctrl2_y;
        CGFloat xc1 = (x0 + x1) /2.0;
        CGFloat yc1 = (y0 + y1) /2.0;
        CGFloat xc2 = (x1 + x2) /2.0;
        CGFloat yc2 = (y1 + y2) /2.0;
        CGFloat xc3 = (x2 + x3) /2.0;
        CGFloat yc3 = (y2 + y3) /2.0;
        CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
        CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
        CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
        CGFloat k1 = len1 / (len1 + len2);
        CGFloat k2 = len2 / (len2 + len3);
        CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
        CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
        CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
        CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
        ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
        [self addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];

    }
    
}

@end
