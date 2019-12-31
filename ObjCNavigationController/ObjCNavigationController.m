//
//  ObjCNavigationController.m
//  ObjCNavigationController
//
//  Created by ouyanghuacom on 2019/12/27.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import "ObjCNavigationController.h"
#import "NSObject+OCNCPrivate.h"
#import "OCNCTransition+OCNCPrivate.h"
#import "UINavigationController+OCNCPrivate.h"
#import "UIViewController+OCNCPrivate.h"

#ifndef ObjCNavigationControllerDefaultDuration
#define ObjCNavigationControllerDefaultDuration UINavigationControllerHideShowBarDuration
//#define ObjCNavigationControllerDefaultDuration 2
#endif

@interface ObjCNavigationController ()

@property (nonatomic,assign) BOOL             busy;
@property (nonatomic,assign) Class            navigationControllerClass;
@property (nonatomic,weak  ) UIViewController *masterViewController;
@property (nonatomic,strong) NSArray<UINavigationController *> *navigationControllers;

//percent driven interactive transition
@property (nonatomic,assign) CFTimeInterval animationDuration;
@property (nonatomic,assign) CFTimeInterval animationPausedTimeOffset;
@property (nonatomic,assign) CGFloat        animationCompletionSpeed;
@property (nonatomic,strong) CADisplayLink  *displayLink;

@property (nonatomic,copy  ) void(^interactionDidComplete)(void);

@end

@implementation ObjCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithNavigationControllerClass:(nullable Class)navigationControllerClass{
    self=[self init];
    if (!self) return nil;
    self.navigationControllerClass=navigationControllerClass;
    return self;
}

- (instancetype)initWithRootViewController:(__kindof UIViewController *)rootViewController{
    self=[self init];
    if (!self) return nil;
    [self pushViewController:rootViewController animated:NO];
    return self;
}

- (instancetype)initWithViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    self=[self init];
    if (!self) return nil;
    [self pushViewControllers:viewControllers animated:NO];
    return self;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)pushViewController:(__kindof UIViewController *)viewController{
    [self pushViewController:viewController animated:YES];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self pushViewControllers:viewControllers animated:YES];
}

- (nullable __kindof UIViewController *)popViewController{
    return [self popViewControllerAnimated:YES];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    return [self popViewControllerWithDuration:animated?ObjCNavigationControllerDefaultDuration:0 completion:completion];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController{
    return [self popToRootViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController{
    return [self popToViewController:viewController animated:YES];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    [self setViewControllers:viewControllers duration:animated?ObjCNavigationControllerDefaultDuration:0 completion:completion];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    [self pushViewController:viewController duration:animated?ObjCNavigationControllerDefaultDuration:0 completion:completion];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self pushViewControllers:viewControllers animated:animated completion:nil];
}


- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    [self pushViewControllers:viewControllers duration:animated?ObjCNavigationControllerDefaultDuration:0 completion:completion];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [self popViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    return [self popToRootViewControllerWithDuration:animated?ObjCNavigationControllerDefaultDuration:0 completion:completion];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [self popToViewController:viewController animated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    return [self popToRootViewControllerWithDuration:animated?ObjCNavigationControllerDefaultDuration:0 completion:completion];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return;
    }
    self.busy=YES;
    if (viewControllers.count==0){
        self.busy=NO;
        if (completion) completion(NO);
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:viewControllers increasing:NO duration:duration completion:^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        self.busy=NO;
        if (completion) completion(finished);
    }];
}

- (void)pushViewController:(__kindof UIViewController *)viewController duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return;
    }
    self.busy=YES;
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:@[viewController] increasing:YES duration:duration completion:^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        self.busy=NO;
        if (completion) completion(finished);
    }];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return;
    }
    self.busy=YES;
    if (viewControllers.count==0){
        self.busy=NO;
        if (completion) completion(NO);
        return;
    }
    __weak typeof(self) weakSelf=self;
    [self _pushViewControllers:viewControllers increasing:YES duration:duration completion:^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        self.busy=NO;
        if (completion) completion(finished);
    }];
}


