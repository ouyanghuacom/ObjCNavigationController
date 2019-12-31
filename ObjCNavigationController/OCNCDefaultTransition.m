//
//  OCNCDefaultTransition.m
//  ObjCNavigationController
//
//  Created by ouyanghuacom on 2019/12/31.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+OCNCPrivate.h"
#import "ObjCNavigationController.h"
#import "OCNCDefaultTransition.h"
#import "OCNCTransition+OCNCPrivate.h"

@interface OCNCDefaultTransition () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *interactivePopGestureRecognizer;
@property (nonatomic,assign) CGPoint                startPoint;
@property (nonatomic,assign) CATransform3D          fromTransform;
@property (nonatomic,assign) CATransform3D          toTransform;

@end

@implementation OCNCDefaultTransition

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    self.animationOptions = UIViewAnimationOptionCurveLinear;
    __weak typeof(self) weakSelf = self;
    self.initializeTransform = ^CATransform3D(OCNCDefaultTransition * _Nonnull transition) {
        return CATransform3DTranslate(CATransform3DIdentity, CGRectGetWidth(transition.toViewController.view.bounds), 0, 0);
    };
    self.backgroundTransform = ^CATransform3D(OCNCDefaultTransition * _Nonnull transition) {
        return CATransform3DScale(CATransform3DIdentity, 0.985, 0.985, 0.985);
    };
    self.configureEffects = ^(OCNCDefaultTransition *transition, NSNumber *percent) {
        __strong typeof(weakSelf) self=weakSelf;
        BOOL (^opaque)(UIView *) = ^ BOOL (UIView *view){
            return view.alpha == 1 || ({
                CGFloat alpha;
                [view.backgroundColor getRed:nil green:nil blue:nil alpha:&alpha];
                alpha == 1;
            });
        };
        __block UIView *view =  self.viewController.view;
        if (!opaque(view) && !opaque(self.viewController.topViewController.view)){
            [self.viewController.topViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.alpha == 1){
                    view = obj;
                    *stop = YES;
                }
            }];
        }
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.layer.shadowColor=[UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(-8, 0);
        view.layer.shadowRadius=8;
        view.layer.shadowOpacity=0.5;
        self.viewController.view.ocnc_defaultTransitionBackgroundAlpha = percent;
    };
    self.handleGestureRecognizer = ^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer) {
        __strong typeof(weakSelf) self=weakSelf;
        UIView *view = gestureRecognizer.view;
        UIView *superview=view.superview;
        CGPoint point=[gestureRecognizer locationInView:superview];
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                self.startPoint=point;
                [self.navigationController popViewController];
                [self startInteraction];
                break;
            case UIGestureRecognizerStateChanged:
                [self updateInteraction:(point.x-self.startPoint.x)/CGRectGetWidth(view.bounds)];
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                CGPoint velocity=[(UIPanGestureRecognizer*)gestureRecognizer velocityInView:superview];
                if (velocity.x>1000){
                    [self finishInteraction:velocity.x/CGRectGetWidth(view.bounds)/3.0];
                }else if (point.x-self.startPoint.x>CGRectGetWidth(view.bounds)/5.0){
                    [self finishInteraction:0.75];
                } else [self cancelInteraction:0.25];
            }break;
            default:
                if (point.x>self.viewController.view.frame.origin.x+self.viewController.view.frame.size.width/2.0){
                    return NO;
                }
                return YES;
        }
        return YES;
    };
    return self;
}

