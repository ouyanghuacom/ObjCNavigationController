//
//  PushViewController.m
//  Example
//
//  Created by ouyanghuacom on 2019/12/27.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

@import ObjCNavigationController;

#import <objc/message.h>

#import "ModelCollectionViewCell.h"
#import "PresentViewController.h"
#import "PushViewController.h"

@interface PushViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign) UIInterfaceOrientation orientation;
@property (nonatomic,strong) NSArray                *Models;
@property (nonatomic,strong) UICollectionView       *collectionView;

@end

@implementation PushViewController

//- (void)dealloc{
//    NSLog(@"%@，dealloc",self.title);
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=YES;
//    NSLog(@"%@，viewWillAppear：%@",self.title,@(animated));
//    ((void (*)(id, SEL, UIInterfaceOrientation))(void *) objc_msgSend)([UIDevice currentDevice], NSSelectorFromString(@"setOrientation:"), UIInterfaceOrientationLandscapeRight);
//    [UIViewController attemptRotationToDeviceOrientation];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    NSLog(@"%@，viewDidAppear：%@",self.title,@(animated));
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    NSLog(@"%@，viewWillDisappear：%@",self.title,@(animated));
//    ((void (*)(id, SEL, UIInterfaceOrientation))(void *) objc_msgSend)([UIDevice currentDevice], NSSelectorFromString(@"setOrientation:"), UIInterfaceOrientationPortrait);
//    [UIViewController attemptRotationToDeviceOrientation];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    NSLog(@"%@，viewDidDisappear：%@",self.title,@(animated));
//}

- (NSString*)nextTitle:(int) i{
    return [NSString stringWithFormat:@"%d", (int)self.title.integerValue+i];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title){
        self.title=@"0";
    }
    __weak typeof(self) weakSelf=self;
    self.Models=@[
        ({
            Model *v=[[Model alloc]init];
            v.title=@"pop";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController popViewControllerAnimated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"pop to root";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"push in current context";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController pushViewController:({
                    PushViewController *v= [[PushViewController alloc]init];
                    v.title= [self nextTitle: 1];
                    OCNCPushTransition * transition = [OCNCPushTransition transitionWIthStyle:OCNCTransitionStyleInCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                }) animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"push over current context";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController pushViewController:({
                    PushViewController *v= [[PushViewController alloc]init];
                    v.title= [self nextTitle: 1];
                    OCNCPushTransition * transition = [OCNCPushTransition transitionWIthStyle:OCNCTransitionStyleOverCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                }) animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"present over current context";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController pushViewController:({
                    PresentViewController *v= [[PresentViewController alloc]init];
                    v.title= [self nextTitle: 1];
                    OCNCPresentTransition * transition = [OCNCPresentTransition transitionWIthStyle:OCNCTransitionStyleOverCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                }) animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"push in current context & push over current context";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController pushViewControllers:@[({
                    PushViewController *v= [[PushViewController alloc]init];
                    v.title= [self nextTitle: 1];
                    OCNCPushTransition * transition = [OCNCPushTransition transitionWIthStyle:OCNCTransitionStyleInCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                }),({
                    PushViewController *v= [[PushViewController alloc]init];
                    v.title= [self nextTitle: 2];
                    OCNCPushTransition * transition = [OCNCPushTransition transitionWIthStyle:OCNCTransitionStyleOverCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                })] animated:YES];
            };
            v;
        }),
        ({
            Model *v=[[Model alloc]init];
            v.title=@"push over current context & push in current context";
            v.block=^{
                __strong typeof(weakSelf) self=weakSelf;
                [self.navigationController pushViewControllers:@[({
                    PushViewController *v= [[PushViewController alloc]init];
                    v.title= [self nextTitle: 1];
                    OCNCPushTransition * transition = [OCNCPushTransition transitionWIthStyle:OCNCTransitionStyleOverCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                }),({
                    PushViewController *v= [[PushViewController alloc]init];
                    v.title= [self nextTitle: 2];
                    OCNCPushTransition * transition = [OCNCPushTransition transitionWIthStyle:OCNCTransitionStyleInCurrentContext];
                    v.ocnc_transition = transition;
                    v;
                })] animated:YES];
            };
            v;
        }),
    ];
    UICollectionView  *collectionView=({
        UICollectionViewFlowLayout *layout=({
            UICollectionViewFlowLayout *v=[[UICollectionViewFlowLayout alloc]init];
            v.estimatedItemSize=CGSizeMake(200, 200);
            v.minimumLineSpacing = 20;
            v.minimumInteritemSpacing = 20;
            v;
        });
        UICollectionView *v=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [v registerClass:ModelCollectionViewCell.class forCellWithReuseIdentifier:@"ModelCollectionViewCell"];
        v.dataSource=self;
        v.delegate=self;
        v.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        v;
    });
    [self.view addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]
    ]];
    self.collectionView=collectionView;
    UIView *indicatorView=({
        UILabel *v=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetWidth(self.view.bounds)/2.0-22, 88, 44, 44)];
        v.textAlignment=NSTextAlignmentCenter;
        v.text= @"口";
        CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basicAnimation.byValue = [NSNumber numberWithFloat:M_PI*2];
        basicAnimation.speed=3;
        basicAnimation.duration = 2;
        basicAnimation.repeatCount=HUGE_VALF;
        basicAnimation.removedOnCompletion = NO;
        [v.layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
        v;
    });
    [self.view addSubview:indicatorView];
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.Models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ModelCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = [self.Models[indexPath.item] title];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Model *model=self.Models[indexPath.item];
    model.block();
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.orientation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return 1<<self.orientation;
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)orientation{
    if (_orientation==UIInterfaceOrientationUnknown) _orientation=UIInterfaceOrientationPortrait;
    return _orientation;
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
