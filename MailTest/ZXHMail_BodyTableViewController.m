//
//  ZXHMail_BodyTableViewController.m
//  MailTest
//
//  Created by 朱星海 on 14-5-30.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMail_BodyTableViewController.h"
#import "MailCoreManager.h"
#import "ZXHMail_Attachment_infoObject.h"

static NSString * mainJavascript = @"\
var imageElements = function() {\
var imageNodes = document.getElementsByTagName('img');\
return [].slice.call(imageNodes);\
};\
\
var findCIDImageURL = function() {\
var images = imageElements();\
\
var imgLinks = [];\
for (var i = 0; i < images.length; i++) {\
var url = images[i].getAttribute('src');\
if (url.indexOf('cid:') == 0 || url.indexOf('x-mailcore-image:') == 0)\
imgLinks.push(url);\
}\
return JSON.stringify(imgLinks);\
};\
\
var replaceImageSrc = function(info) {\
var images = imageElements();\
\
for (var i = 0; i < images.length; i++) {\
var url = images[i].getAttribute('src');\
if (url.indexOf(info.URLKey) == 0) {\
images[i].setAttribute('src', info.LocalPathKey);\
break;\
}\
}\
};\
";

static NSString * mainStyle = @"\
body {\
font-family: Helvetica;\
font-size: 14px;\
width:320px;\
word-wrap: break-word;\
-webkit-text-size-adjust:none;\
-webkit-nbsp-mode: space;\
}\
\
pre {\
white-space: pre-wrap;\
}\
";
 
#define FONT_SIZE 17.0f
#define CELL_WEBVIEW_DEFAULT_HEIGHT 200.0f
#define CELL_DEFAULT_HEIGHT 44.0f
#define CELL_ATTACH_HEIGHT 60.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_DISPLAY_NAME_HEIGHT 20.0f
#define CELL_DISPLAY_NAME_WIDTH  150.0f
#define CELL_SHOWDETAIL_WIDTH  50.0f
#define CELL_IMAGE_ATTACH      16.0f
#define CELL_IMAGE_MARGIN      40.0f

#define CELL_DETAIL_TIME       15.0f
#define CELL_DETAIL_ATTACH     15.0f
#define CELL_DETAIL_ITEM_H     15.0f
#define CELL_DETAIL_ITEM_W     150.0f
#define CELL_DETAIL_TITLE_W    40.0f
#define CELL_DETAIL_TITLE_H    15.0f
#define CELL_DETAIL_MARGIN_X   4.0f
#define CELL_DETAIL_MARGIN_Y   4.0f
#define CELL_DETAIL_MARGIN     15.0f
#define CELL_DETAIL_SEPEATOR   5.0f

#define CELL_DISPLAYNAME_MARGIN_X 20.0f
#define CELL_DISPLAYNAME_MARGIN_Y 10.0f

@interface ZXHMail_BodyTableViewController ()<MailCoreManagerDelegate>
{
    float row_to_expand_height;
    MailCoreManager *mailmanager;
    float row_display_title_height;
    float row_display_web_height;
}
@end

