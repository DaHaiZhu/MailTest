//
//  ZXHMailEditFolderViewController.h
//  MailTest
//
//  Created by 朱星海 on 14-6-11.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHMail_ContainObjectContoller.h"

@interface ZXHMailEditFolderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic)ZXHMail_FolderObject *folderObj;

- (IBAction)deleteAction:(id)sender;

@end
