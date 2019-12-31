//
//  UIViewController+OCNCPublic.h
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

@import UIKit;

@class ObjCNavigationController;
@class OCNCTransition;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (OCNCPublic)

@property (readonly,  weak,   nullable) ObjCNavigationController *ocnc_navigationController;
@property (nonatomic, strong          ) OCNCTransition           *ocnc_transition;
@property (nonatomic, assign          ) BOOL                     ocnc_master;

@end

NS_ASSUME_NONNULL_END
