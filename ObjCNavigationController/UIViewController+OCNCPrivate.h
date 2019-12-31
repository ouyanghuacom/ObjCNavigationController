//
//  UIViewController+OCNCPrivate.h
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

@import UIKit;

@class ObjCNavigationController;

#import "UIViewController+OCNCPublic.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (OCNCPrivate)

@property (nonatomic,  weak) ObjCNavigationController *ocnc_navigationController;

@end

NS_ASSUME_NONNULL_END
