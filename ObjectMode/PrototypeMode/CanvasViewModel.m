//
//  CanvasViewModel.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CanvasViewModel.h"
#import "CanvasBrushStyle.h"
@interface CanvasViewModel()


@end

@implementation CanvasViewModel
{
    CanvasBrushStyle * _canvasStyle;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _canvasStyle = [CanvasBrushStyle new];
        _canvasStyle.lineColor = [UIColor blueColor];
        _canvasStyle.lineWidth = 12.0;
        _canvasStyle.fillColor = [UIColor clearColor];
        _canvasStyle.lineJoin = kCALineJoinRound;
        _canvasStyle.lineCap = kCALineCapRound;

    }
    return self;
}

- (CanvasBrushStyle *)getCanvasLineStyle{
    return _canvasStyle;
}

@end
