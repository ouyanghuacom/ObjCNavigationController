//
//  OCNCTransition.m
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+OCNCPrivate.h"

#import "OCNCTransition.h"

@interface OCNCTransition()

@property (nonatomic, weak) ObjCNavigationController *navigationController;
@property (nonatomic, weak) UINavigationController   *viewController;
@property (nonatomic, weak) UINavigationController   *fromViewController;
@property (nonatomic, weak) UINavigationController   *toViewController;

@property (nonatomic,copy) void(^completeBlock)(BOOL finished);
@property (nonatomic,copy) BOOL(^interactionCancelledBlock)(void);
@property (nonatomic,copy) void(^startInteractionBlock)(void);
@property (nonatomic,copy) void(^updateInteractionBlock)(CGFloat progress);
@property (nonatomic,copy) void(^cancelInteractionBlock)(CGFloat speed);
@property (nonatomic,copy) void(^finishInteractionBlock)(CGFloat speed);

@end

@implementation OCNCTransition

+ (instancetype)transitionWIthStyle:(OCNCTransitionStyle)style{
    OCNCTransition *transition = [[self alloc]init];
    if (!transition) return nil;
    transition.style = style;
    return transition;
}

- (void)complete:(BOOL)finished{
    if (!self.completeBlock) return;
    if (@available(iOS 9, *)) {
        
    } else {
        [self fixNavigationBarPosition];
    }
    self.completeBlock(finished);
}

- (void)startTransition:(CFTimeInterval)duration{
    [self complete:YES];
}

- (void)startInteraction{
    self.startInteractionBlock();
}

- (void)updateInteraction:(CGFloat)progress{
    self.updateInteractionBlock(progress);
}

- (void)cancelInteraction:(CGFloat)speed{
    self.cancelInteractionBlock(speed);
}

- (void)finishInteraction:(CGFloat)speed{
    self.finishInteractionBlock(speed);
}

- (BOOL)interactionCancelled{
    if (self.interactionCancelledBlock) return self.interactionCancelledBlock();
    return NO;
}

- (void)fixNavigationBarPosition{
    if (self.fromViewController!=self.viewController) return;
    UINavigationController *v=(UINavigationController*)self.viewController;
    BOOL navigationBarHidden=v.navigationBarHidden;
    v.navigationBarHidden=!navigationBarHidden;
    v.navigationBarHidden=navigationBarHidden;
}

@end

