//
//  CanvasStyle.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CanvasStyle : NSObject<NSCopying>
//线条颜色
@property (nonatomic, strong) UIColor * lineColor;
//线条宽度
@property (nonatomic, assign) float lineWidth;

@property (nonatomic, strong) UIBezierPath * path;

//链接样式
@property (nonatomic, assign) CAShapeLayerLineJoin lineJoin;
//起点样式
@property (nonatomic, assign) CAShapeLayerLineCap lineCap;

@property (nonatomic, strong) UIColor * fillColor;

@property (nonatomic, strong) NSMutableArray * points;


@end

NS_ASSUME_NONNULL_END
