//
//  OCNCPresentTransition.m
//  ObjCNavigationController
//
//  Created by ouyanghuacom on 2019/12/31.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import "OCNCPresentTransition.h"
#import "ObjCNavigationController.h"

@interface OCNCPresentTransition()

//@property (nonatomic,assign) CGPoint startPoint;

@end

@implementation OCNCPresentTransition

- (instancetype)init{
    self = [super init];
    if (!self) return nil;
    self.animationOptions = UIViewAnimationOptionCurveLinear;
    __weak typeof(self) weakSelf = self;
    self.initializeTransform = ^CATransform3D(OCNCDefaultTransition * _Nonnull transition) {
        return CATransform3DTranslate(CATransform3DIdentity, 0, CGRectGetHeight(transition.toViewController.view.bounds), 0);
    };
    self.backgroundTransform = ^CATransform3D(OCNCDefaultTransition * _Nonnull transition) {
        return CATransform3DScale(CATransform3DIdentity, 0.985, 0.985, 0.985);
    };
    self.configureEffects = ^(OCNCDefaultTransition *transition, NSNumber *percent) {
        __strong typeof(weakSelf) self=weakSelf;
        BOOL (^opaque)(UIView *) = ^ BOOL (UIView *view){
            return view.alpha == 1 && ({
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
        view.layer.shadowOffset = CGSizeMake(0, -8);
        view.layer.shadowRadius=8;
        view.layer.shadowOpacity=0.5;
        self.viewController.view.ocnc_defaultTransitionBackgroundAlpha = percent;
    };
    self.handleGestureRecognizer = nil;
    //    self.handleGestureRecognizer = ^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer) {
    //        __strong typeof(weakSelf) self=weakSelf;
    //        UIView *view = gestureRecognizer.view;
    //        UIView *superview=view.superview;
    //        CGPoint point=[gestureRecognizer locationInView:superview];
    //        switch (gestureRecognizer.state) {
    //            case UIGestureRecognizerStateBegan:
    //                self.startPoint=point;
    //                [self.navigationController popViewController];
    //                [self startInteraction];
    //                break;
    //            case UIGestureRecognizerStateChanged:
    //                [self updateInteraction:(point.y-self.startPoint.y)/CGRectGetHeight(view.bounds)];
    //                break;
    //            case UIGestureRecognizerStateEnded:
    //            case UIGestureRecognizerStateCancelled:{
    //                CGPoint velocity=[(UIPanGestureRecognizer*)gestureRecognizer velocityInView:superview];
    //                if (velocity.y>1000){
    //                    [self finishInteraction:velocity.y/CGRectGetHeight(view.bounds)/3.0];
    //                }else if (point.y-self.startPoint.y>CGRectGetHeight(view.bounds)/5.0){
    //                    [self finishInteraction:0.75];
    //                } else [self cancelInteraction:0.25];
    //            }break;
    //            default:
    //                if (point.y>self.viewController.view.frame.origin.y+self.viewController.view.frame.size.width/2.0){
    //                    return NO;
    //                }
    //                return YES;
    //        }
    //        return YES;
    //    };
    return self;
}

@end
