//
//  MailCoreManager.m
//  MailTest
//
//  Created by 朱星海 on 14-5-22.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "MailCoreManager.h"
#import <MailCore/MailCore.h>
#import "ZXHMail_ContainObjectContoller.h"

@implementation MailCoreManager
static MailCoreManager *shareInstance;

+(MailCoreManager*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[[MailCoreManager alloc] init];
    });
    return shareInstance;
}

- (MCOIMAPSession *)session
{
    return imapSession;
}
//停止操作

- (void)cancelFetchOperation
{
    [imapCheckOp cancel];
    [imapFolderFecthOp cancel];
    [imapMessagesFetchOp cancel];
    [imapSession disconnectOperation];
}

- (void)loginToDomainWithTLS:(NSString *)hostName hostPort:(NSInteger)hostPort username:(NSString *)username password:(NSString *)password
{
    imapSession = [[MCOIMAPSession alloc] init];
    [imapSession setHostname:hostName];
    [imapSession setPort:hostPort];
    [imapSession setConnectionType:MCOConnectionTypeTLS];
    [imapSession setUsername:username];
    [imapSession setPassword:password];
    //check account login
    imapCheckOp = [imapSession checkAccountOperation];
    
    [imapCheckOp start:^(NSError *error){
        if (error != nil) {
            if ([self.delegate respondsToSelector:@selector(callLoginFinishedFailOnLoginController:)]) {
                [self.delegate callLoginFinishedFailOnLoginController:error];
            }
            if ([self.loadFolderDelegate respondsToSelector:@selector(callLoginFinishedFailOnLoginController:)]) {
                [self.loadFolderDelegate callLoginFinishedFailOnLoginController:error];
            }
        }else
        {
            
            if ([self.delegate respondsToSelector:@selector(callLoginFinishedSuccessOnLoginController)]) {
                [self.delegate callLoginFinishedSuccessOnLoginController];
            }
            
            if ([self.loadFolderDelegate respondsToSelector:@selector(callLoginFinishedSuccessOnLoginController)]) {
                [self.loadFolderDelegate callLoginFinishedSuccessOnLoginController];
            }
            
            //定时检查邮件
            static dispatch_once_t onceCheck;
            dispatch_once(&onceCheck, ^{
                NSTimer *timer=[NSTimer timerWithTimeInterval:MAIL_CHECK_FREQUENCY target:self selector:@selector(fetchMailFolderList) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            });
        }
        imapCheckOp = nil;
    }];
    
}
- (void)fetchMailFolderList
{
    ZXHMail_ContainObjectContoller *account = [ZXHMail_ContainObjectContoller fetchAccountFromLocalByName:[[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey] dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
    if (imapSession == nil) return;
    imapFolderFecthOp = [imapSession fetchAllFoldersOperation];
    [imapFolderFecthOp start:^(NSError *error , NSArray *folders){
        if ([self.loadFolderDelegate respondsToSelector:@selector(callFetchFolderFromSevFinished)])
        {
            [self.loadFolderDelegate callFetchFolderFromSevFinished];
        }
        if(!error)
        {
            //存入本地数据库
            [self saveFolderListToLocalDB:folders accountid:account.zxh_mail_account_id];
        }
        else{
            NSLog(@"%@",error);
        }
        imapFolderFecthOp = nil;
    }];
}

- (void)saveFolderListToLocalDB:(NSArray *)folders accountid:(NSUInteger)accountid
{
    for (MCOIMAPFolder *folder in folders) {
        MCOIMAPFolderInfoOperation * op = [imapSession folderInfoOperation:folder.path];

        [op start:^(NSError *error, MCOIMAPFolderInfo * info) {
            if (!error) {
    
                ZXHMail_FolderObject *folderObj = [[ZXHMail_FolderObject alloc] init];
                folderObj.zxh_mail_folder_accountid = accountid;
                folderObj.zxh_mail_folder_remoteid = folder.path;
                folderObj.zxh_mail_folder_name = folder.path;
                folderObj.zxh_mail_folder_totalCnt = [NSString stringWithFormat:@"%d",info.messageCount];
                NSData* data = [folder.path dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableString* displayName = [[NSMutableString alloc] initWithData:data encoding:
                                                CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF7_IMAP)];
                folderObj.zxh_mail_folder_showName = displayName;

                //parent folder
                NSString *delimiter = [NSString stringWithFormat:@"%c",folder.delimiter];
                NSArray *composeArr = [folder.path componentsSeparatedByString:delimiter];
                
                if (composeArr.count == 2) {
                    folderObj.zxh_mail_folder_parentName = [composeArr objectAtIndex:0];
                    
                    NSData* data = [[composeArr objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableString* displayName = [[NSMutableString alloc] initWithData:data encoding:
                                                    CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF7_IMAP)];
                    
                    folderObj.zxh_mail_folder_showName = displayName;
                }
                if ([[folderObj.zxh_mail_folder_showName lowercaseString] isEqualToString:@"inbox"])
                {
                    folderObj.zxh_mail_folder_showName = NSLocalizedString(@"收件箱", nil);
                }
                
                folderObj.zxh_mail_folder_uidIder = [NSString stringWithFormat:@"%lu",(unsigned long)info.uidValidity];
                folderObj.zxh_mail_folder_uidNext = info.uidNext;
                
                if (folder.flags&MCOIMAPFolderFlagFolderTypeMask)
                {
                    folderObj.zxh_mail_folder_folderType = folder.flags;
                    folderObj.zxh_mail_folder_editType = @"0";  //不可编辑文件夹
                }else
                {
                    folderObj.zxh_mail_folder_folderType = 0;
                    folderObj.zxh_mail_folder_editType = @"1"; //可编辑文件夹
                }
                
                if ([[folder.path lowercaseString] isEqualToString:@"inbox"] && folder.flags != MCOIMAPFolderFlagInbox) {
                    folderObj.zxh_mail_folder_folderType = 1;
                    folderObj.zxh_mail_folder_editType = @"0";  //不可编辑文件夹
                }
                
                /*
                if ([ZXHMail_FolderObject haveSaveFolderById:folderObj dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]])
                {

                    //如果已经文件夹已经保存，则检查邮箱的UID是否发生改变，如果改变 则表示有新邮件，获取UID之后的所有新邮件
                    ZXHMail_FolderObject *obj  = [ZXHMail_FolderObject fetchFolderUidNextFromLocal:folderObj dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
                    if (obj) {
                        if (obj.zxh_mail_folder_uidNext < folderObj.zxh_mail_folder_uidNext)
                        {
                            //发现新邮件 从server获取邮件
                            [self fetchNewMailByUID:folderObj oldObj:obj];
                        }
                    }

                    
                }
                 */
                [self fetchFolderDetailInfoToLocalDB:folderObj];

            }
        }];
        op = nil;
    }
}

- (void)fetchNewMailByUID:(ZXHMail_FolderObject *)folder oldObj:(ZXHMail_FolderObject *)obj
{
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
	(MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
	 MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
	 MCOIMAPMessagesRequestKindFlags);

    imapMessagesFetchOp = [imapSession fetchMessagesByUIDOperationWithFolder:folder.zxh_mail_folder_remoteid requestKind:requestKind uids:[MCOIndexSet indexSetWithRange:MCORangeMake((uint64_t)obj.zxh_mail_folder_uidNext,UINT64_MAX)]];
    [imapMessagesFetchOp start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }else
        {
            //fetchedMessages 存入数据库
            [self saveMailListToLocalDB:fetchedMessages accountid:folder.zxh_mail_folder_accountid folderid:obj.zxh_mail_folder_id path:folder.zxh_mail_folder_remoteid];
        }
        //And, let's print out the messages...
        //NSLog(@"The post man delivereth:%@", fetchedMessages);
        
    }];
}

- (void)fetchFolderDetailInfoToLocalDB:(ZXHMail_FolderObject *)folder
{
    //获取folder的详细信息
    MCOIMAPFolderStatusOperation * statusOp = [imapSession folderStatusOperation:folder.zxh_mail_folder_remoteid];
    [statusOp start:^(NSError *error, MCOIMAPFolderStatus * infoStatus) {
       // NSLog(@"unseenCount count: %u", [infoStatus unseenCount]);
        folder.zxh_mail_folder_unReadCnt = [NSString stringWithFormat:@"%u",infoStatus.unseenCount];
        if (![ZXHMail_FolderObject haveSaveFolderById:folder dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]])
        {
            BOOL res  =  [ZXHMail_FolderObject saveNewFolder:folder
                                                      dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
            if (res)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_reloadFolderListUI
                                                                    object:self
                                                                  userInfo:nil];
            }
        }else
        {
            BOOL res  =  [ZXHMail_FolderObject updateFolder:folder dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
            if (res)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_reloadFolderListUI
                                                                    object:self
                                                                  userInfo:nil];
                
            }
        }
    }];
}

