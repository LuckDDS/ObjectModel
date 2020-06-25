//
//  CanvasViewModel.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CanvasViewModel.h"
#import "CanvasStyle.h"
@interface CanvasViewModel()


@end

@implementation CanvasViewModel
{
    NSMutableArray * allPath;
    CanvasStyle * _canvasStyle;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        allPath = [[NSMutableArray alloc]init];
        _canvasStyle = [CanvasStyle new];
        _canvasStyle.lineColor = [UIColor blueColor];
        _canvasStyle.lineWidth = 62.0;
        _canvasStyle.fillColor = [UIColor clearColor];
        _canvasStyle.lineJoin = kCALineJoinRound;
        _canvasStyle.lineCap = kCALineCapRound;

    }
    return self;
}

- (void)buildCanvasStyle:(CanvasStyle *)canvasStyle{
    _canvasStyle = [canvasStyle copy];
}

- (void)removePath{
    if (allPath.count > 0) {
        [allPath removeLastObject];
    }
}

- (void)saveCanvasPath:(NSMutableArray *)points{
    _canvasStyle.points = [points copy];
    [allPath addObject:_canvasStyle];
}

- (CanvasStyle *)getCanvasLineStyle{
    return _canvasStyle;
}

@end
