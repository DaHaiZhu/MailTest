//
//  ZXHMail_InboxTableViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-5-15.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMail_InboxTableViewController.h"
#import "MCTMsgViewController.h"
#import "MailCoreManager.h"
#import "ZXHActivityTitleView.h"
#import "ZXHMail_ContainObjectContoller.h"
#import "ZXHMail_BodyTableViewController.h"


#define NUMBER_OF_MESSAGES_TO_LOAD		10
static NSString *inboxInfoIdentifier = @"InboxStatusCell";
@interface ZXHMail_InboxTableViewController ()<MailCoreManagerDelegate,ZXHActivityTitleViewDelegate>
{
    MailCoreManager *mailmanager;
}

@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, strong) NSMutableDictionary *messagePreviews;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, retain) ZXHActivityTitleView *titleView;
@end

@implementation ZXHMail_InboxTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    // If tableView is scrolling as this VC is being dealloc'd
    // it continues to send messages (scrollViewDidScroll:) to its delegate.
    // This is fine if the delegate will outlive tableView (e.g. this VC would.)
    // However, if the delegate is an instance that may be dealloc'd
    // before the tableView
    // (i.e. _scrollProxy may be dealloc'd prior to tableView being dealloc'd)
    // the tableView will send messages to its delegate,
    // which is defined with an "assign" (i.e. unsafe_unretained) property.
    // This is a msgSend to non-nil'ed, invalid memory leading to a crash.
    // If or when UIScrollView's delegate is referred to with "weak" rather
    // than "assign", this can and should be removed.
    self.tableView.delegate = nil;
     [mailmanager cancelFetchOperation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.delegate = self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.loadMoreActivityView =
	[[UIActivityIndicatorView alloc]
	 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.totalNumberOfInboxMessages = [self.folderObj.zxh_mail_folder_totalCnt integerValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] != nil)
    {
        int rowCount = [[userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] intValue];
        if (rowCount>self.totalNumberOfInboxMessages) {
            [userDefaults removeObjectForKey:USER_DEFAULT_NUMBERTOLOAD];
            [userDefaults synchronize];
        }
    }
    
    self.messages = [[NSMutableArray array] init];
	self.messagePreviews = [NSMutableDictionary dictionary];
    [self setNavControllerBtnView];
    
    //title
    if ( [self.folderObj.zxh_mail_folder_unReadCnt intValue]>0) {
         NSString *countTitle = [NSString stringWithFormat:@"(%@)",self.folderObj.zxh_mail_folder_unReadCnt];
         self.title = [NSString stringWithFormat:@"%@%@",self.folderObj.zxh_mail_folder_showName,countTitle];
    }else
    {
         self.title = [NSString stringWithFormat:@"%@",self.folderObj.zxh_mail_folder_showName];
    }
    

    //refresh controller
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //加载邮件列表
    [self loadMailListFromLocalDB];
    
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberToLoad = [[userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] intValue];
    self.messages =   [ZXHMail_MailInfoObject fetchAllMailFromLocal:[[NSUserDefaults standardUserDefaults]objectForKey:REM_USER_DB_PATH ]
                                                           folderId:self.folderObj.zxh_mail_folder_id
                                                          accountid:self.accountObj.zxh_mail_account_id
                                                       numberToLoad:numberToLoad];
    
    [self.tableView reloadData];
}

