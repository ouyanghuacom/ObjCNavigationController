//
//  OCNCTransition+OCNCPrivate.h
//  ObjCNavigationController
//
//  Created by ouyanghuacom on 2019/12/27.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import "OCNCTransition.h"

@class ObjCNavigationController;

NS_ASSUME_NONNULL_BEGIN

@interface OCNCTransition (OCNCPrivate)

@property (nonatomic,weak          ) ObjCNavigationController          *navigationController;
@property (nonatomic, weak         ) UINavigationController *viewController;
@property (nonatomic, weak,nullable) UINavigationController *fromViewController;
@property (nonatomic, weak         ) UINavigationController *toViewController;

@property (nonatomic,copy, nullable) void(^completeBlock)(BOOL finished);
@property (nonatomic,copy, nullable) BOOL(^interactionCancelledBlock)(void);
@property (nonatomic,copy, nullable) void(^startInteractionBlock)(void);
@property (nonatomic,copy, nullable) void(^updateInteractionBlock)(CGFloat progress);
@property (nonatomic,copy, nullable) void(^cancelInteractionBlock)(CGFloat speed);
@property (nonatomic,copy, nullable) void(^finishInteractionBlock)(CGFloat speed);


@end

NS_ASSUME_NONNULL_END
