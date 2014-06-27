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
static NSTimer *timer;
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
           [self stopTimer];
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
                timer=[NSTimer timerWithTimeInterval:MAIL_CHECK_FREQUENCY target:self selector:@selector(runLoopList) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            });
            [self startTimer];
        }
        imapCheckOp = nil;
    }];
    
}

- (void)startTimer
{
    [timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
     [timer setFireDate:[NSDate distantFuture]];
}

- (void)runLoopList
{
    if (imapSession.operationQueueRunning) {
        return;
    }else
    {
        NSLog(@"run loop");
    }
    @try {
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
                
            }
            imapFolderFecthOp = nil;
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
    }
}

- (void)fetchMailFolderList
{
    @try {
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

            }
            imapFolderFecthOp = nil;
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
    }
}


- (void)saveFolderListToLocalDB:(NSArray *)folders accountid:(NSUInteger)accountid
{
    for (MCOIMAPFolder *folder in folders) {
        
        //如果文件夹为不可选 则不保存到本地
        if (folder.flags == MCOIMAPFolderFlagNoSelect) continue;
        
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
                folderObj.zxh_mail_folder_svrKey = delimiter;   //保存分隔符;
                if (composeArr.count >= 2) {
                    
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:composeArr];
                    [temp removeLastObject];
                    NSString *newPath = [temp componentsJoinedByString:delimiter];
                    folderObj.zxh_mail_folder_parentName =newPath;
                    NSData* data = [[composeArr lastObject] dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableString* displayName = [[NSMutableString alloc] initWithData:data encoding:
                                                    CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF7_IMAP)];
                    
                    folderObj.zxh_mail_folder_showName = displayName;
                    folderObj.zxh_mail_folder_sequence_idr = [composeArr lastObject];
                }else
                {
                    folderObj.zxh_mail_folder_sequence_idr = folder.path;
                }
                if ([[folderObj.zxh_mail_folder_showName lowercaseString] isEqualToString:@"inbox"])
                {
                    folderObj.zxh_mail_folder_showName = NSLocalizedString(@"收件箱", nil);
                }else if([[folderObj.zxh_mail_folder_showName lowercaseString] isEqualToString:@"sent messages"])
                {
                    folderObj.zxh_mail_folder_showName = NSLocalizedString(@"已发送", nil);
                }else if([[folderObj.zxh_mail_folder_showName lowercaseString] isEqualToString:@"drafts"])
                {
                    folderObj.zxh_mail_folder_showName = NSLocalizedString(@"草稿箱", nil);
                }else if([[folderObj.zxh_mail_folder_showName lowercaseString] isEqualToString:@"deleted messages"])
                {
                    folderObj.zxh_mail_folder_showName = NSLocalizedString(@"废纸篓", nil);
                }else if([[folderObj.zxh_mail_folder_showName lowercaseString] isEqualToString:@"junk"])
                {
                    folderObj.zxh_mail_folder_showName = NSLocalizedString(@"垃圾邮件", nil);
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
                
                if ([[folder.path lowercaseString] isEqualToString:@"inbox"])
                {
                    __block ZXHMail_FolderObject *block_obj = folderObj;
                    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
                    dispatch_async(newThread, ^{
                        
                        if ([ZXHMail_FolderObject haveSaveFolderById:block_obj dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]])
                        {
                            
                            //如果已经文件夹已经保存，则检查邮箱的UID是否发生改变，如果改变 则表示有新邮件，获取UID之后的所有新邮件
                            ZXHMail_FolderObject *obj  = [ZXHMail_FolderObject fetchFolderUidNextFromLocal:block_obj dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
                            if (obj) {
                                if (obj.zxh_mail_folder_uidNext < block_obj.zxh_mail_folder_uidNext)
                                {
                                    //发现新邮件 从server获取邮件
                                    NSLog(@"======");
                                    NSLog(@"block_obj:%@",block_obj.zxh_mail_folder_showName);
                                    [self fetchNewMailByUID:block_obj oldObj:obj];
                                }
                            }
                        }
                    });
                }
                //=======================================
                /*
                 保存文件夹
                 */

                if (![ZXHMail_FolderObject haveSaveFolderById:folderObj dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]])
                {
                    BOOL res  =  [ZXHMail_FolderObject saveNewFolder:folderObj
                                                              dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
                    if (res)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_reloadFolderListUI
                                                                            object:self
                                                                          userInfo:nil];
                    }
                }else
                {
                    BOOL res  =  [ZXHMail_FolderObject updateFolder:folderObj dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
                    if (res)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_reloadFolderListUI
                                                                            object:self
                                                                          userInfo:nil];
                        
                    }
                }

               [self fetchFolderDetailInfoToLocalDB:folderObj];
            }else
            {
                NSLog(@"error:%@",error.description);
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

    imapMessagesFetchOp = [imapSession
                   fetchMessagesByUIDOperationWithFolder:folder.zxh_mail_folder_remoteid
                                                         requestKind:requestKind
                                                                uids:[MCOIndexSet indexSetWithRange:MCORangeMake((uint64_t)obj.zxh_mail_folder_uidNext,UINT64_MAX)]];
    [imapMessagesFetchOp start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
        //We've finished downloading the messages!
        //Let's check if there was an error:
        if(error) {
            NSLog(@"Error downloading message headers:%@", error);
        }else
        {
            //fetchedMessages 存入数据库
           
            [self saveMailListToLocalDB:fetchedMessages
                              accountid:folder.zxh_mail_folder_accountid
                               folderid:obj.zxh_mail_folder_id
                                   path:folder.zxh_mail_folder_remoteid];
        }
        //And, let's print out the messages...
        //NSLog(@"The post man delivereth:%@", fetchedMessages);
        
    }];
}

