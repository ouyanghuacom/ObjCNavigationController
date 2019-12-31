//
//  OCNCTransition.h
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

@import UIKit;

@class ObjCNavigationController;

typedef NS_ENUM(NSInteger,OCNCTransitionStyle) {
    OCNCTransitionStyleInCurrentContext,
    OCNCTransitionStyleOverCurrentContext
};

NS_ASSUME_NONNULL_BEGIN

@interface OCNCTransition : NSObject

@property (nonatomic, assign                  ) OCNCTransitionStyle      style;

@property (nonatomic, weak, readonly          ) ObjCNavigationController *navigationController;
@property (nonatomic, weak, readonly          ) UINavigationController   *viewController;
@property (nonatomic, weak, readonly, nullable) UINavigationController   *fromViewController;
@property (nonatomic, weak, readonly          ) UINavigationController   *toViewController;
@property (nonatomic, readonly                ) BOOL                     interactionCancelled;

- (void)complete:(BOOL)finished;

- (void)startTransition:(CFTimeInterval)duration;

#pragma mark
#pragma mark -- percent driven interaction
- (void)startInteraction;
- (void)updateInteraction:(CGFloat)progress;
- (void)cancelInteraction:(CGFloat)speed;
- (void)finishInteraction:(CGFloat)speed;

+ (instancetype)transitionWIthStyle:(OCNCTransitionStyle)style;

@end

NS_ASSUME_NONNULL_END
