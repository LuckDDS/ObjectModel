//
//  ViewController.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/20.
//  Copyright © 2020 九天. All rights reserved.
//

#import "ViewController.h"
#import "HomeCollectionViewCell.h"
#import "PrototypeController.h"
#import "CGContextController.h"
#import "DSRunTime.h"
#import <objc/runtime.h>
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView * mCollectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout * mCollectionViewLayout;
@property (nonatomic, strong)NSMutableArray * listData;
@property (nonatomic, strong)NSString * kvo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildData];
    [self buildCollectionView];
    _kvo = @"旧";
    NSLog(@"%p",self.kvo);

    [self addObserver];
    
    DSRunTime * ds = [[DSRunTime alloc]init];
    Class s = object_getClass(ds);
    unsigned int count;
    Ivar *list = class_copyIvarList(s, &count);
//    [ds runTimeTest];
    // Do any additional setup after loading the view.
}

- (void)buildCollectionView{
    [self.mCollectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"home"];
    [self.view addSubview:self.mCollectionView];
    
}

- (void)buildData{
    NSArray * arr = @[@"原型模式",@"工厂模式",@"抽象工厂模式"];
    [self.listData addObjectsFromArray:arr];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController * controller;
    if (indexPath.row == 0) {
//        controller = [[PrototypeController alloc]init];
        self.kvo = @"新";
        NSLog(@"%p",self.kvo);
    }else if (indexPath.row == 1){
//        controller = [[CGContextController alloc]init];
    }
//    [self.navigationController pushViewController:controller animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"home" forIndexPath:indexPath];
    cell.label.text = _listData[indexPath.row];
    return cell;
    
}

- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.mCollectionViewLayout];
        _mCollectionView.scrollEnabled = YES;
        _mCollectionView.showsHorizontalScrollIndicator = NO;
        _mCollectionView.showsVerticalScrollIndicator = NO;
        _mCollectionView.delegate = self;
        _mCollectionView.dataSource = self;
        _mCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _mCollectionView;
}

-(UICollectionViewFlowLayout *)mCollectionViewLayout{
    if (!_mCollectionViewLayout) {
        _mCollectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
        _mCollectionViewLayout.itemSize = CGSizeMake(self.view.frame.size.width, 50);
        _mCollectionViewLayout.minimumLineSpacing = 0;
        
    }
    return _mCollectionViewLayout;
}

- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = [NSMutableArray new];
    }
    return _listData;
}














#pragma mark 测试代码

//KVO
- (void)addObserver{
//    [self addObserver:self forKeyPath:@"kvo" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"listData" options:NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:@"self" options:NSKeyValueObservingOptionInitial context:nil];
//    [self.listData mutableArrayValueForKey:@""];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    NSSet * keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"self"]) {
        NSArray * aggectingKeys = @[@"kvo",@"listData"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:aggectingKeys];
    }
    return keyPaths;
}
@end
    
    