- (void)fetchFolderDetailInfoToLocalDB:(ZXHMail_FolderObject *)folder
{
    //获取folder的详细信息
    @try {

        MCOIMAPFolderStatusOperation *op = [imapSession folderStatusOperation:folder.zxh_mail_folder_remoteid];
        [op start:^(NSError *error, MCOIMAPFolderStatus * infoStatus) {
            folder.zxh_mail_folder_unReadCnt = [NSString stringWithFormat:@"%u",infoStatus.unseenCount];
            BOOL res  =  [ZXHMail_FolderObject updateFolder:folder dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH ]];
            if (res)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_reloadFolderListUI
                                                                    object:self
                                                                  userInfo:nil];
                
            }
        }];

    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception.description);
    }
    @finally {
       
    }

}

- (void)fetchMailMessageFromServer:(NSUInteger)nMessages accountid:(NSUInteger)account totalMessages:(NSUInteger)tMessages currentMessage:(NSMutableArray *)cArray path:(NSString *)folderPath folderid:(NSInteger)folderid
{
    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
	(MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
	 MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
	 MCOIMAPMessagesRequestKindFlags);
    
    MCORange fetchRange  = MCORangeMake(tMessages - (nMessages - 1), (nMessages-cArray.count -1));
    if (tMessages < nMessages) {
        fetchRange = MCORangeMake(1, tMessages-cArray.count);
    }
   
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
            if ([self.delegate respondsToSelector:@selector(callFetchMessageFinished)]) {
                [self.delegate callFetchMessageFinished];
            }
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


#pragma mark - MailFolder Operation
//文件夹操作
//新建文件夹

- (void)createNewMailFolder:(NSString *)foldername
{
    //编码 uft7-imap
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF7_IMAP);
    NSData *responseData =[foldername dataUsingEncoding:encode ];
    NSString *encodeStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    MCOIMAPOperation * op = [imapSession createFolderOperation:encodeStr];
    [op start:^(NSError * error) {
        if ([self.createFolderDelegate respondsToSelector:@selector(callCreateMailFolder:)])
        {
            [self.createFolderDelegate callCreateMailFolder:error];
        }
        if (!error) {
            if ([self.loadFolderDelegate respondsToSelector:@selector(callLoginFinishedSuccessOnLoginController)]) {
                [self.loadFolderDelegate callLoginFinishedSuccessOnLoginController];
            }
        }
    }];
}

- (void)deleteMailFolder:(NSString *)foldername
{
    MCOIMAPOperation * op = [imapSession deleteFolderOperation:foldername];
    [op start:^(NSError * error) {
        if ([self.editFolderDelegate respondsToSelector:@selector(callDeleteMailFolder:)])
        {
            [self.editFolderDelegate callDeleteMailFolder:error];
        }
        if (!error) {
            if ([self.loadFolderDelegate respondsToSelector:@selector(callLoginFinishedSuccessOnLoginController)]) {
                [self.loadFolderDelegate callLoginFinishedSuccessOnLoginController];
            }
        }
    }];
}

