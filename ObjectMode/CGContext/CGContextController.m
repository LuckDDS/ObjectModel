//
//  CGContextController.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/22.
//  Copyright © 2020 九天. All rights reserved.
//

#import "CGContextController.h"
#import "CGContextView.h"
@interface CGContextController ()

@end

@implementation CGContextController
{
    CGContextView * contextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    contextView = [[CGContextView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    contextView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contextView];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(point));
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
