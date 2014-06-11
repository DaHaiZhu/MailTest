//
//  ZXHActivityTitleView.m
//  MailTest
//
//  Created by 朱星海 on 14-5-23.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHActivityTitleView.h"

@interface ZXHActivityTitleView()

- (void)touchedDown:(id)sender;
- (void)touchedUpInside:(id)sender;
- (void)touchedUpOutside:(id)sender;

@end

@implementation ZXHActivityTitleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        self.margin = 6;
        self.imageViewSize = CGSizeMake(20, 20);
        
        UIButton *baseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        baseButton.frame = self.bounds;
        
        [baseButton addTarget:self action:@selector(touchedDown:) forControlEvents:UIControlEventTouchDown];
        [baseButton addTarget:self action:@selector(touchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [baseButton addTarget:self action:@selector(touchedUpOutside:) forControlEvents:UIControlEventTouchUpOutside];

        [self addSubview:baseButton];
      
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [baseButton addSubview:activity];

        self.activityIndicator = activity;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [baseButton addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [self update];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self update];
}

- (NSString *)title
{
    return self.titleLabel.text;
}



#pragma mark -

- (void)update
{
    CGFloat margin = self.margin;
    CGSize imageViewSize = self.titleLabel.text ? self.imageViewSize : CGSizeZero;
    CGSize actualTitleSize;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
     if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
     {
        actualTitleSize = [self.title sizeWithFont:[UIFont boldSystemFontOfSize:17] forWidth:self.bounds.size.width lineBreakMode:NSLineBreakByTruncatingTail];
     }else
     {
         NSDictionary *attributes = @{NSFontAttributeName:
                                          [UIFont boldSystemFontOfSize:17]};
         actualTitleSize  = [self.title boundingRectWithSize:CGSizeMake(self.bounds.size.width,self.bounds.size.height)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:attributes context:nil].size;
     }
#pragma clang diagnostic pop
    
    CGRect titleLabelFrame;
    CGRect aInicatorFrame;
    
    if((self.bounds.size.width - actualTitleSize.width) / 2 < (imageViewSize.width + margin)) {
        titleLabelFrame = CGRectMake(imageViewSize.width + margin, 0, MIN(self.bounds.size.width - imageViewSize.width, actualTitleSize.width), self.bounds.size.height);
        aInicatorFrame = CGRectMake(0, (self.bounds.size.height - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
    } else {
        titleLabelFrame = CGRectMake((self.bounds.size.width - actualTitleSize.width) / 2, 0, actualTitleSize.width, self.bounds.size.height);
        aInicatorFrame = CGRectMake(titleLabelFrame.origin.x - (imageViewSize.width + margin), (self.bounds.size.height - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
    }
    
    self.titleLabel.frame = titleLabelFrame;
    self.activityIndicator.frame = aInicatorFrame;
}

- (void)touchedDown:(id)sender
{
    if([self.delegate respondsToSelector:@selector(titleViewDidTouchDown:)]) {
        [self.delegate titleViewDidTouchDown:self];
    }
}

- (void)touchedUpInside:(id)sender
{

    if([self.delegate respondsToSelector:@selector(titleViewDidTouchUpInside:)]) {
        [self.delegate titleViewDidTouchUpInside:self];
    }
}

- (void)touchedUpOutside:(id)sender
{

    if([self.delegate respondsToSelector:@selector(titleViewDidTouchUpOutside:)]) {
        [self.delegate titleViewDidTouchUpOutside:self];
    }
}
@end