@implementation ZXHMail_BodyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.loadMailContentDelegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.htmlString = [NSMutableString string];
    
    mailmanager = [MailCoreManager shareInstance];
    mailmanager.loadMailContentDelegate = self;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *footer =[[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    self.loadMoreActivityView =
	[[UIActivityIndicatorView alloc]
	 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadMoreActivityView startAnimating];

    
    
    [self setNavControllerBtnView];
    [self.navigationController setToolbarHidden:NO];
    
    //获取mail data
    [self getMailParseData];
}

- (void)getMailParseData
{
    if (self.mailInfo.zxh_mail_mailinfo_remoteid.length == 0) {
        [self.loadMoreActivityView stopAnimating];
        return;
    }
    MCOIMAPFetchMessagesOperation * op = [[mailmanager session] fetchMessagesByUIDOperationWithFolder:self.mailInfo.zxh_mail_mailinfo_folderName
                                                                                          requestKind:MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure
                                                                                                 uids:[MCOIndexSet indexSetWithRange:MCORangeMake((uint32_t)[self.mailInfo.zxh_mail_mailinfo_remoteid intValue], 0)]];
    [op start:^(NSError * error, NSArray * messages, MCOIndexSet * vanishedMessages) {
        for(MCOIMAPMessage * msg in messages)
        {
            NSLog(@"hash:%u",msg.hash);
            self.message = msg;
            [self fetchHtmlString:msg];
            break;
        }
    }];

}

- (void)fetchHtmlString:(MCOIMAPMessage *)msg
{
        //attachment
        self.attachArray = [[NSMutableArray alloc] init];
        if (msg.attachments.count>0)
        {
            for (MCOIMAPPart *part in msg.attachments)
            {
                ZXHMail_Attachment_infoObject *attach = [[ZXHMail_Attachment_infoObject alloc] init];
                attach.filename = part.filename;
                attach.filesize = part.size;
                attach.mimetype = part.mimeType;
                attach.description = part.description;
                attach.uniqueid = part.uniqueID;
                attach.partid = part.partID;
                [self.attachArray addObject:attach];
            }
        }
    
        MCOIMAPMessageRenderingOperation * messageRenderingOperation = [[mailmanager session] htmlBodyRenderingOperationWithMessage:msg
                                                                                                                                  folder:self.mailInfo.zxh_mail_mailinfo_folderName];

        [messageRenderingOperation start:^(NSString * htmlBodyString, NSError * error) {
            [self refreshHtml:htmlBodyString];
           
        }];
}


- (void)refreshHtml:(NSString *)content
{
    self.htmlString = [NSMutableString string];
	if (content == nil)
    {
		[self.htmlString appendString:@""];
	}else
    {
        [self.htmlString appendFormat:@"<html><head><script>%@</script><style>%@</style></head>"
         @"<body>%@</body><iframe src='x-mailcore-msgviewloaded:' style='width: 0px; height: 0px; border: none;'>"
         @"</iframe></html>", mainJavascript, mainStyle, content];
    }
    [self.tableView reloadData];
}

- (void)setNavControllerBtnView
{
    UIBarButtonItem *createFolderButton= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_next"]
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(writeEmail)];
    
    UIBarButtonItem *uploadButton= [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_prev"]
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(writeEmail)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:createFolderButton,uploadButton, nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2 + self.attachArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.row == 0)
    {
        NSString *text = [NSString stringWithFormat:@"%@",self.mailInfo.zxh_mail_mailinfo_subject];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:text
         attributes:attributes];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        CGFloat height = MAX(size.height, CELL_DEFAULT_HEIGHT);
        row_display_title_height = height + (CELL_CONTENT_MARGIN * 2)+row_to_expand_height+CELL_DISPLAY_NAME_HEIGHT;
        return row_display_title_height;
        
    }else if (indexPath.row == 1)
    {
        return MAX(row_display_web_height+CELL_CONTENT_MARGIN, self.view.frame.size.height - row_display_title_height+CELL_CONTENT_MARGIN);
    }else
    {
        return CELL_ATTACH_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    
    if (indexPath.row == 0) {

        NSString *text = [NSString stringWithFormat:@"%@",self.mailInfo.zxh_mail_mailinfo_subject];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{
                                                                                                         NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                                                                         }];
        CGRect rect = [attributedText boundingRectWithSize:constraint
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        if (!label)
        {
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label setMinimumScaleFactor:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont boldSystemFontOfSize:FONT_SIZE]];
            [label setText:text];
            [label setTag:100];
            [label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
            [[cell contentView] addSubview:label];
        }

        //display name,attachtment label,show details label
        
        UILabel *display_name_label = (UILabel *)[cell viewWithTag:101];
        if (!display_name_label)
        {
            display_name_label = [[UILabel alloc] init];
            [display_name_label setLineBreakMode:NSLineBreakByTruncatingTail];
            [display_name_label setNumberOfLines:1];
            [display_name_label setFont:[UIFont systemFontOfSize:12]];
            [display_name_label setText:self.mailInfo.zxh_mail_mailinfo_fromNick];
            [display_name_label setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.1 alpha:1]];
            [display_name_label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X,label.frame.size.height+CELL_DISPLAYNAME_MARGIN_Y, CELL_DISPLAY_NAME_WIDTH, CELL_DISPLAY_NAME_HEIGHT)];
            [display_name_label setTag:101];
            [[cell contentView] addSubview:display_name_label];
        }
        
        UIImageView *attach_imageView = (UIImageView *)[cell viewWithTag:102];
        UILabel *attach_label = (UILabel *)[cell viewWithTag:103];
        
        if (!attach_imageView)
        {
            attach_imageView = [[UIImageView alloc] init];
            [attach_imageView setFrame:CGRectMake(display_name_label.frame.origin.x+display_name_label.frame.size.width+CELL_IMAGE_MARGIN, display_name_label.frame.origin.y+2, CELL_IMAGE_ATTACH, CELL_IMAGE_ATTACH)];
            [attach_imageView setImage:[UIImage imageNamed:@"icon_attach_readmail.png"]];
            [attach_imageView setTag:102];
            [[cell contentView] addSubview:attach_imageView];

        }
        if (!attach_label)
        {
            attach_label = [[UILabel alloc] init];
            [attach_label setLineBreakMode:NSLineBreakByTruncatingTail];
            [attach_label setNumberOfLines:1];
            [attach_label setFont:[UIFont systemFontOfSize:12]];
            [attach_label setText:[NSString stringWithFormat:@"%d",self.mailInfo.zxh_mail_mailinfo_attach_count]];
            [attach_label setTextColor:[UIColor lightGrayColor]];
            [attach_label setFrame:CGRectMake(attach_imageView.frame.origin.x+attach_imageView.frame.size.width,display_name_label.frame.origin.y, CELL_DISPLAY_NAME_HEIGHT, CELL_DISPLAY_NAME_HEIGHT)];
            [attach_label setTag:103];
            [[cell contentView] addSubview:attach_label];
        }
        if (self.mailInfo.zxh_mail_mailinfo_hasAttach)
        {
            attach_label.hidden = NO;
            attach_imageView.hidden = NO;
        }else
        {
            attach_label.hidden = YES;
            attach_imageView.hidden = YES;
        }
        
    
         UIButton *show_detail_btn = (UIButton *)[cell viewWithTag:104];
        if (!show_detail_btn)
        {
            show_detail_btn = [[UIButton alloc] init];
            [show_detail_btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [show_detail_btn setTitleColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.1 alpha:1]
                                  forState:UIControlStateNormal];
            [show_detail_btn setTitle:@"显示详情" forState:UIControlStateNormal];
            [show_detail_btn setFrame:CGRectMake(attach_label.frame.origin.x+attach_label.frame.size.width,display_name_label.frame.origin.y, CELL_SHOWDETAIL_WIDTH, CELL_DISPLAY_NAME_HEIGHT)];
            [show_detail_btn setTag:104];
            [show_detail_btn addTarget:self action:@selector(showOrHideDetail:) forControlEvents:UIControlEventTouchUpInside];
            [[cell contentView] addSubview:show_detail_btn];
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }else if (indexPath.row == 1)
    {
        self.loadMoreActivityView.center = cell.contentView.center;
        [cell.contentView addSubview:self.loadMoreActivityView];
        
        if (![self.loadMoreActivityView isAnimating])
        {
            self.webView = (UIWebView *)[cell viewWithTag:200];
            if (!self.webView)
            {
                self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, cell.frame.size.height)];
                [self.webView loadHTMLString:self.htmlString baseURL:nil];
                self.webView.tag = 200;
                self.webView.delegate = self;
                self.webView.scrollView.scrollEnabled = NO;
                self.webView.scrollView.bounces = NO;
                self.webView.userInteractionEnabled = YES;
               [self.webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];
                [cell addSubview:self.webView];
            }
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"attachCell"];
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:301];
        UILabel *sizeLabel = (UILabel *)[cell viewWithTag:302];
        UIImageView *attachImage = (UIImageView *)[cell viewWithTag:300];
        ZXHMail_Attachment_infoObject *attach = [self.attachArray objectAtIndex:indexPath.row-2];
        nameLabel.text = attach.filename;
        sizeLabel.text = [self mailFileSize:attach.filesize];
        [self setMailFileIcon:attachImage fileName:attach.filename];
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - WebView Delegate
//NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
//[_webView loadRequest:req];

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL);
    if ([[UIApplication sharedApplication] canOpenURL:request.URL])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    CGRect frame = [webView frame];
    frame.size.height = [string floatValue]+CELL_CONTENT_MARGIN ;
    row_display_web_height = frame.size.height;
    [self.webView setFrame:frame];
    [self.tableView reloadData];
 /*
    NSString * result = [webView stringByEvaluatingJavaScriptFromString:@"findCIDImageURL()"];
    NSLog(@"----------");
    NSLog(@"%@", result);
	NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	NSArray * imagesURLStrings = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSString * path = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"155185486"] stringByAppendingPathExtension:@"jpg"];
    
    NSURL * cacheURL = [NSURL fileURLWithPath:path];
    
    NSDictionary * args = @{ @"URLKey": [imagesURLStrings objectAtIndex:1], @"LocalPathKey": cacheURL.absoluteString };
    
    NSData * json = [NSJSONSerialization dataWithJSONObject:args options:0 error:nil];
	NSString * jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    
    NSString * replaceScript = [NSString stringWithFormat:@"replaceImageSrc(%@)", jsonString];
    [webView stringByEvaluatingJavaScriptFromString:replaceScript];
  */
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)showOrHideDetail:(id)arg
{

    UIButton *button = (UIButton *)arg;
    UITableViewCell *cell = (UITableViewCell *)[self superviewWithClass:[UITableViewCell class] child:arg];
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"显示详情", nil)])
    {
        row_to_expand_height = 0;
       [button setTitle:NSLocalizedString(@"隐藏详情", nil) forState:UIControlStateNormal];
        UILabel *label;
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag == 101 || view.tag == 102 || view.tag == 103 ) {
                [view setHidden:YES];
            }else if (view.tag == 100)
            {
                label =(UILabel *)view;
            }
        }
        //加载更多信息
        int tagForDetail = 1000;

        //发件人标题
        UILabel *send_name_label = (UILabel *)[cell viewWithTag:tagForDetail];
        if (!send_name_label)
        {
            send_name_label = [[UILabel alloc] init];
            [send_name_label setLineBreakMode:NSLineBreakByTruncatingTail];
            [send_name_label setNumberOfLines:1];
            [send_name_label setFont:[UIFont systemFontOfSize:12]];
            [send_name_label setText:NSLocalizedString(@"发件人:", nil)];
            [send_name_label setTextColor:[UIColor lightGrayColor]];
            [send_name_label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X,label.frame.size.height+CELL_DETAIL_MARGIN, CELL_DETAIL_TITLE_W, CELL_DETAIL_TITLE_H)];
            [send_name_label setTag:tagForDetail];
            [send_name_label setTextAlignment:NSTextAlignmentRight];
            [[cell contentView] addSubview:send_name_label];
            tagForDetail++;
        }
        
        //发件人信息
        UILabel *send_name_display = (UILabel *)[cell viewWithTag:tagForDetail];
        if (!send_name_display)
        {
            send_name_display = [[UILabel alloc] init];
            [send_name_display setLineBreakMode:NSLineBreakByTruncatingTail];
            [send_name_display setNumberOfLines:1];
            [send_name_display setFont:[UIFont systemFontOfSize:12]];
            [send_name_display setText:self.mailInfo.zxh_mail_mailinfo_fromNick];
            [send_name_display setTextColor:[UIColor blackColor]];
            [send_name_display setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+send_name_label.frame.size.width,label.frame.size.height+CELL_DETAIL_MARGIN, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
            [send_name_display setTag:tagForDetail];
            [[cell contentView] addSubview:send_name_display];
            tagForDetail++;
            row_to_expand_height = row_to_expand_height +send_name_display.frame.size.height-1;
        }
        
        UILabel *send_name_email = (UILabel *)[cell viewWithTag:tagForDetail];
        if (!send_name_email)
        {
            send_name_email = [[UILabel alloc] init];
            [send_name_email setLineBreakMode:NSLineBreakByTruncatingTail];
            [send_name_email setNumberOfLines:1];
            [send_name_email setFont:[UIFont systemFontOfSize:12]];
            [send_name_email setText:self.mailInfo.zxh_mail_mailinfo_fromemail];
            [send_name_email setTextColor:[UIColor lightGrayColor]];
            [send_name_email setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+send_name_label.frame.size.width,send_name_display.frame.origin.y+CELL_DETAIL_ITEM_H, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
            [send_name_email setTag:tagForDetail];
            [[cell contentView] addSubview:send_name_email];
            tagForDetail++;
            row_to_expand_height = row_to_expand_height +send_name_email.frame.size.height-1;
        }
        
        //收件人标题
        NSArray *tosArray = [self.mailInfo.zxh_mail_mailinfo_tos componentsSeparatedByString:@","];
        UILabel  *lastTos_email_label;
        if (tosArray.count>0)
        {
            UILabel *tos_label = (UILabel *)[cell viewWithTag:tagForDetail];
            if (!tos_label)
            {
                tos_label = [[UILabel alloc] init];
                [tos_label setLineBreakMode:NSLineBreakByTruncatingTail];
                [tos_label setNumberOfLines:1];
                [tos_label setFont:[UIFont systemFontOfSize:12]];
                [tos_label setText:NSLocalizedString(@"收件人:", nil)];
                [tos_label setTextColor:[UIColor lightGrayColor]];
                [tos_label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X,send_name_email.frame.origin.y+CELL_DETAIL_MARGIN+CELL_DETAIL_SEPEATOR, CELL_DETAIL_TITLE_W, CELL_DETAIL_TITLE_H)];
                [tos_label setTag:tagForDetail];
                [tos_label setTextAlignment:NSTextAlignmentRight];
                [[cell contentView] addSubview:tos_label];
                tagForDetail++;
            }
            for (int i=0 ; i<tosArray.count; i++)
            {
                NSString *tosString = [tosArray objectAtIndex:i];
                NSArray *item = [tosString componentsSeparatedByString:@" <"];
                NSString *displayName;
                NSString *displayEmail;
                if (item.count>=2)
                {
                    displayEmail = [item objectAtIndex:1];
                    displayName = [[item objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }else
                {
                    displayName = tosString;
                    displayEmail = tosString;
                }
                if ([displayName rangeOfString:@"@"].location !=NSNotFound && [displayName hasPrefix:@"\""]==FALSE && [displayName hasSuffix:@"\""]==FALSE)
                {
                    displayName = [[displayName componentsSeparatedByString:@"@"] objectAtIndex:0];
                }
                displayEmail = [displayEmail stringByReplacingOccurrencesOfString:@">" withString:@""];
                displayName = [displayName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                UILabel *tos_name = (UILabel *)[cell viewWithTag:tagForDetail];
                if (!tos_name) {
                    int flag ;
                    if (i == 0)
                    {
                        flag = 0;
                    }else
                    {
                        flag = 1;
                    }
                    tos_name = [[UILabel alloc] init];
                    [tos_name setLineBreakMode:NSLineBreakByTruncatingTail];
                    [tos_name setNumberOfLines:1];
                    [tos_name setFont:[UIFont systemFontOfSize:12]];
                    [tos_name setText:displayName];
                    [tos_name setTextColor:[UIColor blackColor]];
                    [tos_name setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+tos_label.frame.size.width,tos_label.frame.origin.y+i*2*CELL_DETAIL_ITEM_H+flag*CELL_DETAIL_MARGIN_Y, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
                    [tos_name setTag:tagForDetail];
                    [[cell contentView] addSubview:tos_name];
                    tagForDetail++;
                    row_to_expand_height = row_to_expand_height +tos_name.frame.size.height;
                }
                
                UILabel *tos_email = (UILabel *)[cell viewWithTag:tagForDetail];
                if (!tos_email)
                {
                    tos_email = [[UILabel alloc] init];
                    [tos_email setLineBreakMode:NSLineBreakByTruncatingTail];
                    [tos_email setNumberOfLines:1];
                    [tos_email setFont:[UIFont systemFontOfSize:12]];
                    [tos_email setText:displayEmail];
                    [tos_email setTextColor:[UIColor lightGrayColor]];
                    [tos_email setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+tos_label.frame.size.width,tos_label.frame.origin.y+CELL_DETAIL_ITEM_H+i*2*CELL_DETAIL_ITEM_H, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
                    [tos_email setTag:tagForDetail];
                    [[cell contentView] addSubview:tos_email];
                    tagForDetail++;
                    row_to_expand_height = row_to_expand_height +tos_email.frame.size.height;
                }
                
                lastTos_email_label = tos_email;
            }
        }else
        {
            lastTos_email_label = send_name_email;
        }
         NSArray *ccsArray = [self.mailInfo.zxh_mail_mailinfo_ccs componentsSeparatedByString:@","];
        UILabel  *lastCc_email_label;
        if (ccsArray.count>0)
        {
            //抄送人标题
            UILabel *cc_label = (UILabel *)[cell viewWithTag:tagForDetail];
            if (!cc_label)
            {
                cc_label = [[UILabel alloc] init];
                [cc_label setLineBreakMode:NSLineBreakByTruncatingTail];
                [cc_label setNumberOfLines:1];
                [cc_label setFont:[UIFont systemFontOfSize:12]];
                [cc_label setText:NSLocalizedString(@"抄送:", nil)];
                [cc_label setTextColor:[UIColor lightGrayColor]];
                [cc_label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X,lastTos_email_label.frame.origin.y+CELL_DETAIL_MARGIN+CELL_DETAIL_SEPEATOR, CELL_DETAIL_TITLE_W, CELL_DETAIL_TITLE_H)];
                [cc_label setTag:tagForDetail];
                [cc_label setTextAlignment:NSTextAlignmentRight];
                [[cell contentView] addSubview:cc_label];
                tagForDetail++;
            }
            
            //抄送人列表

            for (int i=0 ; i<ccsArray.count; i++)
            {
                NSString *ccString = [tosArray objectAtIndex:i];
                NSArray *item = [ccString componentsSeparatedByString:@" <"];
                NSString *displayName;
                NSString *displayEmail;
                if (item.count>=2)
                {
                    displayName = [[item objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    displayEmail = [item objectAtIndex:1];
                }else
                {
                    displayName = ccString;
                    displayEmail = ccString;
                }
                if ([displayName rangeOfString:@"@"].location !=NSNotFound && [displayName hasPrefix:@"\""]==FALSE && [displayName hasSuffix:@"\""]==FALSE)
                {
                    displayName = [[displayName componentsSeparatedByString:@"@"] objectAtIndex:0];
                }
                displayEmail = [displayEmail stringByReplacingOccurrencesOfString:@">" withString:@""];
                displayName = [displayName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                UILabel *cc_name = (UILabel *)[cell viewWithTag:tagForDetail];
                if (!cc_name) {
                    int flag ;
                    if (i == 0)
                    {
                        flag = 0;
                    }else
                    {
                        flag = 1;
                    }
                    cc_name = [[UILabel alloc] init];
                    [cc_name setLineBreakMode:NSLineBreakByTruncatingTail];
                    [cc_name setNumberOfLines:1];
                    [cc_name setFont:[UIFont systemFontOfSize:12]];
                    [cc_name setText:displayName];
                    [cc_name setTextColor:[UIColor blackColor]];
                    [cc_name setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+cc_label.frame.size.width,cc_label.frame.origin.y+i*2*CELL_DETAIL_ITEM_H+flag*CELL_DETAIL_MARGIN_Y, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
                    [cc_name setTag:tagForDetail];
                    [[cell contentView] addSubview:cc_name];
                    tagForDetail++;
                    row_to_expand_height = row_to_expand_height +cc_name.frame.size.height;
                }
                
                UILabel *cc_email = (UILabel *)[cell viewWithTag:tagForDetail];
                if (!cc_email)
                {
                    cc_email = [[UILabel alloc] init];
                    [cc_email setLineBreakMode:NSLineBreakByTruncatingTail];
                    [cc_email setNumberOfLines:1];
                    [cc_email setFont:[UIFont systemFontOfSize:12]];
                    [cc_email setText:displayEmail];
                    [cc_email setTextColor:[UIColor lightGrayColor]];
                    [cc_email setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+cc_label.frame.size.width,cc_label.frame.origin.y+CELL_DETAIL_ITEM_H+i*2*CELL_DETAIL_ITEM_H, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
                    [cc_email setTag:tagForDetail];
                    [[cell contentView] addSubview:cc_email];
                    tagForDetail++;
                    row_to_expand_height = row_to_expand_height +cc_email.frame.size.height;
                }
                
                lastCc_email_label = cc_email;
            }
        }else
        {
            lastCc_email_label = lastTos_email_label;
        }

        //时间标题
        UILabel *time_label = (UILabel *)[cell viewWithTag:tagForDetail];
        if (!time_label)
        {
            time_label = [[UILabel alloc] init];
            [time_label setLineBreakMode:NSLineBreakByTruncatingTail];
            [time_label setNumberOfLines:1];
            [time_label setFont:[UIFont systemFontOfSize:12]];
            [time_label setText:NSLocalizedString(@"时间:", nil)];
            [time_label setTextColor:[UIColor lightGrayColor]];
            [time_label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X,lastCc_email_label.frame.origin.y+CELL_DETAIL_MARGIN+CELL_DETAIL_SEPEATOR, CELL_DETAIL_TITLE_W, CELL_DETAIL_TITLE_H)];
            [time_label setTag:tagForDetail];
            [time_label setTextAlignment:NSTextAlignmentRight];
            [[cell contentView] addSubview:time_label];
            tagForDetail++;
        }
        //时间内容
        UILabel *time_info = (UILabel *)[cell viewWithTag:tagForDetail];
        if (!time_info)
        {
            NSDate *receiveDate = [NSDate dateWithTimeIntervalSince1970:self.mailInfo.zxh_mail_mailinfo_receiveUtc];
            NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
            [dataFormat setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
            NSString* timeStr = [dataFormat stringFromDate:receiveDate];
            
            time_info = [[UILabel alloc] init];
            [time_info setLineBreakMode:NSLineBreakByTruncatingTail];
            [time_info setNumberOfLines:1];
            [time_info setFont:[UIFont systemFontOfSize:12]];
            [time_info setText:timeStr];
            [time_info setTextColor:[UIColor lightGrayColor]];
            [time_info setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+time_label.frame.size.width,time_label.frame.origin.y, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
            [time_info setTag:tagForDetail];
            [[cell contentView] addSubview:time_info];
            tagForDetail++;
            row_to_expand_height = row_to_expand_height +time_info.frame.size.height;
        }
        
        //附件标题
        if (self.mailInfo.zxh_mail_mailinfo_hasAttach)
        {
            UILabel *attach_label = (UILabel *)[cell viewWithTag:tagForDetail];
            if (!attach_label)
            {
                attach_label = [[UILabel alloc] init];
                [attach_label setLineBreakMode:NSLineBreakByTruncatingTail];
                [attach_label setNumberOfLines:1];
                [attach_label setFont:[UIFont systemFontOfSize:12]];
                [attach_label setText:NSLocalizedString(@"附件:", nil)];
                [attach_label setTextColor:[UIColor lightGrayColor]];
                [attach_label setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X,time_label.frame.origin.y+CELL_DETAIL_MARGIN+CELL_DETAIL_SEPEATOR, CELL_DETAIL_TITLE_W, CELL_DETAIL_TITLE_H)];
                [attach_label setTag:tagForDetail];
                [attach_label setTextAlignment:NSTextAlignmentRight];
                [[cell contentView] addSubview:attach_label];
                tagForDetail++;
                row_to_expand_height = row_to_expand_height +attach_label.frame.size.height;
            }
            
            UIImageView *attach_imageView = (UIImageView *)[cell viewWithTag:tagForDetail];
            if (!attach_imageView)
            {
                attach_imageView = [[UIImageView alloc] init];
                [attach_imageView setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+attach_label.frame.size.width,attach_label.frame.origin.y, CELL_IMAGE_ATTACH, CELL_IMAGE_ATTACH)];
                [attach_imageView setImage:[UIImage imageNamed:@"icon_attach_readmail.png"]];
                [attach_imageView setTag:tagForDetail];
                [[cell contentView] addSubview:attach_imageView];
                tagForDetail++;
            }
            
            //附件个数
            UILabel *attach_info = (UILabel *)[cell viewWithTag:tagForDetail];
            if (!attach_info)
            {
                attach_info = [[UILabel alloc] init];
                [attach_info setLineBreakMode:NSLineBreakByTruncatingTail];
                [attach_info setNumberOfLines:1];
                [attach_info setFont:[UIFont systemFontOfSize:12]];
                [attach_info setText:[NSString stringWithFormat:@"%d",self.mailInfo.zxh_mail_mailinfo_attach_count]];
                [attach_info setTextColor:[UIColor lightGrayColor]];
                [attach_info setFrame:CGRectMake(CELL_DISPLAYNAME_MARGIN_X+CELL_DETAIL_MARGIN_X+attach_label.frame.size.width+CELL_IMAGE_ATTACH,attach_label.frame.origin.y, CELL_DETAIL_ITEM_W, CELL_DETAIL_ITEM_H)];
                [attach_info setTag:tagForDetail];
                [[cell contentView] addSubview:attach_info];
                tagForDetail++;
            }
        }
        //[self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
    }else if ([button.titleLabel.text isEqualToString:NSLocalizedString(@"隐藏详情", nil)])
    {
        row_to_expand_height = 0;
        [button setTitle:NSLocalizedString(@"显示详情", nil) forState:UIControlStateNormal];
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag>200) {
                [view removeFromSuperview];
            }else if (view.tag == 101 || view.tag == 102 || view.tag == 103 ) {
                [view setHidden:NO];
            }

        }
       // [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
    }
        [self.tableView reloadData];
}

#pragma mark -
#pragma mark #iOS7获取TABLEVIEW SUPERVIEW
- (UIView*)superviewWithClass:(Class)class child:(UIView*)child
{
    UIView *superview =nil;
    superview = child.superview;
    while (superview !=nil && ![superview isKindOfClass:class]) {
        superview = superview.superview;
    }
    return superview;
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

#pragma mark - Judge FileType  and SIZE
- (NSString *)mailFileSize:(unsigned long long)size
{
	NSString *formattedStr = nil;
    if (size == 0)
		formattedStr = @"0 bytes";
	else
		if (size > 0 && size < 1024)
			formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
	
	return formattedStr;
}

-(void)setMailFileIcon:(UIImageView *)fileIcon fileName:(NSString *)theFullPath
{
    
#define M_AUDIO     [NSArray arrayWithObjects:@"mp3",@"aac",@"wav",@"wma",nil]
#define M_VIDEO     [NSArray arrayWithObjects:@"mp4",@"3gp",@"rm",@"rmvb",@"mov",@"mpv",@"avi",nil]
#define M_COMPRESS  [NSArray arrayWithObjects:@"zip",@"rar",@"7z",nil]
#define M_EML       [NSArray arrayWithObjects:@"eml",nil]
#define M_EXCEL     [NSArray arrayWithObjects:@"xls",@"xlsx",nil]
#define M_FLASH     [NSArray arrayWithObjects:@"fla",@"swf",nil]
#define M_HTML      [NSArray arrayWithObjects:@"xml",@"json",@"html",@"htm",nil]
#define M_IMAGE     [NSArray arrayWithObjects:@"png",@"jpg",@"jpeg",@"gif",@"tiff",@"raw",@"bmp",nil]
#define M_KEYNOTE   [NSArray arrayWithObjects:@"key",nil]
#define M_NUMBERS   [NSArray arrayWithObjects:@"numbers",nil]
#define M_PAGES     [NSArray arrayWithObjects:@"pages",nil]
#define M_PDF       [NSArray arrayWithObjects:@"pages",nil]
#define M_PSD       [NSArray arrayWithObjects:@"pages",nil]
#define M_TXT       [NSArray arrayWithObjects:@"txt",@"rtf",@"log",@"csv",nil]
#define M_WORD      [NSArray arrayWithObjects:@"doc",@"docx",nil]
#define M_PPT       [NSArray arrayWithObjects:@"ppt",@"pptx",nil]
    
    NSString *type=[[[theFullPath lastPathComponent] lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    type=[[type componentsSeparatedByString:@"."] lastObject];
    if ([M_AUDIO containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_audio_51h"]];
    }else if ([M_VIDEO containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_video_51h"]];
    }else if ([M_COMPRESS containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_compress_51h"]];
    }else if ([M_EML containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_eml_51h"]];
    }else if ([M_EXCEL containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_excel_51h"]];
    }else if ([M_FLASH containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_flash_51h"]];
    }else if ([M_HTML containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_html_51h"]];
    }else if ([M_IMAGE containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_image_51h"]];
    }else if ([M_KEYNOTE containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_keynote_51h"]];
    }else if ([M_NUMBERS containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_numbers_51h"]];
    }else if ([M_PAGES containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_pages_51h"]];
    }else if ([M_PDF containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_pdf_51h"]];
    }else if ([M_PSD containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_psd_51h"]];
    }else if ([M_TXT containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_txt_51h"]];
    }else if ([M_WORD containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_word_51h"]];
    }else if ([M_PPT containsObject:type])
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_ppt_51h"]];
    }else
    {
        [fileIcon setImage:[UIImage imageNamed:@"filetype_others_51h"]];
    }
}
@end
