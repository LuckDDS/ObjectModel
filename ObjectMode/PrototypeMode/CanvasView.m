
//
//  CanvasView.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CanvasView.h"
#import "CanvasLayer.h"
#import "CanvasStyle.h"
#import "CanvasBezierPath.h"
@implementation CanvasView
{
    CanvasStyle * lineStyle;
    CAShapeLayer * lineLayer;
    CanvasBezierPath * bezierPath;
    
    NSMutableArray * pointsArr;
    BOOL isEraser;
}
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
        pointsArr = [NSMutableArray new];
    }
    return self;
}

- (void)buildLineLayerWithStyle:(id)style withPoint:(CGPoint)point{
    isEraser = NO;
    [pointsArr removeAllObjects];
    bezierPath = [CanvasBezierPath bezierPath];
    [pointsArr addObject:NSStringFromCGPoint(point)];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    lineStyle = style;
    lineLayer = [CAShapeLayer layer];
    lineLayer.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    lineLayer.shouldRasterize = YES;
    lineLayer.frame = self.frame;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = lineStyle.lineWidth;
    lineLayer.strokeColor = lineStyle.lineColor.CGColor;
    lineLayer.fillColor = lineStyle.fillColor.CGColor;
    lineLayer.lineCap = lineStyle.lineCap;
    lineLayer.lineJoin = lineStyle.lineJoin;
    [self.layer addSublayer:lineLayer];

}

- (void)canvasLineWithPoint:(CGPoint)point{
    [pointsArr addObject:NSStringFromCGPoint(point)];
    lineLayer.path = [bezierPath buildBezierPathWith:pointsArr];
    NSLog(@"11");
}

- (void)buildEraserPath{
    isEraser = YES;
    bezierPath = [CanvasBezierPath bezierPath];
    bezierPath.lineWidth = 15;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    [pointsArr removeAllObjects];
}

- (void)buildEraserPoints:(CGPoint)point{
    [pointsArr addObject:NSStringFromCGPoint(point)];
    [bezierPath buildBezierPathWith:pointsArr];
}

- (void)drawRect:(CGRect)rect{
    if (isEraser) {
        [[UIColor clearColor] setStroke];
        [bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
        [bezierPath stroke];
    }
}

- (UIImage *)buildImage{
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(CAShapeLayer *)getLayer{
    return lineLayer;
}


-(id)copyWithZone:(NSZone *)zone{
    CanvasView * canvasView = [[self class] allocWithZone:zone];
    return canvasView;
}
@end

