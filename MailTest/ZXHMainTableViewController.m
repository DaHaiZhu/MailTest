//
//  ZXHMainTableViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-5-15.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMainTableViewController.h"
#import "FXKeychain.h"
#import "ZXHMail_InboxTableViewController.h"
#import "CHTumblrMenuView.h"
#import "ZXHMail_SettingTableViewController.h"
#import "MailCoreManager.h"
#import "ZXHMail_ContainObjectContoller.h"
#import "ZXHActivityTitleView.h"
#import "ZXHMail_BodyTableViewController.h"
#import "ZXHMySearchBar.h"

#define NUMBER_OF_MESSAGES_TO_LOAD		10
static NSString *inboxInfoIdentifier = @"InboxStatusCell";

@interface ZXHMainTableViewController ()<MailCoreManagerDelegate,ZXHActivityTitleViewDelegate>
{
    MailCoreManager *mailmanager;
    UISearchDisplayController *sd;
    UISearchBar *myBar;
    UIView *siew;
}

@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, strong) NSMutableDictionary *messagePreviews;
@property (nonatomic, strong) ZXHMail_ContainObjectContoller *accountObj;
@property (nonatomic, strong) NSMutableArray *folderList;
@property (nonatomic, retain) ZXHActivityTitleView *titleView;
@end

@implementation ZXHMainTableViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:Notification_reloadFolderListUI
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchFolderListFromLocalDB)
                                                 name:Notification_reloadFolderListUI
                                               object:nil];
    
    self.folderList = [[NSMutableArray alloc] init];
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.loadFolderDelegate = self;
    
    self.loadMoreActivityView =
	[[UIActivityIndicatorView alloc]
	 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self setSearchBar];
    
    //refresh controller
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //获取accountid
    
    [self getAccountID];
    
    [self setAcitityTitle];

    [self loadNavButton];

    [self fetchFolderListFromLocalDB];
    
}

