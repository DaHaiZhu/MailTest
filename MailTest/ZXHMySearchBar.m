//
//  ZXHMySearchBar.m
//  MailTest
//
//  Created by 朱星海 on 14-6-10.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMySearchBar.h"

@implementation ZXHMySearchBar
@synthesize textField;
@synthesize button;

- (void)layoutSubviews
{
    self.autoresizesSubviews = YES;
    NSLog(@"sub:%@",self.subviews);
    //        NSArray *searchBarSubViews = [[self.subviews objectAtIndex:0] subviews];
    //        for (UIView *searchbuttons in searchBarSubViews)
    //        {
    //            if ([searchbuttons isKindOfClass:[UITextField class]])
    //            {
    //                textField = [self.subviews objectAtIndex:1];
    //                textField.delegate = self;
    //                [textField setFrame:CGRectMake(0,0,270,44)];
    //                textField.backgroundColor=[UIColor clearColor];
    //                break;
    //            }
    //        }
    for (UIView *subView in self.subviews){
        for (UIView *ndLeveSubView in subView.subviews){
            
            if ([ndLeveSubView isKindOfClass:[UITextField class]])
            {
                
                textField = (UITextField *)ndLeveSubView;
                textField.backgroundColor =[UIColor redColor];
                [textField setFrame:CGRectMake(0,0,270,44)];
            }
        }
    }
    
    button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(260, 0, 60, 44)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [self addSubview:button];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
