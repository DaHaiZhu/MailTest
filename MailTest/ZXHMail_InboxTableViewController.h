//
//  ZXHMail_InboxTableViewController.h
//  MailTest
//
//  Created by 朱星海 on 14-5-15.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHMail_ContainObjectContoller.h"

@interface ZXHMail_InboxTableViewController : UITableViewController
@property (nonatomic, strong) ZXHMail_FolderObject *folderObj;
@property (nonatomic, strong) ZXHMail_ContainObjectContoller *accountObj;
@end
