//
//  NSObject+StackerPrivate.m
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+OCNCPrivate.h"

@implementation NSObject (OCNCPrivate)

+ (BOOL)ocnc_swizzleInstanceWithOrignalMethod:(SEL)orignalMethod alteredMethod:(SEL)altertedMethod{
    Method origMethod = class_getInstanceMethod(self, orignalMethod);
    Method altMethod  = class_getInstanceMethod(self, altertedMethod);
    if (!orignalMethod) return NO;
    if (!altertedMethod) return NO;
    class_addMethod(self, orignalMethod, class_getMethodImplementation(self, orignalMethod), method_getTypeEncoding(origMethod));
    class_addMethod(self, altertedMethod, class_getMethodImplementation(self, altertedMethod), method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, orignalMethod), class_getInstanceMethod(self, altertedMethod));
    return YES;
}

@end