- (nullable __kindof UIViewController *)popViewControllerWithDuration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return nil;
    }
    self.busy=YES;
    if (self.viewControllers.count<2){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToIndex:self.viewControllers.count-2 duration:duration completion:^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        self.busy=NO;
        if (completion) completion(finished);
    }].lastObject;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerWithDuration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return nil;
    }
    self.busy=YES;
    if (self.viewControllers.count<2){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToIndex:0 duration:duration completion:^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        self.busy=NO;
        if (completion) completion(finished);
    }];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.busy) {
        if (completion) completion(NO);
        return nil;
    }
    self.busy=YES;
    NSInteger index=[self.viewControllers indexOfObject:viewController];
    if (index==NSNotFound){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    if (index==self.viewControllers.count-1){
        self.busy=NO;
        if (completion) completion(NO);
        return nil;
    }
    __weak typeof(self) weakSelf=self;
    return [self _popToIndex:index duration:duration completion:^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        self.busy=NO;
        if (completion) completion(finished);
    }];
}

- (void)_pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers increasing:(BOOL)increasing duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    
    __weak typeof(self) weakSelf = self;
    BOOL animated = duration>0;
    __block BOOL cancelled = NO;
    
    dispatch_group_t group = animated?dispatch_group_create():NULL;
    
    NSMutableArray <void(^)(void)> *willCancelBlocks= [NSMutableArray array];
    NSMutableArray <void(^)(void)> *didCancelBlocks = [NSMutableArray array];
    NSMutableArray <void(^)(void)> *didFinishBlocks = [NSMutableArray array];
    
    NSArray<UINavigationController *> *oldNavigationControllers = ({
        [self.navigationControllers copy];
    });
    
    NSArray<UINavigationController *> *newNavigationControllers = ({
        NSMutableArray *v = [NSMutableArray arrayWithCapacity:oldNavigationControllers.count+viewControllers.count];
        [v addObjectsFromArray:oldNavigationControllers];
        [v addObjectsFromArray:({
            NSMutableArray *v=[NSMutableArray arrayWithCapacity:viewControllers.count];
            for (NSInteger i = 0, count = viewControllers.count; i<count;i++){
                BOOL backItemVisable = !increasing?(i!=0):i+oldNavigationControllers.count>0;
                [v addObject:[self createNavigationControllerForViewController:viewControllers[i] backItemVisable:backItemVisable]];
            }
            v;
        })];
        v;
    });
    
    NSInteger index = oldNavigationControllers.count;
    
    BOOL visableFlags[newNavigationControllers.count];
    //get  master and flags of all controllers
    {
        UIViewController *newMasterViewController = nil;
        BOOL didGetMaster=NO;
        for (NSInteger newCount = newNavigationControllers.count-1, i=newCount; i>=0; i--){
            if (i==newCount) {
                visableFlags[i]=YES;
            }else{
                UIViewController *nextViewController = newNavigationControllers[i+1];
                if (i>=index) {
                    visableFlags[i]=visableFlags[i+1]?nextViewController.ocnc_transition.style==OCNCTransitionStyleOverCurrentContext:NO;
                }else {
                    visableFlags[i]=increasing?(visableFlags[i+1]?nextViewController.ocnc_transition.style==OCNCTransitionStyleOverCurrentContext:NO):NO;
                }
            }
            if (!visableFlags[i]||didGetMaster) continue;
            newMasterViewController = [newNavigationControllers[i] topViewController];
            if (newMasterViewController.ocnc_master) didGetMaster = YES;
        }
        __weak UIViewController *oldMasterViewController = self.masterViewController;
        self.masterViewController = newMasterViewController;
        [willCancelBlocks addObject:^{
            __strong typeof(weakSelf) self=weakSelf;
            self.masterViewController = oldMasterViewController;
        }];
    }
    
    __block void (^willCancelBlock)(void)=^{
        for (NSInteger i=willCancelBlocks.count-1;i>=0;i--){
            willCancelBlocks[i]();
        }
    };
    
    __block void (^didCancelBlock)(void) = ^{
        __strong typeof(weakSelf) self=weakSelf;
        for (NSInteger i=0,count=didCancelBlocks.count;i<count;i++){
            didCancelBlocks[i]();
        }
        //reverse navigation controllers
        self.navigationControllers = oldNavigationControllers;
        if (completion) completion(NO);
    };
    
    __block void (^didFinishBlock)(void)=^{
        for (NSInteger i=didFinishBlocks.count-1;i>=0;i--){
            didFinishBlocks[i]();
        }
        if (completion) completion(YES);
    };
    
    void (^completeBlock)(BOOL finished) = ^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        if (finished && didFinishBlock) didFinishBlock();
        else if (didCancelBlock) didCancelBlock();
        didCancelBlock = nil;
        didFinishBlock = nil;
        self.interactionDidComplete = nil;
    };
    
    self.interactionDidComplete = ^{
        if (cancelled) completeBlock(!cancelled);
    };
    
    BOOL appeared = self.view.superview?YES:NO;
    for (NSInteger i = 0, count = newNavigationControllers.count; i < count; i++){
        UINavigationController *navigationController = newNavigationControllers[i];
        if (visableFlags[i]) {
            if (!navigationController.parentViewController){
                if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                [self ocnc_addChildViewController:navigationController];
                [self.view addSubview:navigationController.view];
                navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
                [self.view addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                ]];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [navigationController didMoveToParentViewController:self];
                    [navigationController willMoveToParentViewController:nil];
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [didFinishBlocks addObject:^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [navigationController didMoveToParentViewController:self];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
            }
        }else{
            if (navigationController.parentViewController){
                if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                [navigationController willMoveToParentViewController:nil];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    __strong typeof(weakSelf) self=weakSelf;
                    if(appeared) [navigationController endAppearanceTransition];
                    [navigationController removeFromParentViewController];
                    [self ocnc_addChildViewController:navigationController];
                    [navigationController didMoveToParentViewController:self];
                }];
                [didFinishBlocks addObject:^{
                    if(appeared) [navigationController endAppearanceTransition];
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                }];
            }
        }
        if (animated){
            if (i>=index){
                __weak OCNCTransition *transition = navigationController.ocnc_transition;
                transition.navigationController = self;
                transition.fromViewController   = i>0?newNavigationControllers[i-1]:nil;
                transition.toViewController     = navigationController;
                transition.viewController       = navigationController;
                transition.interactionCancelledBlock = ^BOOL{
                    return cancelled;
                };
                transition.startInteractionBlock = ^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [self startInteractionWithDuration:duration];
                };
                transition.updateInteractionBlock = ^(CGFloat progress) {
                    __strong typeof(weakSelf) self=weakSelf;
                    [self updateInteractionProgress:progress];
                };
                transition.cancelInteractionBlock = ^(CGFloat speed) {
                    __strong typeof(weakSelf) self=weakSelf;
                    if (!cancelled) cancelled = YES;
                    if (willCancelBlock){
                        willCancelBlock();
                        willCancelBlock = nil;
                    }
                    [self cancelInteractionWithSpeed:speed];
                };
                transition.finishInteractionBlock = ^(CGFloat speed) {
                    __strong typeof(weakSelf) self=weakSelf;
                    [self finishInteractionWithSpeed:speed];
                };
                transition.completeBlock = ^(BOOL finished) {
                    dispatch_group_leave(group);
                    transition.startInteractionBlock = nil;
                    transition.updateInteractionBlock = nil;
                    transition.cancelInteractionBlock = nil;
                    transition.finishInteractionBlock = nil;
                    transition.completeBlock = nil;
                };
                [didCancelBlocks addObject:^{
                    [transition complete:NO];
                }];
                [didFinishBlocks addObject:^{
                    [transition complete:YES];
                }];
                dispatch_group_enter(group);
                [transition startTransition:duration];
            }
        }
    }
    if (!increasing){
        self.navigationControllers = [newNavigationControllers subarrayWithRange:NSMakeRange(index, viewControllers.count)];
    }else{
        self.navigationControllers = newNavigationControllers;
    }
    if (animated){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_sync(dispatch_get_main_queue(), ^{
                completeBlock(!cancelled);
            });
        });
    }else{
        didFinishBlock();
    }
}

