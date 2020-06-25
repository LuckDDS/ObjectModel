//
//  CanvasStyle.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CanvasStyle.h"

@implementation CanvasStyle


- (id)copyWithZone:(NSZone *)zone{
    
    CanvasStyle * style = [[CanvasStyle allocWithZone:zone]init];
    style.lineColor = [self.lineColor copy];
    style.lineWidth = self.lineWidth;
    style.path = self.path;
    style.fillColor = [self.fillColor copy];
    style.lineCap = self.lineCap;
    style.lineJoin = self.lineJoin;
    style.points = [self.points copy];
    
    return style;
}

@end