- (void)fetchMailMessageFromServer:(NSUInteger)nMessages accountid:(NSUInteger)account totalMessages:(NSUInteger)tMessages currentMessage:(NSMutableArray *)cArray path:(NSString *)folderPath folderid:(NSInteger)folderid
{
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
	(MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
	 MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
	 MCOIMAPMessagesRequestKindFlags);
   // requestKind |= MCOIMAPMessagesRequestKindGmailLabels | MCOIMAPMessagesRequestKindGmailThreadID | MCOIMAPMessagesRequestKindGmailMessageID;
    
    MCORange fetchRange  = MCORangeMake(tMessages - (nMessages - 1), (nMessages-cArray.count -1));
    if (tMessages < nMessages) {
        fetchRange = MCORangeMake(1, tMessages-cArray.count);
    }
    //fetchRange =  MCORangeMake(1, UINT64_MAX);
    imapMessagesFetchOp = [imapSession fetchMessagesByNumberOperationWithFolder:folderPath
                                              requestKind:requestKind
                                                  numbers:
     [MCOIndexSet indexSetWithRange:fetchRange]];
    [imapMessagesFetchOp start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        //Let's check if there was an error:
        NSLog(@"vanishedMessages%d",vanishedMessages.count);
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }else
        {
            //fetchedMessages 存入数据库
            
            [self saveMailListToLocalDB:fetchedMessages accountid:account folderid:folderid path:folderPath];
        }
        //And, let's print out the messages...
        //NSLog(@"The post man delivereth:%@", fetchedMessages);
        
    }];
}