- (nullable NSArray<UIViewController *> *)_popToIndex:(NSInteger)index duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion{
    __weak typeof(self) weakSelf=self;
    BOOL animated = duration>0;
    __block BOOL cancelled = NO;
    
    dispatch_group_t group = animated?dispatch_group_create():NULL;
    
    NSMutableArray <void(^)(void)> *willCancelBlocks = [NSMutableArray array];
    NSMutableArray <void(^)(void)> *didCancelBlocks  = [NSMutableArray array];
    NSMutableArray <void(^)(void)> *didFinishBlocks  = [NSMutableArray array];
    
    NSArray<UINavigationController*> *oldNavigationControllers = ({
        [self.navigationControllers copy];
    });
    NSArray *popedNavigationControllers=({
        NSRange range = NSMakeRange(index+1, oldNavigationControllers.count-index-1);
        [oldNavigationControllers subarrayWithRange:range];
    });
    
    BOOL visableFlags[oldNavigationControllers.count];
    {
        UIViewController *newMasterViewController=nil;
        BOOL didGetMaster = NO;
        for (NSInteger i=oldNavigationControllers.count-1;i>=0;i--){
            visableFlags[i]=NO;
            if (i==index) visableFlags[i]=YES;
            else if (i>index) visableFlags[i]=NO;
            else{
                UIViewController *nextViewController = self.navigationControllers[i+1];
                visableFlags[i]=visableFlags[i+1]?nextViewController.ocnc_transition.style==OCNCTransitionStyleOverCurrentContext:NO;
            }
            if (!visableFlags[i]||didGetMaster) continue;
            newMasterViewController=[oldNavigationControllers[i] topViewController];
            if (newMasterViewController.ocnc_master) didGetMaster=YES;
        }
        {
            __weak UIViewController *oldMasterViewController=self.masterViewController;
            self.masterViewController=newMasterViewController;
            [willCancelBlocks addObject:^{
                __strong typeof(weakSelf) self=weakSelf;
                self.masterViewController=oldMasterViewController;
            }];
        }
    }
    __block void(^willCancelBlock)(void)=^{
        for (NSInteger i = willCancelBlocks.count-1;i>=0;i--){
            willCancelBlocks[i]();
        }
    };
    __block void(^didCancelBlock)(void)=^{
        __strong typeof(weakSelf) self = weakSelf;
        self.navigationControllers = oldNavigationControllers;
        for (NSInteger i = 0,count = didCancelBlocks.count;i<count;i++){
            didCancelBlocks[i]();
        }
        if (completion) completion(NO);
    };
    __block void(^didFinishBlock)(void)=^{
        for (NSInteger i = didFinishBlocks.count-1;i>=0;i--){
            didFinishBlocks[i]();
        }
        if (completion) completion(YES);
    };
    void (^completeBlock) (BOOL finished) = ^(BOOL finished){
        __strong typeof(weakSelf) self=weakSelf;
        if (finished && didFinishBlock) didFinishBlock();
        else if (didCancelBlock) didCancelBlock();
        didCancelBlock = nil;
        didFinishBlock = nil;
        self.interactionDidComplete = nil;
    };
    self.interactionDidComplete = ^{
        if (cancelled) completeBlock(!cancelled);
    };
    BOOL appeared = self.view.superview?YES:NO;
    for (NSInteger i=oldNavigationControllers.count-1;i>=0;i--){
        UINavigationController *navigationController=oldNavigationControllers[i];
        if (visableFlags[i]) {
            if (!navigationController.parentViewController){
                [self ocnc_addChildViewController:navigationController];
                if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                [self.view insertSubview:navigationController.view atIndex:0];
                navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
                [self.view addConstraints:@[
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                    [NSLayoutConstraint constraintWithItem:navigationController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
                ]];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:NO animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [navigationController didMoveToParentViewController:self];
                    [navigationController willMoveToParentViewController:nil];
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [didFinishBlocks addObject:^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [navigationController didMoveToParentViewController:self];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
            }
        }else{
            if (navigationController.parentViewController){
                [navigationController beginAppearanceTransition:NO animated:animated];
                [navigationController willMoveToParentViewController:nil];
                [willCancelBlocks addObject:^{
                    if(appeared) [navigationController beginAppearanceTransition:YES animated:animated];
                }];
                [didCancelBlocks addObject:^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [navigationController removeFromParentViewController];
                    [self ocnc_addChildViewController:navigationController];
                    [navigationController didMoveToParentViewController:self];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
                [didFinishBlocks addObject:^{
                    [navigationController.view removeFromSuperview];
                    [navigationController removeFromParentViewController];
                    if(appeared) [navigationController endAppearanceTransition];
                }];
            }
        }
        if (animated){
            if (i>index){
                __weak OCNCTransition *transition = navigationController.ocnc_transition;
                transition.navigationController = self;
                transition.fromViewController   = navigationController;
                transition.toViewController     = oldNavigationControllers[i-1];
                transition.viewController       = navigationController;
                transition.interactionCancelledBlock = ^BOOL{
                    return cancelled;
                };
                transition.startInteractionBlock = ^{
                    __strong typeof(weakSelf) self=weakSelf;
                    [self startInteractionWithDuration:duration];
                };
                transition.updateInteractionBlock = ^(CGFloat progress) {
                    __strong typeof(weakSelf) self=weakSelf;
                    [self updateInteractionProgress:progress];
                };
                transition.cancelInteractionBlock = ^(CGFloat speed) {
                    __strong typeof(weakSelf) self=weakSelf;
                    if (!cancelled) cancelled = YES;
                    if (willCancelBlock){
                        willCancelBlock();
                        willCancelBlock = nil;
                    }
                    [self cancelInteractionWithSpeed:speed];
                };
                transition.finishInteractionBlock = ^(CGFloat speed) {
                    __strong typeof(weakSelf) self=weakSelf;
                    [self finishInteractionWithSpeed:speed];
                };
                transition.completeBlock = ^(BOOL finished) {
                    dispatch_group_leave(group);
                    transition.startInteractionBlock = nil;
                    transition.updateInteractionBlock = nil;
                    transition.cancelInteractionBlock = nil;
                    transition.finishInteractionBlock = nil;
                    transition.completeBlock = nil;
                };
                [didCancelBlocks addObject:^{
                    [transition complete:NO];
                }];
                [didFinishBlocks addObject:^{
                    [transition complete:YES];
                }];
                dispatch_group_enter(group);
                [transition startTransition:duration];
            }
        }
    }
    self.navigationControllers = [oldNavigationControllers subarrayWithRange:NSMakeRange(0, index+1)];
    if (animated){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_sync(dispatch_get_main_queue(), ^{
                completeBlock(!cancelled);
            });
        });
    }else{
        didFinishBlock();
    }
    return ({
        NSMutableArray *v = [NSMutableArray array];
        [popedNavigationControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [v addObject:[obj topViewController]];
        }];
        v;
    });
}

