//
//  ZXHMailEditFolderViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-6-11.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMailEditFolderViewController.h"
#import "MailCoreManager.h"
#import "MBProgressHUD.h"

@interface ZXHMailEditFolderViewController ()<MailCoreManagerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate>
{
    MailCoreManager *mailmanager;
    MBProgressHUD *HUD;
}
@end

@implementation ZXHMailEditFolderViewController

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
                                                                action:@selector(changeNameToMailServer)];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(exitContoller)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.leftBarButtonItem = leftBtn;

    self.textfield.text = self.folderObj.zxh_mail_folder_showName;
    [self.textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textfield becomeFirstResponder];
    [self.deleteBtn setTitle:NSLocalizedString(@"删除文件夹", nil) forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.editFolderDelegate = self;
}

- (void)changeNameToMailServer
{
    NSString *folderName = [self.textfield.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.textfield.text isEqualToString:self.folderObj.zxh_mail_folder_showName] || [folderName isEqualToString:self.folderObj.zxh_mail_folder_showName]) {
        return;
    }
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
        [self.textfield resignFirstResponder];
        [mailmanager renameMailFolder:self.folderObj newName:folderName];
    }
}

- (void)exitContoller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MailCoreManager Delegate

- (void)callDeleteMailFolder:(NSError *)error
{
    if (!error)
    {
        //创建成功
        NSLog(@"success");
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.tag = 1;
        HUD.labelText = NSLocalizedString(@"删除成功", nil);
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark"]];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        
    }else
    {
        //创建失败
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"删除失败", nil);
        HUD.detailsLabelText = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cancel"]];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
    }
}

- (void)callRenameMailFolder:(NSError *)error
{
    if (!error)
    {
        //创建成功
        NSLog(@"success");
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.tag = 1;
        HUD.labelText = NSLocalizedString(@"修改成功", nil);
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkmark"]];
        [HUD show:YES];
        [HUD hide:YES afterDelay:2];
        
    }else
    {
        //创建失败
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"修改失败", nil);
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
    [self.textfield resignFirstResponder];
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

- (IBAction)deleteAction:(id)sender {
    
    [self.textfield resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"文件夹中的邮件会被同时删除。", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"删除", nil)
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //删除
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.delegate = self;
        [HUD show:YES];
        [mailmanager deleteMailFolder:self.folderObj.zxh_mail_folder_remoteid];
    }
}


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
