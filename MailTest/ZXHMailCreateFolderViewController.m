//
//  ZXHMailCreateFolderViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-6-11.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMailCreateFolderViewController.h"
#import "MailCoreManager.h"
#import "MBProgressHUD.h"

@interface ZXHMailCreateFolderViewController()<MailCoreManagerDelegate,MBProgressHUDDelegate>
{
    MailCoreManager *mailmanager;
    MBProgressHUD *HUD;
}
@end

@implementation ZXHMailCreateFolderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil)
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(saveFolderToMailServer)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(exitContoller)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.textField.placeholder = NSLocalizedString(@"文件夹名称", nil);
    [self.textField becomeFirstResponder];
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.createFolderDelegate = self;
}



- (void)exitContoller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveFolderToMailServer
{
    NSString *folderName = [self.textField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (folderName.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"名称不能为空", nil) delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    BOOL res = [self isRulesString:folderName];
    if (!res) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"名称中含有非法字符", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.delegate = self;
        [HUD show:YES];
        [self.textField resignFirstResponder];
        [mailmanager createNewMailFolder:folderName];
    }

}


#pragma mark - MailCoreManager Delegate

- (void)callCreateMailFolder:(NSError *)error
{
    if (!error)
    {
        //创建成功
        NSLog(@"success");
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.tag = 1;
        HUD.labelText = NSLocalizedString(@"创建成功", nil);
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark"]];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        
    }else
    {
        //创建失败
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"创建失败", nil);
        HUD.detailsLabelText = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cancel"]];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MBProgressHUD Delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (HUD.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [hud removeFromSuperview];
    hud = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//判断输入内容是否有非法字符
- (BOOL)isRulesString:(NSString *)string
{
    
    NSString* retString =string;
    for(int i=0;i<[retString length];i++)
    {
        unichar character = [retString characterAtIndex:i];
        //        if ((character <= '9'&& character >= '0')
        //            ||( character <= 'Z' && character >= 'A')
        //            ||( character <= 'z' && character >= 'a')
        //            ||(character >= 19968 &&character <= (19968+20902)))
        //        {
        //        }else
        //        {
        //            return NO;
        //        }
        if (character == '/' || character == ':' || character == '*' ||
            character == '?' || character == '\\' || character == '<' ||
            character == '>' || character == '|' )
        {
            return NO;
        }
    }
    return YES;
}
@end
