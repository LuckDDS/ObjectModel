//
//  PrototypeController.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/21.
//  Copyright © 2020 九天. All rights reserved.
//

#import "PrototypeController.h"
#import "CanvasBrushStyle.h"
#import "CanvasViewModel.h"
#import "CanvasView.h"
@interface PrototypeController ()

@end

@implementation PrototypeController
{
    CanvasBrushStyle * canvasBrushStyle;
    CanvasView * canvasView;
    CanvasViewModel * viewModel;
    
    CAShapeLayer *layer;
    
    NSMutableArray *layers;
    NSMutableArray * removerLayers;
    
    NSMutableArray * allLayerType;
    NSMutableArray * removerLayerType;

    
    BOOL isEraser;
    
    CGPoint pointT;
    
    NSMutableArray * arrImages;
    
    CanvasView * tempView;
    UIImageView * imageView;
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    pointT.x = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    layers = [NSMutableArray new];
    removerLayers = [NSMutableArray new];
    arrImages = [NSMutableArray new];
    allLayerType = [NSMutableArray new];
    removerLayerType = [NSMutableArray new];
    [self addCanvasView];
    
    //撤销按钮
    UIButton * undoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 60, 80, 40)];
    undoBtn.backgroundColor = [UIColor redColor];
    [undoBtn addTarget:self action:@selector(undoOperate) forControlEvents:(UIControlEventTouchUpInside)];
    [undoBtn setTitle:@"◀︎" forState:(UIControlStateNormal)];
    [self.view addSubview:undoBtn];
    //恢复按钮
    UIButton * redoBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 60, 80, 40)];
    redoBtn.backgroundColor = [UIColor redColor];
    [redoBtn setTitle:@"▶︎" forState:(UIControlStateNormal)];
    [redoBtn addTarget:self action:@selector(redoOperate) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:redoBtn];
    //橡皮擦
    UIButton * eraserBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 60, 80, 40)];
    eraserBtn.backgroundColor = [UIColor redColor];
    [eraserBtn setTitle:@"橡皮擦" forState:(UIControlStateNormal)];
    [eraserBtn addTarget:self action:@selector(eraserLayer) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:eraserBtn];
    
    
    tempView = [[CanvasView alloc]initWithFrame:canvasView.frame];
    // Do any additional setup after loading the view.
}
//撤销操作
- (void)undoOperate{
    
    if (allLayerType.count > 1) {
        
        NSString * previousStr = allLayerType[allLayerType.count - 2];
        [removerLayerType addObject:allLayerType.lastObject];
        [allLayerType removeLastObject];
        if ([previousStr isEqualToString:@"1"]) {
            CAShapeLayer * layer = layers.lastObject;
            if (layers.count > 0) {
                [removerLayers addObject:layer];
                [layers removeLastObject];
                [layer removeFromSuperlayer];
            }
            UIImage * image = [tempView buildImage];
            [canvasView setBackgroundColor:[UIColor clearColor]];
            for (CALayer * layer in canvasView.layer.sublayers) {
                [layer removeFromSuperlayer];
            }
            [canvasView setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }else{
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            NSError * error;
            CALayer * canvasLayer = [NSKeyedUnarchiver unarchivedObjectOfClass:[CALayer class] fromData:[userDefault objectForKey:previousStr] error:&error];
            [canvasView setBackgroundColor:[UIColor clearColor]];
            for (CALayer * layer in canvasView.layer.sublayers) {
                [layer removeFromSuperlayer];
            }
            [canvasView.layer addSublayer:canvasLayer];
        }

    }else{
        
        
        
    }
    
}
//删除canvasview的子layer,将layer添加到等待层
- (void)removeSubLayer{
    
    CAShapeLayer * layer = layers.lastObject;
    [layer removeFromSuperlayer];
    [tempView.layer addSublayer:layer];
}

//恢复操作
- (void)redoOperate{
    
    CAShapeLayer * layer = removerLayers.lastObject;
    if (removerLayers.count > 0) {
        [layers addObject:layer];
        [removerLayers removeLastObject];
        [canvasView.layer addSublayer:layer];
    }
}
//橡皮擦
- (void)eraserLayer{
    
    isEraser = !isEraser;
    
}

- (void)addCanvasView{
    //背景图
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"objc" ofType:@"jpeg"];
    imageV.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:imageV];
    //画板
    canvasView = [[CanvasView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height- 60)];
    canvasView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:canvasView];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, canvasView.frame.size.width, canvasView.frame.size.height)];
    //画笔样式
    viewModel = [[CanvasViewModel alloc]init];
    canvasBrushStyle = [viewModel getCanvasLineStyle];
    [canvasView setBrushStyle:canvasBrushStyle];
    
}

//开始绘制
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint pointTemp = [touch locationInView:canvasView];
    CGPoint point = CGPointMake(pointTemp.x, pointTemp.y-60);
    
    if (isEraser) {
        NSLog(@"force:%f,\n maximumPossibleForce:%f",touch.force,touch.maximumPossibleForce);
        [canvasView buildEraserPath];
        [canvasView buildEraserPoints:CGPointMake(point.x, point.y+60)];
    }else{
        [canvasView setLineLayerWithPoint:point];
    }
    
}

//结束绘制
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (isEraser) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                long time = [self getDate];
                UIImage * image = [self->canvasView buildImage];
                [self->canvasView setBackgroundColor:[UIColor colorWithPatternImage:image]];
                self->imageView.image = image;
                NSError * error;
                NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self->imageView.layer requiringSecureCoding:YES error:&error];
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                NSString * currentTime = [NSString stringWithFormat:@"%ld",time];
                [userDefault setObject:tempArchive forKey:currentTime];
                [userDefault synchronize];
                [self->allLayerType addObject:currentTime];
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
//                [self removeSubLayer];
                [self->allLayerType addObject:@"1"];
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
        if (isEraser) {
            
            [canvasView buildEraserPoints:CGPointMake(point.x, point.y+60)];
            [canvasView setNeedsDisplay];
            
        }else{
            NSLog(@"force:%f,\n maximumPossibleForce:%f",touch.force,touch.maximumPossibleForce);
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
