//
//  UINavigationController+OCNCPrivate.h
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

@import UIKit;

#import "UINavigationController+OCNCPublic.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (OCNCPrivate)

- (void)ocnc_original_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