- (void)loadMailListFromLocalDB
{
    //加载邮件列表，如果加载的数目超过本地服务器的数目，则访问邮件服务器，下载邮件列表；如果没有超过，则直接加载本地的列表
    self.isLoading = YES;
    NSInteger numberToLoad ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] != nil)
    {
        int rowToHighlight = [[userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] intValue];
        if (rowToHighlight <= 0) {
            numberToLoad = NUMBER_OF_MESSAGES_TO_LOAD;
        }else
        {
            numberToLoad = rowToHighlight;
        }
    }else
    {
        numberToLoad = NUMBER_OF_MESSAGES_TO_LOAD;
        [userDefaults setInteger:numberToLoad forKey:USER_DEFAULT_NUMBERTOLOAD];
        [userDefaults synchronize];
    }
    
    //从本地读取条数
    self.messages =   [ZXHMail_MailInfoObject fetchAllMailFromLocal:[[NSUserDefaults standardUserDefaults]objectForKey:REM_USER_DB_PATH ]
                                                                       folderId:self.folderObj.zxh_mail_folder_id
                                                                      accountid:self.accountObj.zxh_mail_account_id
                                                                   numberToLoad:numberToLoad];
    if (self.messages.count <numberToLoad  && self.totalNumberOfInboxMessages > self.messages.count)
    {
        //访问服务器 获取最新邮件列表
        [mailmanager fetchMailMessageFromServer:numberToLoad accountid:self.accountObj.zxh_mail_account_id totalMessages:self.totalNumberOfInboxMessages currentMessage:self.messages path:self.folderObj.zxh_mail_folder_remoteid folderid:self.folderObj.zxh_mail_folder_id];
    }else
    {
        self.isLoading = NO;
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //初始化mail变量
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults valueForKey:USER_DEFAULT_CONTENT_ROW] != nil)
    {
        CGPoint point = CGPointMake(0, [[userDefaults valueForKey:USER_DEFAULT_CONTENT_ROW] floatValue]);
        [self.tableView setContentOffset:point animated:NO];
    }
    
    
    //取消选中行状态
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     CGPoint point = self.tableView.contentOffset;
    [userDefaults setFloat:point.y+64 forKey:USER_DEFAULT_CONTENT_ROW];  //64,statusbar+navbar height
}