- (void)saveMailListToLocalDB:(NSArray *)fetched accountid:(NSInteger)accountid folderid:(NSInteger)folderid path:(NSString *)folderPath
{
    for (MCOIMAPMessage *mail in fetched)
    {
        ZXHMail_MailInfoObject *mailObj = [[ZXHMail_MailInfoObject alloc] init];
        mailObj.zxh_mail_mailinfo_folderid = folderid;
        mailObj.zxh_mail_mailinfo_remoteid =  [NSString stringWithFormat:@"%lu",(unsigned long)mail.uid];
        if (mail.header.subject) {
            mailObj.zxh_mail_mailinfo_subject = mail.header.subject;
        }else
        {
            mailObj.zxh_mail_mailinfo_subject = NSLocalizedString(@"无主题", nil);
        }
        mailObj.zxh_mail_mailinfo_fromemail = mail.header.from.mailbox;
        mailObj.zxh_mail_mailinfo_tos = mail.header.to.mco_nonEncodedRFC822StringForAddresses;
        mailObj.zxh_mail_mailinfo_ccs = mail.header.cc.mco_nonEncodedRFC822StringForAddresses;
        mailObj.zxh_mail_mailinfo_bcc = mail.header.bcc.mco_nonEncodedRFC822StringForAddresses;
        mailObj.zxh_mail_mailinfo_replyto = mail.header.replyTo.mco_nonEncodedRFC822StringForAddresses;
        mailObj.zxh_mail_mailinfo_attach_count = mail.attachments.count;
        if (mail.attachments.count > 0)
        {
            mailObj.zxh_mail_mailinfo_hasAttach = true;
          
        }else
        {
            mailObj.zxh_mail_mailinfo_hasAttach = false;
        }
        mailObj.zxh_mail_mailinfo_receiveUtc = [mail.header.receivedDate timeIntervalSince1970];
        mailObj.zxh_mail_mailinfo_sendUtc = [mail.header.date timeIntervalSince1970];
        if (mail.flags == MCOMessageFlagSeen)
        {
            mailObj.zxh_mail_mailinfo_isRead = true;
        }else
        {
            mailObj.zxh_mail_mailinfo_isRead = false;
        }
        if (mail.header.sender.displayName == nil) {
            NSArray *array = [mail.header.sender.mailbox componentsSeparatedByString:@"@"];
            if (array.count == 2) {
                mailObj.zxh_mail_mailinfo_fromNick = array[0];
            }else
            {
                mailObj.zxh_mail_mailinfo_fromNick = mail.header.sender.mailbox;
            }
        }else
        {
            mailObj.zxh_mail_mailinfo_fromNick =  mail.header.sender.displayName;

        }
        
        
        mailObj.zxh_mail_mailinfo_messageId = mail.header.messageID;
        mailObj.zxh_mail_mailinfo_folderName = folderPath;
        mailObj.zxh_mail_mailinfo_accountid = accountid;
        if (![ZXHMail_MailInfoObject haveSaveMailById:mailObj
                                               dbPath:[[NSUserDefaults standardUserDefaults]
                                                       objectForKey:REM_USER_DB_PATH ]])
        {
            BOOL res = [ZXHMail_MailInfoObject saveNewMailInfo:mailObj dbPath:[[NSUserDefaults standardUserDefaults]
                                                                    objectForKey:REM_USER_DB_PATH ]];
            if (res)
            {
                if ([self.delegate respondsToSelector:@selector(callFetchMessageFinished)]) {
                    [self.delegate callFetchMessageFinished];
                }
            }
        }else
        {
        
        }
    }
}

