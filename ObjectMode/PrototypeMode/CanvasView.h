//
//  CanvasView.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CanvasBrushStyle;
NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView<NSCopying>

- (void)setBrushStyle:(CanvasBrushStyle *)style;

- (void)setLineLayerWithPoint:(CGPoint)point;

- (void)canvasLineWithPoint:(CGPoint)point;

- (CAShapeLayer *)getLayer;

- (UIImage *)buildImage;


- (void)buildEraserPath;
- (void)buildEraserPoints:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