- (void)setAcitityTitle
{
    ZXHActivityTitleView *titleView = [[ZXHActivityTitleView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.delegate = self;
    titleView.title = self.folderObj.zxh_mail_folder_showName;
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    
}

- (void)setTitleWhenCountChanged
{

}

- (void)setNavControllerBtnView
{
    UIImage *image = [UIImage imageNamed:@"icon_nav_compose@2x.png"];
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 23);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(writeEmail:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)writeEmail:(id)arg
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [mailmanager cancelFetchOperation];
}

#pragma mark -  MailCoreMananerDelegate
- (void)callFetchMessageFinished
{
    self.isLoading = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberToLoad = [[userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] intValue];
    self.messages =   [ZXHMail_MailInfoObject fetchAllMailFromLocal:[[NSUserDefaults standardUserDefaults]objectForKey:REM_USER_DB_PATH ]
                                                           folderId:self.folderObj.zxh_mail_folder_id
                                                          accountid:self.accountObj.zxh_mail_account_id
                                                       numberToLoad:numberToLoad];
    
    [self.tableView reloadData];
}

- (void)callDeleteNonExistedMail
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberToLoad = [[userDefaults valueForKey:USER_DEFAULT_NUMBERTOLOAD] intValue];
    self.messages =   [ZXHMail_MailInfoObject fetchAllMailFromLocal:[[NSUserDefaults standardUserDefaults]objectForKey:REM_USER_DB_PATH ]
                                                           folderId:self.folderObj.zxh_mail_folder_id
                                                          accountid:self.accountObj.zxh_mail_account_id
                                                       numberToLoad:numberToLoad];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 1)
	{
		if (self.totalNumberOfInboxMessages >= 0)
			return 1;
		
		return 0;
	}
	
	return self.messages.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
	{
		return 110;
	}
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case 0:
		{
            static NSString *CellIdentifier = @"detailCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			ZXHMail_MailInfoObject * mailObj = self.messages[indexPath.row];
            //NSLog(@" message.header.messageID%@", message.header.messageID);
            UILabel *tLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *subLabel = (UILabel *)[cell viewWithTag:102];
            UILabel *detailLabel = (UILabel *)[cell viewWithTag:103];
            UILabel *timeLabel = (UILabel *)[cell viewWithTag:104];
            UIImageView *attachImage = (UIImageView *)[cell viewWithTag:105];
            UIImageView *unreadImage = (UIImageView *)[cell viewWithTag:106];
            
            if (!mailObj.zxh_mail_mailinfo_hasAttach) {
                [attachImage setHidden:YES];
            }else
            {
               [attachImage setHidden:NO];
               [attachImage setImage:[UIImage imageNamed:@"icon_attach_readmail.png"]];
            }
            
            
            if (!mailObj.zxh_mail_mailinfo_isRead) {
                [unreadImage setHidden:NO];
                [unreadImage setImage:[UIImage imageNamed:@"icon_status_unread.png"]];
            }else
            {
                [unreadImage setHidden:YES];
            }
            tLabel.text = mailObj.zxh_mail_mailinfo_fromNick;
            subLabel.text = mailObj.zxh_mail_mailinfo_subject;
            
            NSDate *receiveDate = [NSDate dateWithTimeIntervalSince1970:mailObj.zxh_mail_mailinfo_receiveUtc];
            
            timeLabel.text = [self compareMessageTime:[NSDate date] sendDate:receiveDate];

            if (mailObj.zxh_mail_mailinfo_abstract)
            {
                //检查邮件是否存在
                [mailmanager checkMailMessageIsNotExisted:mailObj];
                
                 NSString *newBody = [ mailObj.zxh_mail_mailinfo_abstract stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (newBody.length == 0) {
                    detailLabel.text = NSLocalizedString(@"(无摘要)", nil);
                }else
                {
                     detailLabel.text = mailObj.zxh_mail_mailinfo_abstract;
                }
            }else
            {
                detailLabel.text = nil;
                
                //====
                MCOIMAPFetchMessagesOperation * op = [[mailmanager session] fetchMessagesByUIDOperationWithFolder:mailObj.zxh_mail_mailinfo_folderName
                                                                                        requestKind:MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure|MCOIMAPMessagesRequestKindFlags
                                                                                               uids:[MCOIndexSet indexSetWithRange:MCORangeMake((uint32_t)[mailObj.zxh_mail_mailinfo_remoteid intValue], 0)]];
                [op start:^(NSError * error, NSArray * messages, MCOIndexSet * vanishedMessages) {
                    for(MCOIMAPMessage * msg in messages)
                    {
                        MCOIMAPMessageRenderingOperation * messageRenderingOperation = [[mailmanager session] plainTextBodyRenderingOperationWithMessage:msg
                                                                                                                                             folder:mailObj.zxh_mail_mailinfo_folderName];
                        
                        [messageRenderingOperation start:^(NSString * plainTextBodyString, NSError * error) {
                            mailObj.zxh_mail_mailinfo_abstract = plainTextBodyString;
                            [ZXHMail_MailInfoObject updateMailAbstract:mailObj dbPath:[[NSUserDefaults standardUserDefaults]
                                                                                       objectForKey:REM_USER_DB_PATH ]];
                            
                            NSString *newBody = [plainTextBodyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            if (newBody.length == 0 || plainTextBodyString.length == 0) {
                                detailLabel.text = NSLocalizedString(@"(无摘要)", nil);
                            }else
                            {
                                detailLabel.text = plainTextBodyString;
                            }
                        }];
                        break;
                    }
                    
                    //如果邮件不存在
                    if (error==nil && messages.count == 0)
                    {
                        [ZXHMail_MailInfoObject deleteMailById:mailObj.zxh_mail_mailinfo_mailid dbPath:[[NSUserDefaults standardUserDefaults]
                                                                                                            objectForKey:REM_USER_DB_PATH ]];
  
                        [self callDeleteNonExistedMail];
   
                    }else if (messages.count ==1)
                    {
                        MCOIMAPMessage * msg = [messages firstObject];
                        BOOL flag;
                        if (msg.flags == MCOMessageFlagSeen)
                        {
                            flag = true;
                        }else
                        {
                            flag = false;
                        }
                        
                        if (flag == mailObj.zxh_mail_mailinfo_isRead) return ;
                        mailObj.zxh_mail_mailinfo_isRead = flag;
                        //标记邮件flag
                        BOOL res = [ZXHMail_MailInfoObject updateMailUnSeenFlag:mailObj dbPath:[[NSUserDefaults standardUserDefaults]
                                                                                     objectForKey:REM_USER_DB_PATH ]];
                        if (res) {
                            [self callDeleteNonExistedMail];
                        }
                    }
                }];
                //====
            }
			return cell;
			break;
		}
			
		case 1:
		{
			UITableViewCell *cell =
			[tableView dequeueReusableCellWithIdentifier:inboxInfoIdentifier];
			
			if (!cell)
			{
				cell =
				[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:inboxInfoIdentifier];
				
				cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
				cell.textLabel.textAlignment = NSTextAlignmentCenter;
				cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
			}
			
			if (self.messages.count < self.totalNumberOfInboxMessages)
			{
//				cell.textLabel.text =
//				[NSString stringWithFormat:NSLocalizedString(@"加载下%d条", nil),
//				 MIN(self.totalNumberOfInboxMessages - self.messages.count,
//					 NUMBER_OF_MESSAGES_TO_LOAD)];
                cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"加载更多", nil)];
                cell.textLabel.textColor = [UIColor blueColor];

			}
			else
			{
				cell.textLabel.text = nil;
			}
			
			cell.detailTextLabel.text =
			[NSString stringWithFormat:NSLocalizedString(@"共:%d/%d", nil),
			 self.messages.count,self.totalNumberOfInboxMessages];
			
			cell.accessoryView = self.loadMoreActivityView;
			
			if (self.isLoading)
				[self.loadMoreActivityView startAnimating];
			else
				[self.loadMoreActivityView stopAnimating];
			
			return cell;
			break;
		}
			
		default:
			return nil;
			break;
	}
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section)
	{
		case 0:
		{
            ZXHMail_BodyTableViewController *mailBody = [self.storyboard instantiateViewControllerWithIdentifier:@"mail_body_table"];
            mailBody.mailInfo = self.messages[indexPath.row];
            [self.navigationController pushViewController:mailBody animated:YES];
			break;
		}
			
		case 1:
		{
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			
			if (!self.isLoading &&
				self.messages.count < self.totalNumberOfInboxMessages)
			{
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:self.messages.count + NUMBER_OF_MESSAGES_TO_LOAD
                                  forKey:USER_DEFAULT_NUMBERTOLOAD];
                [self loadMailListFromLocalDB];
				cell.accessoryView = self.loadMoreActivityView;
				[self.loadMoreActivityView startAnimating];
			}
			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			break;
		}
			
		default:
			break;
	}
    
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

- (NSString *)compareMessageTime:(NSDate *)currentDate sendDate:(NSDate *)sendDate
{
    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    NSDate * yesterday          =  [currentDate dateByAddingTimeInterval:-86400];
    NSDate * refDate            = sendDate;
    
    NSString * todayString      = [[currentDate description] substringToIndex:10];
    NSString * yesterdayString  = [[yesterday description] substringToIndex:10];
    NSString * refDateString    = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        [dataFormat setDateFormat:@"HH:mm"];
        NSString * syncTime        = [dataFormat stringFromDate:sendDate];
        return   syncTime;
    } else if ([refDateString isEqualToString:yesterdayString])
    {
        return NSLocalizedString(@"昨天", nil);
    }
    else
    {
        [dataFormat setDateFormat:@"MM-dd-yy"];
        NSString* str = [dataFormat stringFromDate:sendDate];
        return str;
    }
}

@end
