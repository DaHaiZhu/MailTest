//
//  ZXHLoginSetViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-5-15.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHLoginSetViewController.h"
#import "FXKeychain.h"
#import "UITextField+Shake.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h> 
#import "ZXHMail_ContainObjectContoller.h"
#import "MailCoreManager.h"


//NSString * const UsernameKey = @"mailusername";
//NSString * const PasswordKey = @"mailpassword";
NSString * const HostnameKey = @"hostname";
NSString * const Hostname    = @"imap.gmail.com";
NSUInteger const Hostport    = 993;
NSString * const FetchFullMessageKey = @"FetchFullMessageEnabled";

@interface ZXHLoginSetViewController ()<MailCoreManagerDelegate>
{
    AVAudioPlayer *player;
    MailCoreManager *mailmanager;
}

@end

@implementation ZXHLoginSetViewController

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
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"登录", nil)
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(loginToMailServer)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.title = NSLocalizedString(@"邮箱", nil);
    self.emailAddress_lb.text = NSLocalizedString(@"邮箱地址", nil);
    self.password_lb.text     = NSLocalizedString(@"密码", nil);
    self.emailAddress_td.placeholder = NSLocalizedString(@"email@company.com", nil);
    self.password_td.placeholder = NSLocalizedString(@"必填", nil);
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.delegate = self;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_NUMBERTOLOAD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_CONTENT_ROW];
    [[FXKeychain defaultKeychain] removeObjectForKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [mailmanager cancelFetchOperation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //初始化mail变量
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.delegate = self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UITextField class]]) {
			[obj resignFirstResponder];
		}
	}];
}
- (void)shake:(UITextField *)textField
{
    [self playWarningSound];
    [textField shake:15
                withDelta:5
                 andSpeed:0.08
      shakeDirection:ShakeDirectionHorizontal];
}

- (void)playWarningSound
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgwarning" ofType:@"wav"];
    if (path) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        [player prepareToPlay];
        player.numberOfLoops = 3;
        player.volume = 0.5f;
        if (!player.isPlaying)
        {
            [player play];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //震动
    }
}

- (void)loginToMailServer
{

    NSString *username = [self.emailAddress_td.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *password = [self.password_td.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (username.length == 0 && password.length == 0)
    {
        [self shake:self.emailAddress_td];
        [self shake:self.password_td];
        return;
    }else if (username.length == 0 )
    {
        [self shake:self.emailAddress_td];
        return;
    }else if (password.length == 0 )
    {
        [self shake:self.password_td];
        return;
    }
    [self.emailAddress_td setEnabled:NO];
    [self.password_td setEnabled:NO];
    
    [[NSUserDefaults standardUserDefaults] setObject:username ?: @"" forKey:UsernameKey];
    [[FXKeychain defaultKeychain] setObject:password ?: @"" forKey:PasswordKey];
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    self.title = NSLocalizedString(@"正在验证...", nil);
    
    [mailmanager loginToDomainWithTLS:Hostname hostPort:Hostport username:username password:password];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MailCoreManagerDelegate
- (void)callLoginFinishedFailOnLoginController:(NSError *)error
{
    [self.emailAddress_td setEnabled:YES];
    [self.password_td setEnabled:YES];
    [self.emailAddress_td becomeFirstResponder];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    self.title = NSLocalizedString(@"Outlook", nil);
    
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                         message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [alertView show];
}

- (void)callLoginFinishedSuccessOnLoginController
{
    [self.emailAddress_td setEnabled:YES];
    [self.password_td setEnabled:YES];
    [self.emailAddress_td becomeFirstResponder];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    self.title = NSLocalizedString(@"Outlook", nil);

    NSURL *accountDataURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];

    NSString *dbPath = [[accountDataURL URLByAppendingPathComponent:REM_USER_DB_PATH] path];
    dbPath = [dbPath stringByAbbreviatingWithTildeInPath];
    [[NSUserDefaults standardUserDefaults] setObject:dbPath
                                              forKey:REM_USER_DB_PATH];

    ZXHMail_ContainObjectContoller *account = [[ZXHMail_ContainObjectContoller alloc] init];
    account.zxh_mail_account_name = self.emailAddress_td.text;

    if (![ZXHMail_ContainObjectContoller haveSaveAccountByName:account.zxh_mail_account_name dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]]) {
        [ZXHMail_ContainObjectContoller saveNewAccount:account dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
    }
    
    [self.delegate zxhLoginViewControllerFinished:self];
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

@end