- (void)startInteractionWithDuration:(CFTimeInterval)duration{
    if (self.displayLink) return;
    self.animationDuration=duration;
    CALayer *layer = self.view.layer;
    layer.speed = 0.0;
    layer.timeOffset = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.animationPausedTimeOffset = layer.timeOffset;
}

- (void)updateInteractionProgress:(CGFloat)progress{
    progress=fmax(fmin(progress, 1), 0);
    CALayer *layer = self.view.layer;
    layer.timeOffset = self.animationPausedTimeOffset + self.animationDuration * progress;
}

- (void)finishInteractionWithSpeed:(CGFloat)speed{
    if (self.displayLink) return;
    self.animationCompletionSpeed=speed;
    self.displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(finishingRender)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)cancelInteractionWithSpeed:(CGFloat)speed{
    if (self.displayLink) return;
    self.animationCompletionSpeed=speed;
    self.displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(cancellingRender)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)recoverLayer{
    if (!self.displayLink) return;
    [self.displayLink invalidate];
    self.displayLink=nil;
    CALayer *layer = self.view.layer;
    layer.beginTime = 0;
    layer.speed = 1.0;
    layer.beginTime = CACurrentMediaTime()-self.animationDuration;
    layer.timeOffset = CACurrentMediaTime();
    if (self.interactionDidComplete){
        self.interactionDidComplete();
    }
    layer.beginTime=0;
    layer.timeOffset=0;
}

