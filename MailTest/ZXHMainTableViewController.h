//
//  ZXHMainTableViewController.h
//  MailTest
//
//  Created by 朱星海 on 14-5-15.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHLoginSetViewController.h"
@interface ZXHMainTableViewController : UITableViewController<ZXHLoginSetViewControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
- (IBAction)showSettingsViewController:(id)sender;
@end
