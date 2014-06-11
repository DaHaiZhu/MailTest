//
//  ZXHMail_SettingTableViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-5-16.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMail_SettingTableViewController.h"
#import "ZXHLoginSetViewController.h"
#import "FXKeychain.h"
#import "MailCoreManager.h"

@interface ZXHMail_SettingTableViewController ()<MailCoreManagerDelegate>
{
    MailCoreManager *mailmanager;
}

@end

@implementation ZXHMail_SettingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"关闭", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeCurentView)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.title = NSLocalizedString(@"设置", nil);
    self.mail_delete_accout_btn.layer.cornerRadius = 3;
    self.mail_delete_accout_btn.layer.borderWidth = 0.5;
    self.mail_delete_accout_btn.layer.borderColor = [UIColor blueColor].CGColor;
    self.mail_delete_accout_btn.tintColor = [UIColor redColor];
    [self.mail_delete_accout_btn setTitle:NSLocalizedString(@"删除账户", nil)
                                 forState:UIControlStateNormal];
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.delegate = self;
}

- (void)closeCurentView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteCurrentAccountAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_NUMBERTOLOAD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULT_CONTENT_ROW];
    [[FXKeychain defaultKeychain] removeObjectForKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [mailmanager cancelFetchOperation];
}
@end