- (void)finishingRender{
    CALayer *layer = self.view.layer;
    CFTimeInterval duration  = self.displayLink.duration;
    CFTimeInterval timeOffset = layer.timeOffset+duration*self.animationCompletionSpeed;
    CFTimeInterval targetTimeOffset = self.animationPausedTimeOffset+self.animationDuration;
    if (timeOffset < targetTimeOffset){
        layer.timeOffset=timeOffset;
        return;
    }
    layer.timeOffset=targetTimeOffset;
    [self recoverLayer];
}

- (void)cancellingRender{
    CALayer *layer = self.view.layer;
    CFTimeInterval duration  = self.displayLink.duration;
    CFTimeInterval timeOffset=layer.timeOffset-duration*self.animationCompletionSpeed;
    if (timeOffset > self.animationPausedTimeOffset){
        layer.timeOffset=timeOffset;
        return;
    }
    layer.timeOffset=self.animationPausedTimeOffset;
    [self recoverLayer];
}


#pragma mark --
#pragma mark -- create new navigationController from navigationController class

- (__kindof UINavigationController*)createNavigationControllerForViewController:(UIViewController*)viewController backItemVisable:(BOOL)backItemVisable{
    UINavigationController *navigationController = [[self.navigationControllerClass alloc]init];
    [navigationController ocnc_original_setViewControllers:backItemVisable?@[[[UIViewController alloc]init],viewController]:@[viewController] animated:NO];
    navigationController.ocnc_navigationController=self;
    navigationController.view.backgroundColor = [UIColor clearColor];
    return navigationController;
}

