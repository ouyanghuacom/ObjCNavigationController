//
//  NSObject+OCNCPrivate.h
//  RANC
//
//  Created by retriable on 2019/4/19.
//  Copyright © 2019 retriable. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (OCNCPrivate)

+ (BOOL)ocnc_swizzleInstanceWithOrignalMethod:(SEL)orignalMethod alteredMethod:(SEL)altertedMethod;

@end

NS_ASSUME_NONNULL_END
