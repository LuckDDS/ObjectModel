//
//  CanvasView.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CanvasStyle;
NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView<NSCopying>
- (void)buildLineLayerWithStyle:(CanvasStyle *)style withPoint:(CGPoint)point;

- (void)canvasLineWithPoint:(CGPoint)point;

- (CAShapeLayer *)getLayer;

- (UIImage *)buildImage;


- (void)buildEraserPath;
- (void)buildEraserPoints:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