//检查邮箱文件夹是否存在
- (void)checkMailFolderIsNotExisted:(ZXHMail_FolderObject *)folder
{
      MCOIMAPFolderInfoOperation * op = [imapSession folderInfoOperation:folder.zxh_mail_folder_remoteid];
    [op start:^(NSError *error, MCOIMAPFolderInfo * info) {
        if (error.code == MCOErrorNonExistantFolder)
        {
            //文件夹不存在
            //删除本地数据库中的文件夹和文件夹中的邮件，子文件夹单独考虑成文件夹，不用递归删除

            [ZXHMail_FolderObject deleteFolderById:folder.zxh_mail_folder_id dbPath:[[NSUserDefaults standardUserDefaults]
                                                                                     objectForKey:REM_USER_DB_PATH ]];
            [ZXHMail_MailInfoObject deleteMailByFolderId:folder.zxh_mail_folder_id dbPath:[[NSUserDefaults standardUserDefaults]
                                                                                           objectForKey:REM_USER_DB_PATH ]];
            if ([self.loadFolderDelegate respondsToSelector:@selector(callDeleteNonExistedFolder)])
            {
                [self.loadFolderDelegate callDeleteNonExistedFolder];
            }
  
        }
    }];
    
}
//检查邮件是否存在
- (void)checkMailMessageIsNotExisted:(ZXHMail_MailInfoObject *)mailMessage
{
    MCOIMAPFetchMessagesOperation * op = [imapSession fetchMessagesByUIDOperationWithFolder:mailMessage.zxh_mail_mailinfo_folderName
                                                                                          requestKind:MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure|MCOIMAPMessagesRequestKindFlags
                                                                                                 uids:[MCOIndexSet indexSetWithRange:MCORangeMake((uint32_t)[mailMessage.zxh_mail_mailinfo_remoteid intValue], 0)]];
    [op start:^(NSError * error, NSArray * messages, MCOIndexSet * vanishedMessages) {
        
        if (error==nil && messages.count == 0)
        {
            [ZXHMail_MailInfoObject deleteMailById:mailMessage.zxh_mail_mailinfo_mailid dbPath:[[NSUserDefaults standardUserDefaults]
                                                                                                      objectForKey:REM_USER_DB_PATH ]];
            if ([self.delegate respondsToSelector:@selector(callDeleteNonExistedMail)])
            {
                [self.delegate callDeleteNonExistedMail];
            }
        }else if (messages.count == 1)
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
            NSLog(@"%d",msg.flags);
            
            if (flag == mailMessage.zxh_mail_mailinfo_isRead) return ;
            mailMessage.zxh_mail_mailinfo_isRead = flag;
            
            //标记邮件flag
            BOOL res = [ZXHMail_MailInfoObject updateMailUnSeenFlag:mailMessage dbPath:[[NSUserDefaults standardUserDefaults]
                                                                         objectForKey:REM_USER_DB_PATH ]];
            if (res) {
                if ([self.delegate respondsToSelector:@selector(callDeleteNonExistedMail)])
                {
                    [self.delegate callDeleteNonExistedMail];
                }
            }
        }
    }];
}

@end
