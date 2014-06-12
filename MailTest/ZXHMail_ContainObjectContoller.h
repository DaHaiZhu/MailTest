//
//  ZXHMail_ContainObjectContoller.h
//  MailTest
//
//  Created by 朱星海 on 14-5-21.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface ZXHMail_MailContentObject : NSObject
{
    NSInteger  zxh_mail_mailContent_mailId;
    NSString   *zxh_mail_mailContent_content;
    NSString   *zxh_mail_mailContent_sps;
    NSString   *zxh_mail_mailContent_attachs;
    NSString   *zxh_mail_mailContent_original;
    NSString   *zxh_mail_mailContent_originalText;
    NSString   *zxh_mail_mailContent_scale;
    NSString   *zxh_mail_mailContent_length;
    NSData     *zxh_mail_mailContent_fold;
    NSData     *zxh_mail_mailContent_foldText;
    NSString   *zxh_mail_mailContent_contentText;
    NSInteger  zxh_mail_mailContent_isComplete;
    NSInteger  zxh_mail_mailContent_contentType;
    NSString   *zxh_mail_mailContent_charset;
    NSInteger  *zxh_mail_mailContent_isLoadImage;
    NSData     *zxh_mail_mailContent_extraData;
    NSInteger  *zxh_mail_mailContent_hasImage;
    NSInteger  zxh_mail_mailContent_isHtml;
}
@property(nonatomic,assign)NSInteger  zxh_mail_mailContent_mailId;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_content;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_sps;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_attachs;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_original;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_originalText;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_scale;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_length;
@property(nonatomic,strong)NSData     *zxh_mail_mailContent_fold;
@property(nonatomic,strong)NSData     *zxh_mail_mailContent_foldText;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_contentText;
@property(nonatomic,assign)NSInteger  zxh_mail_mailContent_isComplete;
@property(nonatomic,assign)NSInteger  zxh_mail_mailContent_contentType;
@property(nonatomic,strong)NSString   *zxh_mail_mailContent_charset;
@property(nonatomic,assign)NSInteger  *zxh_mail_mailContent_isLoadImage;
@property(nonatomic,strong)NSData     *zxh_mail_mailContent_extraData;
@property(nonatomic,assign)NSInteger  *zxh_mail_mailContent_hasImage;
@property(nonatomic,assign)NSInteger  zxh_mail_mailContent_isHtml;





@end

@interface ZXHMail_MailAttachObject : NSObject
{
    NSInteger  zxh_mail_mailAttach_attachId;
    NSInteger  zxh_mail_mailAttach_mailId;
    NSString   *zxh_mail_mailAttach_name;
    NSString   *zxh_mail_mailAttach_type;
    NSString   *zxh_mail_mailAttach_downloadUtc;
    NSInteger  zxh_mail_mailAttach_downloadState;
    NSString   *zxh_mail_mailAttach_downloadSize;
    NSString   *zxh_mail_mailAttach_contentId;
    NSString   *zxh_mail_mailAttach_exchangeField;
    NSString   *zxh_mail_mailAttach_size;
    NSData     *zxh_mail_mailAttach_object;
    NSString   *zxh_mail_mailAttach_url;
}

@property(nonatomic,assign)NSInteger   zxh_mail_mailAttach_attachId;
@property(nonatomic,assign)NSInteger   zxh_mail_mailAttach_mailId;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_name;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_type;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_downloadUtc;
@property(nonatomic,assign)NSInteger   zxh_mail_mailAttach_downloadState;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_downloadSize;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_contentId;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_exchangeField;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_size;
@property(nonatomic,strong)NSData      *zxh_mail_mailAttach_object;
@property(nonatomic,strong)NSString    *zxh_mail_mailAttach_url;

@end