- (void)setSearchBar
{
    siew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    ZXHMySearchBar *temp = [[ZXHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    temp.barStyle=UIBarStyleDefault;
    temp.searchBarStyle = UISearchBarStyleMinimal;
    temp.showsCancelButton = NO;
    temp.autocorrectionType=UITextAutocorrectionTypeNo;
    temp.autocapitalizationType=UITextAutocapitalizationTypeNone;
    temp.delegate=self;
    temp.scopeButtonTitles = @[@"发件人",@"收件人",@"主题",@"全部"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(260, 0, 60, 44);
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editMailBox) forControlEvents:UIControlEventTouchUpInside];
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:temp contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate=self;
    searchDisplayController.active = NO;

    sd = searchDisplayController;
    myBar = temp;
    [siew addSubview:temp];
    //[siew addSubview:btn];
    
    self.tableView.tableHeaderView =siew;

}

- (void)editMailBox
{
    self.tableView.editing = YES;
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //[searchBar becomeFirstResponder];
    //  searchBar.showsCancelButton = YES;
    searchBar.showsCancelButton = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    [searchBar setFrame:CGRectMake(0, 0, 320, 44)];
//    [searchBar resignFirstResponder];
//    siew.frame = CGRectMake(0, 0, 320, 44);
   // searchBar.showsCancelButton = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
   // [controller setActive:YES animated:YES];
    [controller.searchBar setFrame:CGRectMake(0, 0, 270, 44)];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    // [controller.searchBar removeFromSuperview];
    NSLog(@"%@",controller.searchBar);
    [controller.searchBar setFrame:CGRectMake(0, 0, 270, 44)];
     [controller setActive:NO animated:NO];
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
 //   siew.frame = CGRectMake(0, 0, 320, 44);
        [controller.searchBar setFrame:CGRectMake(0, 0, 270, 44)];
 //   [controller.searchBar removeFromSuperview];
//    [UIView animateWithDuration:0.1
//                     animations:^{
//                         [controller.searchBar setFrame:CGRectMake(0, 0, 270, 44)];
//                     }
//                     completion:^(BOOL finished){
//                         NSLog(@"completion block");
//                     }];
}


- (void)getAccountID
{
    self.accountObj = [ZXHMail_ContainObjectContoller fetchAccountFromLocalByName:[[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey] dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing)
    {
      
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0];
    }
}

-(void)handleData
{
    [self.refreshControl endRefreshing];
    [self.titleView.activityIndicator startAnimating];
    [mailmanager fetchMailFolderList];

}

- (void)setAcitityTitle
{
    ZXHActivityTitleView *titleView = [[ZXHActivityTitleView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.delegate = self;

    titleView.title = [[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //初始化mail变量
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.loadFolderDelegate = self;
    
    [self startLogin];
}

- (void)loadNavButton
{
    //** 导航栏按钮 **********************************************************************************
    // 自定义旋转式按钮
    UIImage *image = [UIImage imageNamed:@"icon_more@2x.png"];
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 23);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navPlusBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)navPlusBtnPressed:(id)sender
{
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    menuView.playAudio = TRUE;
    [menuView addMenuItemWithTitle:NSLocalizedString(@"写邮件", nil) andIcon:[UIImage imageNamed:@"mail_more_btn_writemail.png"] andSelectedBlock:^{
        NSLog(@"Text selected");
        

    }];
    [menuView addMenuItemWithTitle:NSLocalizedString(@"编辑", nil) andIcon:[UIImage imageNamed:@"mail_more_btn_edit.png"] andSelectedBlock:^{
        NSLog(@"Photo selected");
    }];
    [menuView addMenuItemWithTitle:NSLocalizedString(@"设置", nil) andIcon:[UIImage imageNamed:@"mail_more_btn_setting.png"] andSelectedBlock:^{
        NSLog(@"Quote selected");
        
        ZXHMail_SettingTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mail_settingtable"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];

    }];
    [menuView show];
}



- (void)startLogin
{
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey];
	NSString *password = [[FXKeychain defaultKeychain] objectForKey:PasswordKey];
    if (![password isKindOfClass:[NSString class]]) {
        [[FXKeychain defaultKeychain] removeObjectForKey:PasswordKey];
        password = nil;
    }
    if (!username.length || !password.length) {
        [self performSelector:@selector(showSettingsViewController:) withObject:nil afterDelay:0.5];
        return;
    }
    
    [self loadAccountWithUsername:username password:password hostname:Hostname oauth2Token:nil];
    
}

- (void)loadAccountWithUsername:(NSString *)username
                       password:(NSString *)password
                       hostname:(NSString *)hostname
                    oauth2Token:(NSString *)oauth2Token
{
    [mailmanager loginToDomainWithTLS:hostname hostPort:Hostport username:username password:password];
}

#pragma mark - MailCoreManagerDelegate
- (void)callLoginFinishedFailOnLoginController:(NSError *)error
{
    NSLog(@"error login:%@",[error description]);
    [self performSelector:@selector(showSettingsViewController:) withObject:nil afterDelay:0.5];
}

- (void)callLoginFinishedSuccessOnLoginController
{
    NSLog(@"login success");
    [self.titleView.activityIndicator startAnimating];
    [self getAccountID];
    [mailmanager fetchMailFolderList];
}

- (void)fetchFolderListFromLocalDB
{
    NSMutableArray *listArray = [ZXHMail_FolderObject fetchAllFolderFromLocal:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ] accountid:self.accountObj.zxh_mail_account_id];
    [self.folderList removeAllObjects];
    [self.folderList addObjectsFromArray:listArray];
    [self.tableView reloadData];
}

- (void)callFetchFolderFromSevFinished
{
    [self.titleView.activityIndicator stopAnimating];
}

- (void)callDeleteNonExistedFolder
{
    [self fetchFolderListFromLocalDB];
}

#pragma mark -
- (void)showSettingsViewController:(id)sender {

	ZXHLoginSetViewController *zxhLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingView"];
	zxhLoginViewController.delegate = self;
    UINavigationController  * vc = [[UINavigationController alloc] initWithRootViewController:zxhLoginViewController ];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)zxhLoginViewControllerFinished:(ZXHLoginSetViewController *)viewController {
	[self dismissViewControllerAnimated:YES completion:^{
        [self.titleView.activityIndicator stopAnimating];
        [mailmanager fetchMailFolderList];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [mailmanager cancelFetchOperation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
	return self.folderList.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return NSLocalizedString(@"文件夹", nil);
//    }
//    return nil;
//}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                static NSString *CellIdentifier = @"detailCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                ZXHMail_FolderObject *folder = [[ZXHMail_FolderObject alloc] init];
                folder = [self.folderList objectAtIndex:indexPath.row];
                
                cell.textLabel.text = folder.zxh_mail_folder_showName;
                cell.imageView.image = [UIImage imageNamed:@"icon_folder@2x.png"];
                //cell.imageView.contentMode = UIViewContentModeScaleToFill;
                float sw=30/cell.imageView.image.size.width;
                float sh=30/cell.imageView.image.size.height;
                cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
                
                if ([folder.zxh_mail_folder_unReadCnt isEqualToString:@"0"] || folder.zxh_mail_folder_unReadCnt == nil ) {
                    cell.detailTextLabel.text = @"";
                }else
                {
                    cell.detailTextLabel.text = folder.zxh_mail_folder_unReadCnt;
                }
                
                //检查文件夹是否存在
                [mailmanager checkMailFolderIsNotExisted:folder];
                
                return cell;
                break;
            }
            default:
            {
                static NSString *CellIdentifier = @"detailCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                return cell;
                break;
            }
        }
    }else
    {
        static NSString *CellIdentifier = @"detailCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section)
	{
		case 0:
		{

            ZXHMail_InboxTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mail_inbox"];
            vc.folderObj = [self.folderList objectAtIndex:indexPath.row];
            vc.accountObj = self.accountObj;
            [self.navigationController pushViewController:vc animated:YES];
            
			break;
		}
		default:
			break;
	}
    
}

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

//- (NSString *)compareMessageTime:(NSDate *)currentDate sendDate:(NSDate *)sendDate
//{
//    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
//    NSDate * yesterday          = [NSDate dateWithTimeIntervalSinceNow:-86400];
//    NSDate * refDate            = sendDate;
//    NSLocale *cnTime = [NSLocale currentLocale];
//    NSString * todayString      = [[currentDate descriptionWithLocale:cnTime] substringToIndex:10];
//    NSString * yesterdayString  = [[yesterday descriptionWithLocale:cnTime] substringToIndex:10];
//    NSString * refDateString    = [[refDate descriptionWithLocale:cnTime] substringToIndex:10];
//    
//    if ([refDateString isEqualToString:todayString])
//    {
//        [dataFormat setDateFormat:@"HH:mm"];
//        NSString * syncTime        = [dataFormat stringFromDate:sendDate];
//        return   syncTime;
//    } else if ([refDateString isEqualToString:yesterdayString])
//    {
//        return NSLocalizedString(@"昨天", nil);
//    }
//    else
//    {
//        [dataFormat setDateFormat:@"MM-dd-yy"];
//        NSString* str = [dataFormat stringFromDate:sendDate];
//        return str;
//    }
//}

@end
