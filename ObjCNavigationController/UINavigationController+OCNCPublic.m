//
//  UINavigationController+OCNCPublic.m
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+OCNCPrivate.h"
#import "ObjCNavigationController.h"
#import "UINavigationController+OCNCPublic.h"
#import "UIViewController+OCNCPrivate.h"

@implementation UINavigationController (OCNCPublic)

- (void)setOcnc_pop:(void (^)(__kindof UINavigationController *))ocnc_pop{
    objc_setAssociatedObject(self, @selector(ocnc_pop), ocnc_pop, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(__kindof UINavigationController *))ocnc_pop{
    return objc_getAssociatedObject(self, @selector(ocnc_pop));
}

- (BOOL)ocnc_original_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    if (self.ocnc_pop){
        self.ocnc_pop(self);
        return NO;
    }
    if (self.ocnc_navigationController){
        [self.ocnc_navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return [self ocnc_original_navigationBar:navigationBar shouldPopItem:item];
}

- (void)ocnc_original_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}

- (void)ocnc_original_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self setViewControllers:viewControllers animated:animated completion:nil];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.ocnc_navigationController){
        [self.ocnc_navigationController setViewControllers:viewControllers animated:animated completion:completion];
        return;
    }
    [self ocnc_original_setViewControllers:viewControllers animated:animated];
     if (completion) completion(YES);
}

- (void)pushViewController:(__kindof UIViewController *)viewController{
    [self pushViewController:viewController animated:YES];
}

- (void)ocnc_original_pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.ocnc_navigationController){
        [self.ocnc_navigationController pushViewController:viewController animated:animated completion:completion];
        return;
    }
    [self ocnc_original_pushViewController:viewController animated:animated];
    if (completion) completion(YES);
}

- (NSArray*)ocnc_original_viewControllers{
    if (self.ocnc_navigationController){
        return [self.ocnc_navigationController viewControllers];
    }
    return [self ocnc_original_viewControllers];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self pushViewControllers:viewControllers animated:YES];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    [self pushViewControllers:viewControllers animated:animated completion:nil];
}

- (void)pushViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion{
    if (self.ocnc_navigationController){
        [self.ocnc_navigationController pushViewControllers:viewControllers animated:animated completion:completion];
        return;
    }
    if (viewControllers.count==0){
        if (completion) completion(YES);
        return;
    }
    for (NSInteger i=0;i<viewControllers.count-1;i++){
        [self ocnc_original_pushViewController:viewControllers[i] animated:animated];
    }
    [self ocnc_original_pushViewController:viewControllers.lastObject animated:animated];
    if (completion) completion(YES);
}

- (nullable __kindof UIViewController *)popViewController{
    return [self popViewControllerAnimated:YES];
}

- (nullable __kindof UIViewController *)ocnc_original_popViewControllerAnimated:(BOOL)animated{
    return [self popViewControllerAnimated:animated completion:nil];
}

- (nullable __kindof UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.ocnc_navigationController){
        return [self.ocnc_navigationController popViewControllerAnimated:animated completion:completion];
    }
    UIViewController *v = [self ocnc_original_popViewControllerAnimated:animated];
    if (completion) completion(YES);
    return v;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewController{
    return [self popToRootViewControllerAnimated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)ocnc_original_popToRootViewControllerAnimated:(BOOL)animated{
    return [self popToRootViewControllerAnimated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void(^_Nullable)(BOOL finished))completion{
    if (self.ocnc_navigationController){
        return [self.ocnc_navigationController popToRootViewControllerAnimated:animated completion:completion];
    }
    NSArray * v= [self ocnc_original_popToRootViewControllerAnimated:animated];
    if (completion) completion(YES);
    return v;
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController{
    return [self popToViewController:viewController animated:YES];
}

- (nullable NSArray<__kindof UIViewController *> *)ocnc_original_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    return [self popToViewController:viewController animated:animated completion:nil];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL finished))completion{
    if (self.ocnc_navigationController){
        return [self.ocnc_navigationController popToViewController:viewController animated:animated completion:completion];
    }
    NSArray *v = [self ocnc_original_popToViewController:viewController animated:animated];
    if (completion) completion(YES);
    return v;
}

- (BOOL)ocnc_original_prefersStatusBarHidden{
    if (!self.ocnc_navigationController){
        return [self ocnc_original_prefersStatusBarHidden];
    }
    if (!self.topViewController){
        return [self ocnc_original_prefersStatusBarHidden];
    }
    return [self.topViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)ocnc_original_preferredStatusBarStyle{
    if (!self.ocnc_navigationController){
        return [self ocnc_original_preferredStatusBarStyle];
    }
    if (!self.topViewController){
        return [self ocnc_original_preferredStatusBarStyle];
    }
    return [self.topViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)ocnc_original_preferredStatusBarUpdateAnimation{
    if (!self.ocnc_navigationController){
        return [self ocnc_original_preferredStatusBarUpdateAnimation];
    }
    if (!self.topViewController){
        return [self ocnc_original_preferredStatusBarUpdateAnimation];
    }
    return [self.topViewController preferredStatusBarUpdateAnimation];
}

- (BOOL)ocnc_original_shouldAutorotate{
    if (!self.ocnc_navigationController){
        return [self ocnc_original_shouldAutorotate];
    }
    if (!self.topViewController){
        return [self ocnc_original_shouldAutorotate];
    }
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)ocnc_original_supportedInterfaceOrientations{
    if (!self.ocnc_navigationController){
        return [self ocnc_original_supportedInterfaceOrientations];
    }
    if (!self.topViewController){
        return [self ocnc_original_supportedInterfaceOrientations];
    }
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)ocnc_original_preferredInterfaceOrientationForPresentation{
    if (!self.ocnc_navigationController){
        return [self ocnc_original_preferredInterfaceOrientationForPresentation];
    }
    if (!self.topViewController){
        return [self ocnc_original_preferredInterfaceOrientationForPresentation];
    }
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

+ (void)load{
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(viewControllers) alteredMethod:@selector(ocnc_original_viewControllers)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(navigationBar:shouldPopItem:) alteredMethod:@selector(ocnc_original_navigationBar:shouldPopItem:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(setViewControllers:) alteredMethod:@selector(ocnc_original_setViewControllers:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(setViewControllers:animated:) alteredMethod:@selector(ocnc_original_setViewControllers:animated:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(pushViewController:animated:) alteredMethod:@selector(ocnc_original_pushViewController:animated:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(popViewControllerAnimated:) alteredMethod:@selector(ocnc_original_popViewControllerAnimated:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(popToRootViewControllerAnimated:) alteredMethod:@selector(ocnc_original_popToRootViewControllerAnimated:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(popToViewController:animated:) alteredMethod:@selector(ocnc_original_popToViewController:animated:)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(prefersStatusBarHidden) alteredMethod:@selector(ocnc_original_prefersStatusBarHidden)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(preferredStatusBarStyle) alteredMethod:@selector(ocnc_original_preferredStatusBarStyle)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(preferredStatusBarUpdateAnimation) alteredMethod:@selector(ocnc_original_preferredStatusBarUpdateAnimation)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(shouldAutorotate) alteredMethod:@selector(ocnc_original_shouldAutorotate)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(supportedInterfaceOrientations) alteredMethod:@selector(ocnc_original_supportedInterfaceOrientations)];
    [self ocnc_swizzleInstanceWithOrignalMethod:@selector(preferredInterfaceOrientationForPresentation) alteredMethod:@selector(ocnc_original_preferredInterfaceOrientationForPresentation)];
}

@end