- (void)startTransition:(CFTimeInterval)duration{
    BOOL push = self.viewController==self.toViewController;
    UIView *fromView=self.fromViewController.view;
    UIView *toView=self.toViewController.view;
    if (push){
        [self.toViewController interactivePopGestureRecognizer].enabled=NO;
        if (self.handleGestureRecognizer&&toView!=self.interactivePopGestureRecognizer.view){
            [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.interactivePopGestureRecognizer];
            [toView addGestureRecognizer:self.interactivePopGestureRecognizer];
        }
        self.fromTransform = fromView.layer.transform;
        self.toTransform = self.initializeTransform(self);
        toView.layer.transform = self.toTransform;
        if (self.configureEffects) self.configureEffects(self, @(0));
        [UIView animateWithDuration:duration delay:0 options:self.animationOptions animations:^{
            toView.layer.transform = CATransform3DIdentity;
            fromView.layer.transform = self.backgroundTransform(self);
            if (self.configureEffects) self.configureEffects(self, @(1/3.0));
        } completion:^(BOOL finished) {
            finished = !self.interactionCancelled &&finished;
            if (!finished){
                if (self.configureEffects) self.configureEffects(self, nil);
            }
            [self complete:finished];
        }];
    }else{
        self.fromTransform = fromView.layer.transform;
        self.toTransform = toView.layer.transform;
        //fix navigation bar position
        [self.toViewController setNavigationBarHidden:!self.toViewController.navigationBarHidden animated:NO];
        [self.toViewController setNavigationBarHidden:!self.toViewController.navigationBarHidden animated:NO];
        self.configureEffects(self, @(1/3.0));
        [UIView animateWithDuration:duration delay:0 options:self.animationOptions animations:^{
            fromView.layer.transform = self.initializeTransform(self);
            toView.layer.transform = CATransform3DIdentity;
            if (self.configureEffects) self.configureEffects(self, @(0));
        } completion:^(BOOL finished) {
            finished = !self.interactionCancelled &&finished;
            if (!finished){
                if (self.configureEffects) self.configureEffects(self, @(1/3.0));
            }else{
                if (self.configureEffects) self.configureEffects(self, nil);
            }
            [self complete:finished];
        }];
    }
}

- (void)complete:(BOOL)finished{
    [super complete:finished];
    if (!finished){
        self.fromViewController.view.layer.transform = self.fromTransform;
        self.toViewController.view.layer.transform   = self.toTransform;
    }
}

- (void)panAction:(UIPanGestureRecognizer*)gestureRecognizer{
    if (self.handleGestureRecognizer) self.handleGestureRecognizer(gestureRecognizer);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.handleGestureRecognizer) return self.handleGestureRecognizer(gestureRecognizer);
    return NO;
}

- (UIPanGestureRecognizer*)interactivePopGestureRecognizer{
    if (_interactivePopGestureRecognizer) return _interactivePopGestureRecognizer;
    _interactivePopGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    _interactivePopGestureRecognizer.delegate = self;
    return _interactivePopGestureRecognizer;
}

@end

static const void *OCNCDefaultTransitionBackgroundViewKey = &OCNCDefaultTransitionBackgroundViewKey;

@implementation UIView (OCNCDefaultTransition)

- (NSNumber *)ocnc_defaultTransitionBackgroundAlpha{
    return objc_getAssociatedObject(self, @selector(ocnc_defaultTransitionBackgroundAlpha));
}

- (void)setOcnc_defaultTransitionBackgroundAlpha:(NSNumber *)ocnc_defaultTransitionBackgroundAlpha{
    objc_setAssociatedObject(self, @selector(ocnc_defaultTransitionBackgroundAlpha), ocnc_defaultTransitionBackgroundAlpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self ocnc_defaultTransitionSetNeedsDisplay];
}

- (void)ocnc_defaultTransitionRemoveFromSuperview{
    [self ocnc_defaultTransitionRemoveFromSuperview];
    [self ocnc_defaultTransitionSetNeedsDisplay];
}

- (void)ocnc_defaultTransitionDidMoveToSuperview{
    [self ocnc_defaultTransitionDidMoveToSuperview];
    [self ocnc_defaultTransitionSetNeedsDisplay];
}

- (void)ocnc_defaultTransitionSetNeedsDisplay{
    NSNumber * alpha = self.ocnc_defaultTransitionBackgroundAlpha;
    UIView *superview = self.superview;
    UIView *view = objc_getAssociatedObject(self, OCNCDefaultTransitionBackgroundViewKey);
    if (!self.superview || !alpha){
        [view removeFromSuperview];
        return;
    }
    if (!view){
        view = ({
            UIView *v = [[UIView alloc]init];
            v.backgroundColor = [UIColor blackColor];
            v.alpha = 0;
            v;
        });
        objc_setAssociatedObject(self, OCNCDefaultTransitionBackgroundViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if ([superview.subviews indexOfObject:view]+1 != [superview.subviews indexOfObject:self]){
        [view removeFromSuperview];
        [superview insertSubview:view belowSubview:self];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [superview addConstraints:@[
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeHeight multiplier:1 constant:0],
        ]];
    }
    view.alpha = alpha.doubleValue;
}

+ (void)load{
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(removeFromSuperview) alteredMethod:@selector(ocnc_defaultTransitionRemoveFromSuperview)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(didMoveToSuperview) alteredMethod:@selector(ocnc_defaultTransitionDidMoveToSuperview)];
}

@end
