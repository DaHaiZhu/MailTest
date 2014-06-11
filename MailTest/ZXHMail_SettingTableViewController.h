//
//  ZXHMail_SettingTableViewController.h
//  MailTest
//
//  Created by 朱星海 on 14-5-16.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHMail_SettingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *mail_delete_accout_btn;
- (IBAction)deleteCurrentAccountAction:(id)sender;

@end