@interface ZXHMail_MailInfoObject : NSObject
{
    NSInteger   zxh_mail_mailinfo_mailid;
    NSInteger   zxh_mail_mailinfo_folderid;
    NSString    *zxh_mail_mailinfo_remoteid;
    NSString    *zxh_mail_mailinfo_subject;
    NSString    *zxh_mail_mailinfo_abstract;
    NSString    *zxh_mail_mailinfo_fromemail;
    NSString    *zxh_mail_mailinfo_tos;
    NSString    *zxh_mail_mailinfo_ccs;
    NSString    *zxh_mail_mailinfo_bcc;
    NSString    *zxh_mail_mailinfo_replyto;
    NSInteger   zxh_mail_mailinfo_hasAttach;
    double      zxh_mail_mailinfo_receiveUtc;
    double      zxh_mail_mailinfo_sendUtc;
    NSInteger   zxh_mail_mailinfo_isRead;
    NSInteger   zxh_mail_mailinfo_isStar;
    NSInteger   zxh_mail_mailinfo_isReplay;
    NSInteger   zxh_mail_mailinfo_isForward;
    NSInteger   zxh_mail_mailinfo_mailAdType;
    NSInteger   zxh_mail_mailinfo_isVip;
    NSInteger   zxh_mail_mailinfo_convId;
    NSInteger   zxh_mail_mailinfo_mailType;
    NSString    *zxh_mail_mailinfo_messageId;
    NSString    *zxh_mail_mailinfo_labels;
    NSString    *zxh_mail_mailinfo_ref;
    NSInteger   zxh_mail_mailinfo_deleted;
    NSInteger   zxh_mail_mailinfo_accountid;
    NSInteger   zxh_mail_mailinfo_convCount;
    NSString    *zxh_mail_mailinfo_changeKey;
    NSString    *zxh_mail_mailinfo_gid;
    NSInteger   zxh_mail_mailinfo_isGroup;
    NSString    *zxh_mail_mailinfo_folderName;
    NSString    *zxh_mail_mailinfo_size;
    NSString    *zxh_mail_mailinfo_colid;
    NSString    *zxh_mail_mailinfo_fremoteId;
    NSString    *zxh_mail_mailinfo_fromNick;
    NSInteger   zxh_mail_mailinfo_cheatCode;
    NSString    *zxh_mail_mailinfo_ip;
    NSInteger   zxh_mail_mailinfo_convType;
    NSInteger   zxh_mail_mailinfo_attach_count;
}
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_mailid;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_folderid;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_remoteid;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_subject;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_abstract;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_fromemail;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_tos;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_ccs;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_bcc;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_replyto;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_hasAttach;
@property(nonatomic,assign)double      zxh_mail_mailinfo_receiveUtc;
@property(nonatomic,assign)double      zxh_mail_mailinfo_sendUtc;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_isRead;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_isStar;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_isReplay;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_isForward;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_mailAdType;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_isVip;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_convId;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_mailType;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_messageId;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_labels;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_ref;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_deleted;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_accountid;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_convCount;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_changeKey;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_gid;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_isGroup;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_folderName;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_size;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_colid;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_fremoteId;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_fromNick;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_cheatCode;
@property(nonatomic,strong)NSString    *zxh_mail_mailinfo_ip;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_convType;
@property(nonatomic,assign)NSInteger   zxh_mail_mailinfo_attach_count;

+(BOOL)checkTableMail_InfoTableCreatedInDb:(FMDatabase *)db;
+(BOOL)saveNewMailInfo:(ZXHMail_MailInfoObject *)mail  dbPath:(NSString *)dbPath;
+(BOOL)deleteMailById:(NSInteger)mailid  dbPath:(NSString *)dbPath;
+(BOOL)deleteMailByFolderId:(NSInteger)folderid  dbPath:(NSString *)dbPath;
+(BOOL)updateMailInfo:(ZXHMail_MailInfoObject*)mail  dbPath:(NSString *)dbPath;
+(BOOL)updateMailAbstract:(ZXHMail_MailInfoObject*)mail  dbPath:(NSString *)dbPath;
+(BOOL)updateMailUnSeenFlag:(ZXHMail_MailInfoObject *)mail dbPath:(NSString *)dbPath;
+(BOOL)haveSaveMailById:(ZXHMail_MailInfoObject*)mail dbPath:(NSString *)dbPath;
+(NSMutableArray*)fetchAllMailFromLocal:(NSString *)dbPath folderId:(NSInteger)foldID accountid:(NSInteger)accountid numberToLoad:(NSInteger)number;
+(ZXHMail_MailInfoObject*)fetchMailFromLocalByID:(ZXHMail_MailInfoObject *)mail dbPath:(NSString *)dbPath;

