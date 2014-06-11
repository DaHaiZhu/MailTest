//
//  ZXHMail_BodyTableViewController.h
//  MailTest
//
//  Created by 朱星海 on 14-5-30.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHMail_ContainObjectContoller.h"
#import <MailCore/MailCore.h>

@interface ZXHMail_BodyTableViewController : UITableViewController<UIWebViewDelegate>


@property(nonatomic,strong)ZXHMail_MailInfoObject *mailInfo;
@property (nonatomic, strong) MCOAbstractMessage * message;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableString *htmlString;
@property (nonatomic, strong) NSMutableArray *attachArray;
@end
