//
//  MailCoreManager.h
//  MailTest
//
//  Created by 朱星海 on 14-5-22.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
#import "ZXHMail_ContainObjectContoller.h"

@protocol MailCoreManagerDelegate <NSObject>

@optional
- (void)callLoginFinishedFailOnLoginController:(NSError *)error;
- (void)callLoginFinishedSuccessOnLoginController;
- (void)callUItoReloadFolder;
- (void)callFetchFolderFromSevFinished;
- (void)callFetchMessageFinished;
- (void)callDeleteNonExistedFolder;
- (void)callDeleteNonExistedMail;
- (void)callCreateMailFolder:(NSError *)error;
- (void)callDeleteMailFolder:(NSError *)error;
- (void)callEditMailFolder:(NSError *)error;
- (void)callRenameMailFolder:(NSError *)error;
@end


@interface MailCoreManager : NSObject
{
    MCOIMAPOperation *imapCheckOp;
    MCOIMAPSession *imapSession;
    MCOIMAPFetchMessagesOperation *imapMessagesFetchOp;
    MCOIMAPFetchFoldersOperation *imapFolderFecthOp;
    MCOIMAPFolderStatusOperation *imapStatusFetchOp;
}
@property (weak) id<MailCoreManagerDelegate>delegate;
@property (weak) id<MailCoreManagerDelegate>loadFolderDelegate;
@property (weak) id<MailCoreManagerDelegate>loadMailContentDelegate;
@property (weak) id<MailCoreManagerDelegate>createFolderDelegate;
@property (weak) id<MailCoreManagerDelegate>editFolderDelegate;
+(MailCoreManager *)shareInstance;

//停止操作
- (MCOIMAPSession *)session;
- (void)cancelFetchOperation;
- (void)stopTimer;
- (void)startTimer;

- (void)loginToDomainWithTLS:(NSString *)hostName hostPort:(NSInteger)hostPort username:(NSString *)username password:(NSString *)password;

- (void)fetchMailFolderList;
- (void)runLoopList;
- (void)saveFolderListToLocalDB:(NSArray *)folders accountid:(NSUInteger)accountid;
- (void)fetchFolderDetailInfoToLocalDB:(ZXHMail_FolderObject *)folder;

- (void)saveMailListToLocalDB:(NSArray *)fetched accountid:(NSInteger)accountid folderid:(NSInteger)folderid path:(NSString *)folderPath;


- (void)fetchMailMessageFromServer:(NSUInteger)nMessages accountid:(NSUInteger)account totalMessages:(NSUInteger)tMessages currentMessage:(NSMutableArray *)cArray path:(NSString *)folderPath folderid:(NSInteger)folderid;

- (void)fetchNewMailByUID:(ZXHMail_FolderObject *)folder oldObj:(ZXHMail_FolderObject *)obj;
//检查邮箱文件夹是否存在
- (void)checkMailFolderIsNotExisted:(ZXHMail_FolderObject *)folder;

//检查邮件是否存在
- (void)checkMailMessageIsNotExisted:(ZXHMail_MailInfoObject *)mailMessage;

//文件夹操作
//新建文件夹

- (void)createNewMailFolder:(NSString *)foldername;

- (void)deleteMailFolder:(NSString *)foldername;

- (void)renameMailFolder:(ZXHMail_FolderObject *)folder newName:(NSString *)newname;

//递归子文件夹
- (void)recursionFolder:(NSString *)parent newparent:(NSString *)newparent account:(NSInteger)account;

@end
