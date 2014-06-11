//
//  ZXHLoginSetViewController.h
//  MailTest
//
//  Created by 朱星海 on 14-5-15.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>

//extern NSString * const UsernameKey;
//extern NSString * const PasswordKey;
extern NSString * const Hostname;
NSUInteger const Hostport;
extern NSString * const FetchFullMessageKey;

@protocol ZXHLoginSetViewControllerDelegate;
@interface ZXHLoginSetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *emailAddress_lb;
@property (weak, nonatomic) IBOutlet UILabel *password_lb;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress_td;
@property (weak, nonatomic) IBOutlet UITextField *password_td;
@property (nonatomic, weak) id<ZXHLoginSetViewControllerDelegate>delegate;

@end
@protocol ZXHLoginSetViewControllerDelegate <NSObject>
- (void)zxhLoginViewControllerFinished:(ZXHLoginSetViewController *)viewController;
@end

