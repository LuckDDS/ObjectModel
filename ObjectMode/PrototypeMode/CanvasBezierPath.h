//
//  CanvasBezierPath.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/24.
//  Copyright © 2020 九天. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CanvasBezierPath : UIBezierPath

- (CGPathRef)buildBezierPathWith:(NSMutableArray *)points;

@end

NS_ASSUME_NONNULL_END
