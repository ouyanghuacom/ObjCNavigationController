//
//  OCNCDefaultTransition.h
//  ObjCNavigationController
//
//  Created by ouyanghuacom on 2019/12/31.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import "OCNCTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface OCNCDefaultTransition : OCNCTransition

@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

@property (nonatomic, assign) CATransform3D          (^initializeTransform)(OCNCDefaultTransition *transition);
@property (nonatomic, assign) CATransform3D          (^backgroundTransform)(OCNCDefaultTransition *transition);

@property (nonatomic, copy, nullable) void (^configureEffects) (OCNCDefaultTransition *transition, NSNumber * _Nullable percent);
@property (nonatomic, copy, nullable) BOOL (^handleGestureRecognizer) (UIGestureRecognizer * gestureRecognizer);

@end

@interface UIView (OCNCDefaultTransition)

@property (nonatomic, strong) NSNumber *ocnc_defaultTransitionBackgroundAlpha;

@end
NS_ASSUME_NONNULL_END