@end

@interface ZXHMail_Local_ItemObject : NSObject
{
    NSInteger  zxh_mail_local_item_id;
    NSData     *zxh_mail_local_item_data;
    NSInteger  zxh_mail_local_item_accountid;
    NSString   *zxh_mail_local_item_type;
    NSString   *zxh_mail_local_item_state;
    NSString   *zxh_mail_local_item_createtime;
    NSString   *zxh_mail_local_item_updatetime;
}
@property(nonatomic,assign)NSInteger zxh_mail_local_item_id;
@property(nonatomic,assign)NSInteger zxh_mail_local_item_accountid;
@property(nonatomic,strong)NSData   *zxh_mail_local_item_data;
@property(nonatomic,strong)NSString *zxh_mail_local_item_type;
@property(nonatomic,strong)NSString *zxh_mail_local_item_state;
@property(nonatomic,strong)NSString *zxh_mail_local_item_createtime;
@property(nonatomic,strong)NSString *zxh_mail_local_item_updatetime;

@end


@interface ZXHMail_FolderObject : NSObject
{
    NSInteger  zxh_mail_folder_id;
    NSInteger  zxh_mail_folder_accountid;
    NSString  *zxh_mail_folder_remoteid;
    NSString  *zxh_mail_folder_name;
    NSString  *zxh_mail_folder_totalCnt;
    NSString  *zxh_mail_folder_unReadCnt;
    NSString  *zxh_mail_folder_isTop;
    NSString  *zxh_mail_folder_isVirtual;
    NSString  *zxh_mail_folder_parentid;
    NSInteger zxh_mail_folder_folderType;
    NSString  *zxh_mail_folder_sequence_idr;
    NSString  *zxh_mail_folder_showName;
    NSString  *zxh_mail_folder_parentName;
    NSString  *zxh_mail_folder_syncStatus;
    NSString  *zxh_mail_folder_svrKey;
    NSString  *zxh_mail_folder_syncUtc;
    NSString  *zxh_mail_folder_outDate;
    NSString  *zxh_mail_folder_hasNewMail;
    NSString  *zxh_mail_folder_remoteFolderType;
    NSString  *zxh_mail_folder_rType;
    NSString  *zxh_mail_folder_uidIder;
    NSString  *zxh_mail_folder_accountemail;
    NSString  *zxh_mail_folder_acctid;
    NSString  *zxh_mail_folder_editType;
    NSInteger zxh_mail_folder_uidNext;
}

