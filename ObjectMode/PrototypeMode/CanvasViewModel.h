//
//  CanvasViewModel.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CanvasBrushStyle;
NS_ASSUME_NONNULL_BEGIN

@interface CanvasViewModel : UIView


/// 获取画笔样式
- (CanvasBrushStyle*)getCanvasLineStyle;
@end

NS_ASSUME_NONNULL_END
