//
//  UIViewController+OCNCPrivate.m
//  OCNC
//
//  Created by ouyanghuacom on 2019/10/16.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+OCNCPrivate.h"
#import "OCNCPushTransition.h"
#import "UIViewController+OCNCPrivate.h"

@implementation UIViewController (OCNCPublic)

- (ObjCNavigationController *)ocnc_navigationController {
    if ([self isKindOfClass:UINavigationController.class]) {
        return [objc_getAssociatedObject(self, @selector(ocnc_navigationController)) anyObject];
    }
    return [self.navigationController ocnc_navigationController];
}

- (void)setOcnc_navigationController:(ObjCNavigationController * _Nullable)ocnc_navigationController{
    objc_setAssociatedObject(self, @selector(ocnc_navigationController), ocnc_navigationController ? ({
        NSHashTable *v = [NSHashTable weakObjectsHashTable];
        [v addObject:ocnc_navigationController];
        v;
    }): nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setOcnc_master:(BOOL)ocnc_master{
    objc_setAssociatedObject(self, @selector(ocnc_master), @(ocnc_master), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ocnc_master{
    return [objc_getAssociatedObject(self, @selector(ocnc_master)) boolValue];
}

- (void)setOcnc_transition:(OCNCTransition*)ocnc_transition{
    objc_setAssociatedObject(self, @selector(ocnc_transition), ocnc_transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (OCNCTransition*)ocnc_transition{
    OCNCTransition *transition = objc_getAssociatedObject(self, @selector(ocnc_transition));
    if (transition) return transition;
    if ([self isKindOfClass:UINavigationController.class]){
        transition=[(UINavigationController*)self topViewController].ocnc_transition;
        if (transition) return transition;
    }
    transition=[[OCNCPushTransition alloc]init];
    self.ocnc_transition=transition;
    return transition;
}

@end