@property(nonatomic,assign)NSInteger zxh_mail_folder_id;
@property(nonatomic,assign)NSInteger zxh_mail_folder_accountid;
@property(nonatomic,strong)NSString *zxh_mail_folder_remoteid;
@property(nonatomic,strong)NSString *zxh_mail_folder_name;
@property(nonatomic,strong)NSString *zxh_mail_folder_totalCnt;
@property(nonatomic,strong)NSString *zxh_mail_folder_unReadCnt;
@property(nonatomic,strong)NSString *zxh_mail_folder_isTop;
@property(nonatomic,strong)NSString *zxh_mail_folder_isVirtual;
@property(nonatomic,strong)NSString *zxh_mail_folder_parentid;
@property(nonatomic,assign)NSInteger zxh_mail_folder_folderType;
@property(nonatomic,strong)NSString *zxh_mail_folder_sequence_idr;
@property(nonatomic,strong)NSString *zxh_mail_folder_showName;
@property(nonatomic,strong)NSString *zxh_mail_folder_parentName;
@property(nonatomic,strong)NSString *zxh_mail_folder_syncStatus;
@property(nonatomic,strong)NSString *zxh_mail_folder_svrKey;
@property(nonatomic,strong)NSString *zxh_mail_folder_syncUtc;
@property(nonatomic,strong)NSString *zxh_mail_folder_outDate;
@property(nonatomic,strong)NSString *zxh_mail_folder_hasNewMail;
@property(nonatomic,strong)NSString *zxh_mail_folder_remoteFolderType;
@property(nonatomic,strong)NSString *zxh_mail_folder_rType;
@property(nonatomic,strong)NSString *zxh_mail_folder_uidIder;
@property(nonatomic,strong)NSString *zxh_mail_folder_accountemail;
@property(nonatomic,strong)NSString *zxh_mail_folder_acctid;
@property(nonatomic,strong)NSString *zxh_mail_folder_editType;
@property(nonatomic,assign)NSInteger zxh_mail_folder_uidNext;

+(BOOL)checkTableMail_FolderTableCreatedInDb:(FMDatabase *)db;
+(BOOL)saveNewFolder:(ZXHMail_FolderObject *)folder  dbPath:(NSString *)dbPath;
+(BOOL)deleteFolderById:(NSInteger)folderid  dbPath:(NSString *)dbPath;
+(BOOL)updateFolder:(ZXHMail_FolderObject*)folder  dbPath:(NSString *)dbPath;
+(BOOL)haveSaveFolderById:(ZXHMail_FolderObject*)folder dbPath:(NSString *)dbPath;
+(NSMutableArray*)fetchAllFolderFromLocal:(NSString *)dbPath accountid:(NSInteger)accountid;
+(ZXHMail_FolderObject *)fetchFolderUidNextFromLocal:(ZXHMail_FolderObject*)folder dbPath:(NSString *)dbPath;
+(BOOL)renameFolder:(ZXHMail_FolderObject*)folder newFolder:(ZXHMail_FolderObject*)newfolder  dbPath:(NSString *)dbPath;
+(NSMutableArray*)fetchFolderFromLocal:(NSString *)dbPath parent:(NSString *)parent accountid:(NSInteger)accountid;
+(BOOL)updateFolderByID:(ZXHMail_FolderObject*)folder  dbPath:(NSString *)dbPath;
@end

@interface ZXHMail_AccountSettingObject : NSObject
{
    NSInteger zxh_mail_account_setting_id;
    NSString  *zxh_mail_account_setting_name;
    NSData    *zxh_mail_account_setting_image;
    NSData    *zxh_mail_account_setting_sign;
    NSData    *zxh_mail_account_setting_pushFolderlist;
    NSString  *zxh_mail_account_setting_accountNewMailTip;
    NSString  *zxh_mail_account_setting_revieveFolderTip;
    NSString  *zxh_mail_account_setting_showConversasion;
    NSString  *zxh_mail_account_setting_enableAccountNewMailTip;
    NSData    *zxh_mail_account_setting_accountWebDiscKey;
    NSString  *zxh_mail_account_setting_folderAccessNeedPassword;
    NSString  *zxh_mail_account_setting_userInputAccessFolderPassword;
    NSData    *zxh_mail_account_setting_userHandleFolderToAccount;
    NSString  *zxh_mail_account_setting_descubcnt;
}
@property (nonatomic, assign) NSInteger zxh_mail_account_setting_id;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_name;
@property (nonatomic, strong) NSData   *zxh_mail_account_setting_image;
@property (nonatomic, strong) NSData   *zxh_mail_account_setting_sign;
@property (nonatomic, strong) NSData   *zxh_mail_account_setting_pushFolderlist;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_accountNewMailTip;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_revieveFolderTip;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_showConversasion;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_enableAccountNewMailTip;
@property (nonatomic, strong) NSData   *zxh_mail_account_setting_accountWebDiscKey;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_folderAccessNeedPassword;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_userInputAccessFolderPassword;
@property (nonatomic, strong) NSData   *zxh_mail_account_setting_userHandleFolderToAccount;
@property (nonatomic, strong) NSString *zxh_mail_account_setting_descubcnt;

