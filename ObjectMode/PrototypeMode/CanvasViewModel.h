//
//  CanvasViewModel.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CanvasStyle;
NS_ASSUME_NONNULL_BEGIN

@interface CanvasViewModel : UIView

/// 构建线条样式
/// @param canvasStyle 线条样式
- (void)buildCanvasStyle:(CanvasStyle *)canvasStyle;

/// 一条path绘制结束
- (void)saveCanvasPath:(NSMutableArray *)points;

/// 移除path
- (void)removePath;

- (CanvasStyle*)getCanvasLineStyle;
@end

NS_ASSUME_NONNULL_END
