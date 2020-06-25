//
//  PrototypeController.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import "PrototypeController.h"
#import "CanvasStyle.h"
#import "CanvasViewModel.h"
#import "CanvasView.h"
@interface PrototypeController ()

@end

@implementation PrototypeController
{
    CanvasStyle * canvasStyle;
    CanvasView * canvasView;
    CanvasViewModel * viewModel;
    
    CAShapeLayer *layer;
    
    NSMutableArray * points;
    
    NSMutableArray *layers;
    
    
    NSMutableArray * removerLayers;
    BOOL isEraser;
    
    CGPoint pointT;
    
    NSMutableArray * arrImages;
    
    UIView * testView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    pointT.x = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    layers = [NSMutableArray new];
    removerLayers = [NSMutableArray new];
    arrImages = [NSMutableArray new];
    [self addCanvasView];
    
    UIButton * removebtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    removebtn.backgroundColor = [UIColor redColor];
    [removebtn addTarget:self action:@selector(remove) forControlEvents:(UIControlEventTouchUpInside)];
    [removebtn setTitle:@"◀︎" forState:(UIControlStateNormal)];
    [canvasView addSubview:removebtn];
    
    UIButton * repetbtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 80, 40)];
    repetbtn.backgroundColor = [UIColor redColor];
    [repetbtn setTitle:@"▶︎" forState:(UIControlStateNormal)];
    [repetbtn addTarget:self action:@selector(add) forControlEvents:(UIControlEventTouchUpInside)];
    [canvasView addSubview:repetbtn];
    
    UIButton * eraserbtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 0, 80, 40)];
    eraserbtn.backgroundColor = [UIColor redColor];
    [eraserbtn setTitle:@"橡皮擦" forState:(UIControlStateNormal)];
    [eraserbtn addTarget:self action:@selector(clearView) forControlEvents:(UIControlEventTouchUpInside)];
    [canvasView addSubview:eraserbtn];
    
    testView = [[UIView alloc]initWithFrame:CGRectMake(180, 100, self.view.frame.size.width-180, (self.view.frame.size.width-280)*4.5)];
    testView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testView];
    
    // Do any additional setup after loading the view.
}

- (void)remove{
    CAShapeLayer * layer = layers.lastObject;
    if (layers.count > 0) {
        [removerLayers addObject:layer];
        [layers removeLastObject];
        [layer removeFromSuperlayer];
    }
    
}

- (void)add{
    CAShapeLayer * layer = removerLayers.lastObject;
    if (removerLayers.count > 0) {
        [layers addObject:layer];
        [removerLayers removeLastObject];
        [canvasView.layer addSublayer:layer];
    }
}

- (void)clearView{
    
    isEraser = !isEraser;

}

- (void)addCanvasView{
    
//    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"objc" ofType:@"jpeg"];
//    imageV.image = [UIImage imageWithContentsOfFile:path];
//    [self.view addSubview:imageV];
    
    canvasView = [[CanvasView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height- 60)];
    canvasView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:canvasView];
    
    viewModel = [[CanvasViewModel alloc]init];
    canvasStyle = [viewModel getCanvasLineStyle];
    
}

//开始绘制
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    points = [NSMutableArray new];
    canvasStyle.lineColor = [UIColor blueColor];
    //暂时无用
    [viewModel buildCanvasStyle:canvasStyle];
    
    UITouch *touch = [touches anyObject];
    CGPoint pointTemp = [touch locationInView:canvasView];
    CGPoint point = CGPointMake(pointTemp.x, pointTemp.y-60);
    if (isEraser) {
        NSLog(@"force:%f,\n maximumPossibleForce:%f",touch.force,touch.maximumPossibleForce);
        [canvasView buildEraserPath];
        [canvasView buildEraserPoints:CGPointMake(point.x, point.y+60)];
    }else{
        [points addObject:NSStringFromCGPoint(point)];
        [canvasView buildLineLayerWithStyle:canvasStyle withPoint:point];
    }
    
}
//结束绘制
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [viewModel saveCanvasPath:points];
    if (isEraser) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                long time = [self getDate];
                UIImage * image = [self->canvasView buildImage];
                [self->canvasView setBackgroundColor:[UIColor colorWithPatternImage:image]];
                NSError * err;
                UIImageView * imh = [[UIImageView alloc]initWithFrame:canvasView.frame];
                imh.image = image;
                NSError * error;
               
                
                NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:imh.layer requiringSecureCoding:YES error:&err];
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:tempArchive forKey:@"image"];
                [userDefault synchronize];
                
//                CALayer * canvasLayer = [NSKeyedUnarchiver unarchivedObjectOfClass:[CALayer class] fromData:[userDefault objectForKey:@"image"] error:&error];



//                [layers addObject:tempArchive];
//                [testView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
//                [testView.layer addSublayer:canvasLayer];
                long time1 = [self getDate];
                NSLog(@"%ld",time);
                NSLog(@"%ld",time1);
                NSLog(@"%ld",time1-time);
            });
            
        });


    }else{
        [layers addObject:[canvasView getLayer]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                long time = [self getDate];
                UIImage * image = [self->canvasView buildImage];
                [self->canvasView setBackgroundColor:[UIColor colorWithPatternImage:image]];
                [self remove];
                long time1 = [self getDate];
                NSLog(@"%ld",time);
                NSLog(@"%ld",time1);
                NSLog(@"%ld",time1-time);
            });
            
        });

    }
    
}
- (long)getDate{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    
    return [timeSp longLongValue];
}
//绘制过程
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint pointTemp = [touch locationInView:canvasView];
    CGPoint point = CGPointMake(pointTemp.x, pointTemp.y-60);
    if (pointT.x != point.x || pointT.y != point.y) {
        pointT.x = point.x;
        pointT.y = point.y;
        [points addObject:NSStringFromCGPoint(point)];
        if (isEraser) {
            NSLog(@"force:%f,\n maximumPossibleForce:%f",touch.force,touch.maximumPossibleForce);
            [canvasView buildEraserPoints:CGPointMake(point.x, point.y+60)];
            if (points.count % 2 == 0) {
                [canvasView setNeedsDisplay];
            }
        }else{
            [canvasView canvasLineWithPoint:point];
        }

    }
    
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
