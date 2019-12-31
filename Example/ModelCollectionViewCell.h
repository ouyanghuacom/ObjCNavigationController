//
//  ModelCollectionViewCell.h
//  Example
//
//  Created by ouyanghuacom on 2019/12/30.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)void(^block)(void);

@end

@interface ModelCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *label;

@end

NS_ASSUME_NONNULL_END