#pragma mark --
#pragma mark -- getter

- (Class)navigationControllerClass{
    if (_navigationControllerClass) return _navigationControllerClass;
    return UINavigationController.class;
}

- (NSArray<UIViewController*>*)viewControllers{
    NSMutableArray *v = [NSMutableArray array];
    [self.navigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [v addObject:obj.topViewController];
    }];
    return v;
}

#pragma mark --
#pragma mark -- override

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIViewController *viewController in self.childViewControllers){
        [viewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    for (UIViewController *viewController in self.childViewControllers){
        [viewController endAppearanceTransition];
    }
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIViewController *viewController in self.childViewControllers){
        [viewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    for (UIViewController *viewController in self.childViewControllers){
        [viewController endAppearanceTransition];
    }
    [super viewDidDisappear:animated];
}


- (void)ocnc_addChildViewController:(UIViewController *)childController{
    NSAssert(0, @"Do not call this method directly");
    return;
}

- (void)setMasterViewController:(UIViewController *)masterViewController{
    if (_masterViewController==masterViewController) return;
    _masterViewController=masterViewController;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)shouldAutorotate{
    if (!self.masterViewController) return [super shouldAutorotate];
    return [self.masterViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (!self.masterViewController) return [super supportedInterfaceOrientations];
    return [self.masterViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if (!self.masterViewController) return [super preferredInterfaceOrientationForPresentation];
    return [self.masterViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)prefersStatusBarHidden{
    if (!self.masterViewController) return [super prefersStatusBarHidden];
    return [self.masterViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (!self.masterViewController) return [super preferredStatusBarStyle];
    return [self.masterViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    if (!self.masterViewController) return [super preferredStatusBarUpdateAnimation];
    return [self.masterViewController preferredStatusBarUpdateAnimation];
}

- (UIViewController*)topViewController{
    return self.viewControllers.lastObject;
}

+ (void)load{
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(addChildViewController:) alteredMethod:@selector(ocnc_addChildViewController:)];
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
