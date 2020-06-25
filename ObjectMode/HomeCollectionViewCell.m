//
//  HomeCollectionViewCell.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/20.
//  Copyright © 2020 九天. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.backgroundColor = [UIColor whiteColor];
        _label.textColor = [UIColor colorWithRed:107/255.0 green:175/255.0 blue:225/255.0 alpha:1.0];
        [self addSubview:_label];
    }
    return self;
}
@end