+(BOOL)checkTableAccountSettingTableCreatedInDb:(FMDatabase *)db;
+(BOOL)saveNewAccount:(ZXHMail_AccountSettingObject *)account  dbPath:(NSString *)dbPath;
+(BOOL)deleteAccountById:(NSInteger)accountId  dbPath:(NSString *)dbPath;
+(BOOL)updateAccount:(ZXHMail_AccountSettingObject*)account  dbPath:(NSString *)dbPath;
+(BOOL)haveSaveAccountById:(NSInteger)accountId dbPath:(NSString *)dbPath;
+(NSMutableArray*)fetchAllAccountFromLocal:(NSString *)dbPath;
+(ZXHMail_AccountSettingObject*)fetchAccountFromLocalByID:(NSInteger)account dbPath:(NSString *)dbPath;
//将对象转换为字典
-(NSDictionary*)toDictionary;
+(ZXHMail_AccountSettingObject*)accountFromDictionary:(NSDictionary*)aDic;
@end



@interface ZXHMail_ContainObjectContoller : NSObject
{
    NSInteger zxh_mail_account_id;   //auto increment
    NSString  *zxh_mail_account_name;
    NSString  *zxh_mail_account_alias;
    NSData    *zxh_mail_account_profile;
    NSString  *zxh_mail_account_type;
    NSString  *zxh_mail_account_isChief;
    NSString  *zxh_mail_account_isCloudPush;
    NSString  *zxh_mail_account_state;
    NSString  *zxh_mail_account_syncUtc;
    NSString  *zxh_mail_account_synckey;
    NSString  *zxh_mail_account_intervalPullTime;
}

@property (nonatomic, assign) NSInteger zxh_mail_account_id;
@property (nonatomic, strong) NSString *zxh_mail_account_name;
@property (nonatomic, strong) NSString *zxh_mail_account_alias;
@property (nonatomic, strong) NSData   *zxh_mail_account_profile;
@property (nonatomic, strong) NSString *zxh_mail_account_type;
@property (nonatomic, strong) NSString *zxh_mail_account_isChief;
@property (nonatomic, strong) NSString *zxh_mail_account_isCloudPush;
@property (nonatomic, strong) NSString *zxh_mail_account_state;
@property (nonatomic, strong) NSString *zxh_mail_account_syncUtc;
@property (nonatomic, strong) NSString *zxh_mail_account_synckey;
@property (nonatomic, strong) NSString *zxh_mail_account_intervalPullTime;

//数据库增删改查
+(BOOL)checkTableAccountTableCreatedInDb:(FMDatabase *)db;
+(BOOL)saveNewAccount:(ZXHMail_ContainObjectContoller *)account  dbPath:(NSString *)dbPath;
+(BOOL)deleteAccountById:(NSInteger)accountId  dbPath:(NSString *)dbPath;
+(BOOL)updateAccount:(ZXHMail_ContainObjectContoller*)account  dbPath:(NSString *)dbPath;
+(BOOL)haveSaveAccountByName:(NSString *)accountName dbPath:(NSString *)dbPath;
+(NSMutableArray*)fetchAllAccountFromLocal:(NSString *)dbPath;
+(ZXHMail_ContainObjectContoller*)fetchAccountFromLocalByID:(NSInteger)account dbPath:(NSString *)dbPath;
+(ZXHMail_ContainObjectContoller*)fetchAccountFromLocalByName:(NSString *)account dbPath:(NSString *)dbPath;
//将对象转换为字典
-(NSDictionary*)toDictionary;
+(ZXHMail_ContainObjectContoller*)accountFromDictionary:(NSDictionary*)aDic;

@end
