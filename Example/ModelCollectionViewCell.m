//
//  ModelCollectionViewCell.m
//  Example
//
//  Created by ouyanghuacom on 2019/12/30.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import "ModelCollectionViewCell.h"

@implementation Model : NSObject

@end


@implementation ModelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (!self) return nil;
    [self.contentView addSubview:self.label];
    self.contentView.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeWidth multiplier:1 constant:28],
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeHeight multiplier:1 constant:16],
    ]];
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGSize size = [self.label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-38, CGFLOAT_MAX)];
    CGRect frame = (CGRect){0};
    frame.size.width = size.width + 28;
    frame.size.height = size.height + 16;
    attributes.frame = frame;
    return attributes;
}

- (UILabel*)label{
    if (_label) return _label;
    _label=[[UILabel alloc]init];
    _label.numberOfLines = 2;
    return _label;
}

@end
