//
//  ZXHActivityTitleView.h
//  MailTest
//
//  Created by 朱星海 on 14-5-23.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@class ZXHActivityTitleView;

@protocol ZXHActivityTitleViewDelegate <NSObject>

@optional
- (void)titleViewDidTouchDown:(ZXHActivityTitleView *)titleView;
- (void)titleViewDidTouchUpInside:(ZXHActivityTitleView *)titleView;
- (void)titleViewDidTouchUpOutside:(ZXHActivityTitleView *)titleView;

@end

@interface ZXHActivityTitleView : UIView
@property (nonatomic, assign) id<ZXHActivityTitleViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGSize imageViewSize;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)update;
@end
