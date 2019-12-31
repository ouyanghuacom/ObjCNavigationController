//
//  UINavigationController+OCNCPublic.h
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (OCNCPublic)

@property (nullable,nonatomic,copy)void(^ocnc_pop)(__kindof UINavigationController *navigationController);

//- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers NS_SWIFT_NAME(setViewController(_:));
//- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated NS_SWIFT_NAME(setViewControllers(_:animated:));
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(setViewControllers(_:animated:completion:));


- (void)pushViewController:(__kindof UIViewController *)viewController NS_SWIFT_NAME(pushViewController(_:));
//- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(pushViewController(_:animated:));
- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(pushViewController(_:animated:completion:));


- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers NS_SWIFT_NAME(pushViewControllers(_:));
- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated NS_SWIFT_NAME(pushViewControllers(_:animated:));
- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(pushViewControllers(_:animated:completion:));

- (nullable __kindof UIViewController *)popViewController NS_SWIFT_NAME(popViewController());
//- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated NS_SWIFT_NAME(popViewController(animated:));
- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popViewController(animated:completion:));

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController NS_SWIFT_NAME(popToRootViewController());
//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated NS_SWIFT_NAME(popToRootViewController(animated:));
- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popToRootViewController(animated:completion:));


- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController NS_SWIFT_NAME(popToViewController(_:));
//- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(popToViewController(_:animated:));
- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popToViewController(_:animated:completion:));

@end

NS_ASSUME_NONNULL_END
