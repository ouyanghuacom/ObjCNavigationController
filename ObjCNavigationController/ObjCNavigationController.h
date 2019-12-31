//
//  ObjCNavigationController.h
//  ObjCNavigationController
//
//  Created by ouyanghuacom on 2019/12/27.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjCNavigationController/OCNCTransition.h>
#import <ObjCNavigationController/OCNCDefaultTransition.h>
#import <ObjCNavigationController/OCNCPushTransition.h>
#import <ObjCNavigationController/OCNCPresentTransition.h>
#import <ObjCNavigationController/UIViewController+OCNCPublic.h>
#import <ObjCNavigationController/UINavigationController+OCNCPublic.h>

//! Project version number for ObjCNavigationController.
FOUNDATION_EXPORT double ObjCNavigationControllerVersionNumber;

//! Project version string for ObjCNavigationController.
FOUNDATION_EXPORT const unsigned char ObjCNavigationControllerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ObjCNavigationController/PublicHeader.h>



NS_ASSUME_NONNULL_BEGIN

@interface ObjCNavigationController : UIViewController

@property(nullable, nonatomic, readonly) UIViewController *topViewController;

@property(nullable, nonatomic, readonly ) NSArray<UIViewController *> *viewControllers;

- (instancetype)initWithNavigationControllerClass:(nullable Class)navigationControllerClass NS_SWIFT_NAME(init(navigationControllerClass:));

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_SWIFT_NAME(init(rootViewController:));
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers NS_SWIFT_NAME(init(viewControllers:));

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers NS_SWIFT_NAME(setViewController(_:));
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated NS_SWIFT_NAME(setViewControllers(_:animated:));
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(setViewControllers(_:animated:completion:));
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(setViewControllers(_:duration:completion:));


- (void)pushViewController:(UIViewController *)viewController NS_SWIFT_NAME(pushViewController(_:));
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(pushViewController(_:animated:));
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(pushViewController(_:animated:completion:));
- (void)pushViewController:(UIViewController *)viewController duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(pushViewController(_:duration:completion:));


- (void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers NS_SWIFT_NAME(pushViewControllers(_:));
- (void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated NS_SWIFT_NAME(pushViewControllers(_:animated:));
- (void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(pushViewControllers(_:animated:completion:));
- (void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(pushViewControllers(_:duration:completion:));

- (nullable UIViewController *)popViewController NS_SWIFT_NAME(popViewController());
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated NS_SWIFT_NAME(popViewController(animated:));
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popViewController(animated:completion:));
- (nullable UIViewController *)popViewControllerWithDuration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popViewController(duration:completion:));

- (nullable NSArray<UIViewController *> *)popToRootViewController NS_SWIFT_NAME(popToRootViewController());
- (nullable NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated NS_SWIFT_NAME(popToRootViewController(animated:));
- (nullable NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popToRootViewController(animated:completion:));
- (nullable NSArray<UIViewController *> *)popToRootViewControllerWithDuration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popToRootViewController(duration:completion:));


- (nullable NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController NS_SWIFT_NAME(popToViewController(_:));
- (nullable NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated NS_SWIFT_NAME(popToViewController(_:animated:));
- (nullable NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popToViewController(_:animated:completion:));
- (nullable NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController duration:(CFTimeInterval)duration completion:(void(^_Nullable)(BOOL finished))completion NS_SWIFT_NAME(popToViewController(_:duration:completion:));

@end

NS_ASSUME_NONNULL_END
