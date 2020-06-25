//
//  CGContextView.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/22.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CGContextView.h"

@implementation CGContextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self testPath];
    }
    return self;
}

- (void)testPath{
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:CGPointMake(100, 300)];
    
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    lineLayer.shouldRasterize = YES;
    lineLayer.frame = self.frame;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.path = path.CGPath;
    lineLayer.lineWidth = 2;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = [UIColor blackColor].CGColor;
    
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinMiter;
    lineLayer.miterLimit = 20;
    [self.layer addSublayer:lineLayer];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            lineLayer.path = [self buildPath:path];
        });
    });

}
- (CGPathRef)buildPath:(UIBezierPath*)path{
    NSArray * pointsX = @[@"220",@"210.5",@"199",@"183",@"167.5",@"149.5",@"134",@"121.5",@"113",@"110.5",@"111",@"122",@"140.5",@"162",@"191.5",@"228.5"];
    NSArray * pointsY = @[@"125",@"125",@"125",@"128.5",@"139",@"156",@"176.5",@"200.5",@"226",@"251",@"275.5",@"295.5",@"310.5",@"319.5",@"321.5",@"317.5"];
//    UIBezierPath * path = [UIBezierPath bezierPath];
    NSMutableArray * xArr = [NSMutableArray new];
    NSMutableArray * yArr = [NSMutableArray new];

    for (int m = 0; m < pointsX.count-1; m ++) {
        float x = [pointsX[m] floatValue];
        float x1 = [pointsX[m + 1] floatValue];
        
        float y = [pointsY[m] floatValue];
        float y1 = [pointsY[m + 1] floatValue];
        [xArr addObject:[NSString stringWithFormat:@"%f",(x + x1)/2]];
        [yArr addObject:[NSString stringWithFormat:@"%f",(y + y1)/2]];
    }
    
    
    for (int m = 0; m < xArr.count-4; m ++) {
        [self getControlPointx0:[xArr[m] floatValue] andy0:[yArr[m] floatValue] x1:[xArr[m+1] floatValue] andy1:[yArr[m +1] floatValue] x2:[xArr[m+2] floatValue] andy2:[yArr[m + 2] floatValue] x3:[xArr[m +3] floatValue] andy3:[yArr[m +3] floatValue] path:path];
    }
    
    return path.CGPath;

}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.6;
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
    [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}
//在点中间添加点
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
- (UIBezierPath *)smoothedPathWithPoints:(NSMutableArray *) pointArray andGranularity:(NSInteger)granularity {
    
    NSMutableArray *points = [pointArray mutableCopy];
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;// 1/1000
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    smoothedPath.flatness = 0.2;
    return smoothedPath;
}



- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginTransparencyLayer(context,NULL);
    UIBezierPath * currentPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 200)];
    
    CGContextAddPath(context,currentPath.CGPath);
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,100);
    CGContextSetBlendMode(context,kCGBlendModeClear);
    CGContextSetStrokeColorWithColor(context,[[UIColor clearColor] CGColor]);
    CGContextStrokePath(context);
    CGContextEndTransparencyLayer(context);
    
}



- (UIBezierPath *)quadCurvedPathWithPoints:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];

    if (points.count == 2) {
        value = points[1];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
        return path;
    }

    for (NSUInteger i = 1; i < points.count; i++) {
        value = points[i];
        CGPoint p2 = [value CGPointValue];

        CGPoint midPoint = midPointForPoints(p1, p2);
        [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
        [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];

        p1 = p2;
    }
    return path;
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    CGFloat diffY = fabs(p2.y - controlPoint.y);

    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;

    return controlPoint;
}



@end