- (void)renameMailFolder:(ZXHMail_FolderObject *)folder newName:(NSString *)newname;
{
    
    //编码 uft7-imap
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF7_IMAP);
    NSData *responseData =[newname dataUsingEncoding:encode ];
    NSString *encodeName = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //转移本地文件夹中的邮件到新的文件夹中
    ZXHMail_FolderObject *newfolder =[[ZXHMail_FolderObject alloc] init];
    NSString *remoteid = folder.zxh_mail_folder_remoteid;
    NSString *separtor = [NSString stringWithFormat:@"%@",folder.zxh_mail_folder_svrKey];
    NSMutableArray *remoteArray = [NSMutableArray arrayWithArray:[remoteid componentsSeparatedByString:separtor]];
    if (remoteArray.count>=2)
    {
        [remoteArray removeLastObject];
        [remoteArray addObject:encodeName];
        NSString *newPath = [remoteArray componentsJoinedByString:separtor];
        newfolder.zxh_mail_folder_remoteid = newPath;
        newfolder.zxh_mail_folder_name = newPath;
        newfolder.zxh_mail_folder_showName = newname;
        newfolder.zxh_mail_folder_sequence_idr = encodeName;
    }else
    {
        newfolder.zxh_mail_folder_remoteid = encodeName;
        newfolder.zxh_mail_folder_name = encodeName;
        newfolder.zxh_mail_folder_showName = newname;
        newfolder.zxh_mail_folder_sequence_idr = encodeName;
        
    }
    MCOIMAPOperation * op = [imapSession renameFolderOperation:folder.zxh_mail_folder_remoteid otherName:newfolder.zxh_mail_folder_remoteid];

    [op start:^(NSError * error) {
        if (!error) {

            [ZXHMail_FolderObject renameFolder:folder newFolder:newfolder dbPath:[[NSUserDefaults standardUserDefaults]
                                                                               objectForKey:REM_USER_DB_PATH ]];
        
            //递归子文件夹
            [self recursionFolder:folder.zxh_mail_folder_remoteid
                        newparent:newfolder.zxh_mail_folder_remoteid
                          account:folder.zxh_mail_folder_accountid];
            
            if ([self.loadFolderDelegate respondsToSelector:@selector(callLoginFinishedSuccessOnLoginController)]) {
                [self.loadFolderDelegate callLoginFinishedSuccessOnLoginController];
            }
        }
        if ([self.editFolderDelegate respondsToSelector:@selector(callRenameMailFolder:)])
        {
            [self.editFolderDelegate callRenameMailFolder:error];
        }
    }];
}

- (void)recursionFolder:(NSString *)parent newparent:(NSString *)newparent account:(NSInteger)account
{
    NSMutableArray *subfolders = [ZXHMail_FolderObject fetchFolderFromLocal:[[NSUserDefaults standardUserDefaults]objectForKey:REM_USER_DB_PATH]
                                                                     parent:parent
                                                                  accountid:account];
    
    for (ZXHMail_FolderObject *obj in subfolders)
    {
        //update folder
        NSString *old_remoteid = obj.zxh_mail_folder_remoteid;
        NSString *folder_remoteid;
        folder_remoteid = [newparent stringByAppendingString:obj.zxh_mail_folder_svrKey];
        folder_remoteid = [folder_remoteid stringByAppendingString:obj.zxh_mail_folder_sequence_idr];
        obj.zxh_mail_folder_remoteid = folder_remoteid;
        obj.zxh_mail_folder_name = folder_remoteid;
        obj.zxh_mail_folder_parentName = newparent;
        
       BOOL res = [ZXHMail_FolderObject updateFolderByID:obj
                                        dbPath:[[NSUserDefaults standardUserDefaults] objectForKey:REM_USER_DB_PATH]];
        
        if (res) {
            //递归
            [self recursionFolder:old_remoteid newparent:folder_remoteid account:account];
        }else
        {
            NSLog(@"change folder data fail,it will be deleted by next fetch");
        }
    }

}

@end
