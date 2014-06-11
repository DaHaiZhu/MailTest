//
//  ZXHMail_ContainObjectContoller.m
//  MailTest
//
//  Created by 朱星海 on 14-5-21.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import "ZXHMail_ContainObjectContoller.h"
#import "FMDatabase.h"
#import "FMResultSet.h"


#pragma mark - ZXHMail_MailContentObject
@implementation ZXHMail_MailContentObject
@synthesize  zxh_mail_mailContent_mailId;
@synthesize  zxh_mail_mailContent_content;
@synthesize  zxh_mail_mailContent_sps;
@synthesize  zxh_mail_mailContent_attachs;
@synthesize  zxh_mail_mailContent_original;
@synthesize  zxh_mail_mailContent_originalText;
@synthesize  zxh_mail_mailContent_scale;
@synthesize  zxh_mail_mailContent_length;
@synthesize  zxh_mail_mailContent_fold;
@synthesize  zxh_mail_mailContent_foldText;
@synthesize  zxh_mail_mailContent_contentText;
@synthesize  zxh_mail_mailContent_isComplete;
@synthesize  zxh_mail_mailContent_contentType;
@synthesize  zxh_mail_mailContent_charset;
@synthesize  zxh_mail_mailContent_isLoadImage;
@synthesize  zxh_mail_mailContent_extraData;
@synthesize  zxh_mail_mailContent_hasImage;
@synthesize  zxh_mail_mailContent_isHtml;


@end

#pragma mark - ZXHMail_MailAttachObject
@implementation ZXHMail_MailAttachObject
@synthesize   zxh_mail_mailAttach_attachId;
@synthesize   zxh_mail_mailAttach_mailId;
@synthesize   zxh_mail_mailAttach_name;
@synthesize   zxh_mail_mailAttach_type;
@synthesize   zxh_mail_mailAttach_downloadUtc;
@synthesize   zxh_mail_mailAttach_downloadState;
@synthesize   zxh_mail_mailAttach_downloadSize;
@synthesize   zxh_mail_mailAttach_contentId;
@synthesize   zxh_mail_mailAttach_exchangeField;
@synthesize   zxh_mail_mailAttach_size;
@synthesize   zxh_mail_mailAttach_object;
@synthesize   zxh_mail_mailAttach_url;



@end

#pragma mark - ZXHMail_MailInfoObject
@implementation ZXHMail_MailInfoObject
@synthesize   zxh_mail_mailinfo_mailid;
@synthesize   zxh_mail_mailinfo_folderid;
@synthesize   zxh_mail_mailinfo_remoteid;
@synthesize   zxh_mail_mailinfo_subject;
@synthesize   zxh_mail_mailinfo_abstract;
@synthesize   zxh_mail_mailinfo_fromemail;
@synthesize   zxh_mail_mailinfo_tos;
@synthesize   zxh_mail_mailinfo_ccs;
@synthesize   zxh_mail_mailinfo_bcc;
@synthesize   zxh_mail_mailinfo_replyto;
@synthesize   zxh_mail_mailinfo_hasAttach;
@synthesize   zxh_mail_mailinfo_receiveUtc;
@synthesize   zxh_mail_mailinfo_sendUtc;
@synthesize   zxh_mail_mailinfo_isRead;
@synthesize   zxh_mail_mailinfo_isStar;
@synthesize   zxh_mail_mailinfo_isReplay;
@synthesize   zxh_mail_mailinfo_isForward;
@synthesize   zxh_mail_mailinfo_mailAdType;
@synthesize   zxh_mail_mailinfo_isVip;
@synthesize   zxh_mail_mailinfo_convId;
@synthesize   zxh_mail_mailinfo_mailType;
@synthesize   zxh_mail_mailinfo_messageId;
@synthesize   zxh_mail_mailinfo_labels;
@synthesize   zxh_mail_mailinfo_ref;
@synthesize   zxh_mail_mailinfo_deleted;
@synthesize   zxh_mail_mailinfo_accountid;
@synthesize   zxh_mail_mailinfo_convCount;
@synthesize   zxh_mail_mailinfo_changeKey;
@synthesize   zxh_mail_mailinfo_gid;
@synthesize   zxh_mail_mailinfo_isGroup;
@synthesize   zxh_mail_mailinfo_folderName;
@synthesize   zxh_mail_mailinfo_size;
@synthesize   zxh_mail_mailinfo_colid;
@synthesize   zxh_mail_mailinfo_fremoteId;
@synthesize   zxh_mail_mailinfo_fromNick;
@synthesize   zxh_mail_mailinfo_cheatCode;
@synthesize   zxh_mail_mailinfo_ip;
@synthesize   zxh_mail_mailinfo_convType;
@synthesize   zxh_mail_mailinfo_attach_count;

+(BOOL)checkTableMail_InfoTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' INTEGER ,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' INTEGER,'%@' DOUBLE,'%@' DOUBLE,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' INTEGER,'%@' INTEGER,'%@' INTEGER,'%@' TEXT,'%@' TEXT,'%@' INTEGER,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' INTEGER,'%@' TEXT,'%@' INTEGER,'%@' INTEGER)"
                           ,zxh_mail_mailinfo_table
                           ,zxh_mail_mailinfo_mailid_def
                           ,zxh_mail_mailinfo_folderid_def
                           ,zxh_mail_mailinfo_remoteid_def
                           ,zxh_mail_mailinfo_subject_def
                           ,zxh_mail_mailinfo_abstract_def
                           ,zxh_mail_mailinfo_fromemail_def
                           ,zxh_mail_mailinfo_tos_def
                           ,zxh_mail_mailinfo_ccs_def
                           ,zxh_mail_mailinfo_bcc_def
                           ,zxh_mail_mailinfo_replyto_def
                           ,zxh_mail_mailinfo_hasAttach_def
                           ,zxh_mail_mailinfo_receiveUtc_def
                           ,zxh_mail_mailinfo_sendUtc_def
                           ,zxh_mail_mailinfo_isRead_def
                           ,zxh_mail_mailinfo_isStar_def
                           ,zxh_mail_mailinfo_isReplay_def
                           ,zxh_mail_mailinfo_isForward_def
                           ,zxh_mail_mailinfo_mailAdType_def
                           ,zxh_mail_mailinfo_isVip_def
                           ,zxh_mail_mailinfo_convId_def
                           ,zxh_mail_mailinfo_mailType_def
                           ,zxh_mail_mailinfo_messageId_def
                           ,zxh_mail_mailinfo_labels_def
                           ,zxh_mail_mailinfo_ref_def
                           ,zxh_mail_mailinfo_deleted_def
                           ,zxh_mail_mailinfo_accountid_def
                           ,zxh_mail_mailinfo_convCount_def
                           ,zxh_mail_mailinfo_changeKey_def
                           ,zxh_mail_mailinfo_gid_def
                           ,zxh_mail_mailinfo_isGroup_def
                           ,zxh_mail_mailinfo_folderName_def
                           ,zxh_mail_mailinfo_size_def
                           ,zxh_mail_mailinfo_colid_def
                           ,zxh_mail_mailinfo_fremoteId_def
                           ,zxh_mail_mailinfo_fromNick_def
                           ,zxh_mail_mailinfo_cheatCode_def
                           ,zxh_mail_mailinfo_ip_def
                           ,zxh_mail_mailinfo_convType_def
                           ,zxh_mail_mailinfo_attach_count_def];
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}
+(BOOL)saveNewMailInfo:(ZXHMail_MailInfoObject *)mail  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    
    NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                           ,zxh_mail_mailinfo_table
                           ,zxh_mail_mailinfo_mailid_def
                           ,zxh_mail_mailinfo_folderid_def
                           ,zxh_mail_mailinfo_remoteid_def
                           ,zxh_mail_mailinfo_subject_def
                           ,zxh_mail_mailinfo_abstract_def
                           ,zxh_mail_mailinfo_fromemail_def
                           ,zxh_mail_mailinfo_tos_def
                           ,zxh_mail_mailinfo_ccs_def
                           ,zxh_mail_mailinfo_bcc_def
                           ,zxh_mail_mailinfo_replyto_def
                           ,zxh_mail_mailinfo_hasAttach_def
                           ,zxh_mail_mailinfo_receiveUtc_def
                           ,zxh_mail_mailinfo_sendUtc_def
                           ,zxh_mail_mailinfo_isRead_def
                           ,zxh_mail_mailinfo_isStar_def
                           ,zxh_mail_mailinfo_isReplay_def
                           ,zxh_mail_mailinfo_isForward_def
                           ,zxh_mail_mailinfo_mailAdType_def
                           ,zxh_mail_mailinfo_isVip_def
                           ,zxh_mail_mailinfo_convId_def
                           ,zxh_mail_mailinfo_mailType_def
                           ,zxh_mail_mailinfo_messageId_def
                           ,zxh_mail_mailinfo_labels_def
                           ,zxh_mail_mailinfo_ref_def
                           ,zxh_mail_mailinfo_deleted_def
                           ,zxh_mail_mailinfo_accountid_def
                           ,zxh_mail_mailinfo_convCount_def
                           ,zxh_mail_mailinfo_changeKey_def
                           ,zxh_mail_mailinfo_gid_def
                           ,zxh_mail_mailinfo_isGroup_def
                           ,zxh_mail_mailinfo_folderName_def
                           ,zxh_mail_mailinfo_size_def
                           ,zxh_mail_mailinfo_colid_def
                           ,zxh_mail_mailinfo_fremoteId_def
                           ,zxh_mail_mailinfo_fromNick_def
                           ,zxh_mail_mailinfo_cheatCode_def
                           ,zxh_mail_mailinfo_ip_def
                           ,zxh_mail_mailinfo_convType_def
                           ,zxh_mail_mailinfo_attach_count_def];
    
    BOOL worked = [db executeUpdate:insertStr
                   ,nil
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_folderid]
                   ,mail.zxh_mail_mailinfo_remoteid
                   ,mail.zxh_mail_mailinfo_subject
                   ,mail.zxh_mail_mailinfo_abstract
                   ,mail.zxh_mail_mailinfo_fromemail
                   ,mail.zxh_mail_mailinfo_tos
                   ,mail.zxh_mail_mailinfo_ccs
                   ,mail.zxh_mail_mailinfo_bcc
                   ,mail.zxh_mail_mailinfo_replyto
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_hasAttach]
                   ,[NSNumber numberWithDouble:mail.zxh_mail_mailinfo_receiveUtc]
                   ,[NSNumber numberWithDouble:mail.zxh_mail_mailinfo_sendUtc]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isRead]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isStar]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isReplay]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isForward]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailAdType]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isVip]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_convId]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailType]
                   ,mail.zxh_mail_mailinfo_messageId
                   ,mail.zxh_mail_mailinfo_labels
                   ,mail.zxh_mail_mailinfo_ref
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_deleted]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_accountid]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_convCount]
                   ,mail.zxh_mail_mailinfo_changeKey
                   ,mail.zxh_mail_mailinfo_gid
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isGroup]
                   ,mail.zxh_mail_mailinfo_folderName
                   ,mail.zxh_mail_mailinfo_size
                   ,mail.zxh_mail_mailinfo_colid
                   ,mail.zxh_mail_mailinfo_fremoteId
                   ,mail.zxh_mail_mailinfo_fromNick
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_cheatCode]
                   ,mail.zxh_mail_mailinfo_ip
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_convType]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_attach_count]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}
+(BOOL)deleteMailById:(NSInteger)mailid  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where %@=?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_mailid_def];
    BOOL worked=[db executeUpdate:deleteStr,[NSNumber numberWithInteger:mailid]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

+(BOOL)deleteMailByFolderId:(NSInteger)folderid  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
        [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where %@=?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_folderid_def];
    BOOL worked=[db executeUpdate:deleteStr,[NSNumber numberWithInteger:folderid]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

+(BOOL)updateMailUnSeenFlag:(ZXHMail_MailInfoObject *)mail dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    NSString *updateStr = [NSString stringWithFormat:@"UPDATE '%@' SET '%@'=? WHERE %@=?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_isRead_def,zxh_mail_mailinfo_mailid_def];
    
    BOOL worked = [db executeUpdate:updateStr ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isRead],[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailid]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

+(BOOL)updateMailAbstract:(ZXHMail_MailInfoObject*)mail  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
     NSString *updateStr = [NSString stringWithFormat:@"UPDATE '%@' SET '%@'=? WHERE %@=?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_abstract_def,zxh_mail_mailinfo_mailid_def];
    
    BOOL worked = [db executeUpdate:updateStr ,mail.zxh_mail_mailinfo_abstract,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailid]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}
+(BOOL)updateMailInfo:(ZXHMail_MailInfoObject*)mail  dbPath:(NSString *)dbPath;
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    
    NSString *updateStr = [NSString stringWithFormat:@"UPDATE '%@' SET '%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=? ,'%@'=? ,'%@'=? ,'%@'=? WHERE %@=?"
                           ,zxh_mail_mailinfo_table
                           ,zxh_mail_mailinfo_folderid_def
                           ,zxh_mail_mailinfo_remoteid_def
                           ,zxh_mail_mailinfo_subject_def
                           ,zxh_mail_mailinfo_abstract_def
                           ,zxh_mail_mailinfo_fromemail_def
                           ,zxh_mail_mailinfo_tos_def
                           ,zxh_mail_mailinfo_ccs_def
                           ,zxh_mail_mailinfo_bcc_def
                           ,zxh_mail_mailinfo_replyto_def
                           ,zxh_mail_mailinfo_hasAttach_def
                           ,zxh_mail_mailinfo_receiveUtc_def
                           ,zxh_mail_mailinfo_sendUtc_def
                           ,zxh_mail_mailinfo_isRead_def
                           ,zxh_mail_mailinfo_isStar_def
                           ,zxh_mail_mailinfo_isReplay_def
                           ,zxh_mail_mailinfo_isForward_def
                           ,zxh_mail_mailinfo_mailAdType_def
                           ,zxh_mail_mailinfo_isVip_def
                           ,zxh_mail_mailinfo_convId_def
                           ,zxh_mail_mailinfo_mailType_def
                           ,zxh_mail_mailinfo_messageId_def
                           ,zxh_mail_mailinfo_labels_def
                           ,zxh_mail_mailinfo_ref_def
                           ,zxh_mail_mailinfo_deleted_def
                           ,zxh_mail_mailinfo_accountid_def
                           ,zxh_mail_mailinfo_convCount_def
                           ,zxh_mail_mailinfo_changeKey_def
                           ,zxh_mail_mailinfo_gid_def
                           ,zxh_mail_mailinfo_isGroup_def
                           ,zxh_mail_mailinfo_folderName_def
                           ,zxh_mail_mailinfo_size_def
                           ,zxh_mail_mailinfo_colid_def
                           ,zxh_mail_mailinfo_fremoteId_def
                           ,zxh_mail_mailinfo_fromNick_def
                           ,zxh_mail_mailinfo_cheatCode_def
                           ,zxh_mail_mailinfo_ip_def
                           ,zxh_mail_mailinfo_convType_def
                           ,zxh_mail_mailinfo_attach_count_def
                           ,zxh_mail_mailinfo_mailid_def];
    BOOL worked = [db executeUpdate:updateStr
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_folderid]
                   ,mail.zxh_mail_mailinfo_remoteid
                   ,mail.zxh_mail_mailinfo_subject
                   ,mail.zxh_mail_mailinfo_abstract
                   ,mail.zxh_mail_mailinfo_fromemail
                   ,mail.zxh_mail_mailinfo_tos
                   ,mail.zxh_mail_mailinfo_ccs
                   ,mail.zxh_mail_mailinfo_bcc
                   ,mail.zxh_mail_mailinfo_replyto
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_hasAttach]
                   ,[NSNumber numberWithDouble:mail.zxh_mail_mailinfo_receiveUtc]
                   ,[NSNumber numberWithDouble:mail.zxh_mail_mailinfo_sendUtc]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isRead]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isStar]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isReplay]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isForward]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailAdType]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isVip]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_convId]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailType]
                   ,mail.zxh_mail_mailinfo_messageId
                   ,mail.zxh_mail_mailinfo_labels
                   ,mail.zxh_mail_mailinfo_ref
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_deleted]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_accountid]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_convCount]
                   ,mail.zxh_mail_mailinfo_changeKey
                   ,mail.zxh_mail_mailinfo_gid
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_isGroup]
                   ,mail.zxh_mail_mailinfo_folderName
                   ,mail.zxh_mail_mailinfo_size
                   ,mail.zxh_mail_mailinfo_colid
                   ,mail.zxh_mail_mailinfo_fremoteId
                   ,mail.zxh_mail_mailinfo_fromNick
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_cheatCode]
                   ,mail.zxh_mail_mailinfo_ip
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_convType]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_mailid]
                   ,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_attach_count]
                   ];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

+(BOOL)haveSaveMailById:(ZXHMail_MailInfoObject*)mail dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select count(*) from %@ where %@=? and %@=? and %@=?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_accountid_def,zxh_mail_mailinfo_folderid_def,zxh_mail_mailinfo_messageId_def];
    
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_accountid],[NSNumber numberWithInteger:mail.zxh_mail_mailinfo_folderid],mail.zxh_mail_mailinfo_messageId];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
}
+(NSMutableArray*)fetchAllMailFromLocal:(NSString *)dbPath folderId:(NSInteger)foldID accountid:(NSInteger)accountid  numberToLoad:(NSInteger)number
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return resultArr;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select * from %@ where %@=? and %@=? order by %@ desc limit ?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_folderid_def,zxh_mail_mailinfo_accountid_def,zxh_mail_mailinfo_receiveUtc_def];
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:foldID],[NSNumber numberWithInteger:accountid],[NSNumber numberWithInt:number]];
    while ([rs next]) {
        ZXHMail_MailInfoObject *mail = [[ZXHMail_MailInfoObject alloc] init];
        mail.zxh_mail_mailinfo_mailid = [rs intForColumn:zxh_mail_mailinfo_mailid_def];
        mail.zxh_mail_mailinfo_folderid = [rs intForColumn:zxh_mail_mailinfo_folderid_def];
        mail.zxh_mail_mailinfo_remoteid = [rs stringForColumn:zxh_mail_mailinfo_remoteid_def];
        mail.zxh_mail_mailinfo_subject = [rs stringForColumn:zxh_mail_mailinfo_subject_def];
        mail.zxh_mail_mailinfo_abstract = [rs stringForColumn:zxh_mail_mailinfo_abstract_def];
        mail.zxh_mail_mailinfo_fromemail = [rs stringForColumn:zxh_mail_mailinfo_fromemail_def];
        mail.zxh_mail_mailinfo_tos = [rs stringForColumn:zxh_mail_mailinfo_tos_def];
        mail.zxh_mail_mailinfo_ccs = [rs stringForColumn:zxh_mail_mailinfo_ccs_def];
        mail.zxh_mail_mailinfo_bcc = [rs stringForColumn:zxh_mail_mailinfo_bcc_def];
        mail.zxh_mail_mailinfo_replyto = [rs stringForColumn:zxh_mail_mailinfo_replyto_def];
        mail.zxh_mail_mailinfo_hasAttach = [rs intForColumn:zxh_mail_mailinfo_hasAttach_def];
        mail.zxh_mail_mailinfo_receiveUtc = [rs doubleForColumn:zxh_mail_mailinfo_receiveUtc_def];
        mail.zxh_mail_mailinfo_sendUtc = [rs doubleForColumn:zxh_mail_mailinfo_sendUtc_def];
        mail.zxh_mail_mailinfo_isRead = [rs intForColumn:zxh_mail_mailinfo_isRead_def];
        mail.zxh_mail_mailinfo_isStar = [rs intForColumn:zxh_mail_mailinfo_isStar_def];
        mail.zxh_mail_mailinfo_isReplay = [rs intForColumn:zxh_mail_mailinfo_isReplay_def];
        mail.zxh_mail_mailinfo_isForward = [rs intForColumn:zxh_mail_mailinfo_isForward_def];
        mail.zxh_mail_mailinfo_mailAdType = [rs intForColumn:zxh_mail_mailinfo_mailAdType_def];
        mail.zxh_mail_mailinfo_isVip = [rs intForColumn:zxh_mail_mailinfo_isVip_def];
        mail.zxh_mail_mailinfo_convId = [rs intForColumn:zxh_mail_mailinfo_convId_def];
        mail.zxh_mail_mailinfo_mailType = [rs intForColumn:zxh_mail_mailinfo_mailType_def];
        mail.zxh_mail_mailinfo_messageId = [rs stringForColumn:zxh_mail_mailinfo_messageId_def];
        mail.zxh_mail_mailinfo_labels = [rs stringForColumn:zxh_mail_mailinfo_labels_def];
        mail.zxh_mail_mailinfo_ref = [rs stringForColumn:zxh_mail_mailinfo_ref_def];
        mail.zxh_mail_mailinfo_deleted = [rs intForColumn:zxh_mail_mailinfo_deleted_def];
        mail.zxh_mail_mailinfo_accountid = [rs intForColumn:zxh_mail_mailinfo_accountid_def];
        mail.zxh_mail_mailinfo_convCount = [rs intForColumn:zxh_mail_mailinfo_convCount_def];
        mail.zxh_mail_mailinfo_changeKey = [rs stringForColumn:zxh_mail_mailinfo_changeKey_def];
        mail.zxh_mail_mailinfo_gid = [rs stringForColumn:zxh_mail_mailinfo_gid_def];
        mail.zxh_mail_mailinfo_isGroup = [rs intForColumn:zxh_mail_mailinfo_isGroup_def];
        mail.zxh_mail_mailinfo_folderName = [rs stringForColumn:zxh_mail_mailinfo_folderName_def];
        mail.zxh_mail_mailinfo_size = [rs stringForColumn:zxh_mail_mailinfo_size_def];
        mail.zxh_mail_mailinfo_colid = [rs stringForColumn:zxh_mail_mailinfo_colid_def];
        mail.zxh_mail_mailinfo_fremoteId = [rs stringForColumn:zxh_mail_mailinfo_fremoteId_def];
        mail.zxh_mail_mailinfo_fromNick = [rs stringForColumn:zxh_mail_mailinfo_fromNick_def];
        mail.zxh_mail_mailinfo_cheatCode = [rs intForColumn:zxh_mail_mailinfo_cheatCode_def];
        mail.zxh_mail_mailinfo_ip = [rs stringForColumn:zxh_mail_mailinfo_ip_def];
        mail.zxh_mail_mailinfo_convType = [rs intForColumn:zxh_mail_mailinfo_convType_def];
        mail.zxh_mail_mailinfo_attach_count = [rs intForColumn:zxh_mail_mailinfo_attach_count_def];
        [resultArr addObject:mail];
    }
    [rs close];
    return resultArr;
}
+(ZXHMail_MailInfoObject*)fetchMailFromLocalByID:(ZXHMail_MailInfoObject *)mailObj dbPath:(NSString *)dbPath
{
    ZXHMail_MailInfoObject *mail = [[ZXHMail_MailInfoObject alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return mail;
    };
    [ZXHMail_MailInfoObject checkTableMail_InfoTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select * from %@ where %@=? and %@=? and %@=?",zxh_mail_mailinfo_table,zxh_mail_mailinfo_folderid_def,zxh_mail_mailinfo_accountid_def,zxh_mail_mailinfo_messageId_def];
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:mailObj.zxh_mail_mailinfo_folderid],[NSNumber numberWithInteger:mailObj.zxh_mail_mailinfo_accountid],mailObj.zxh_mail_mailinfo_messageId];
    while ([rs next]) {

        mail.zxh_mail_mailinfo_mailid = [rs intForColumn:zxh_mail_mailinfo_mailid_def];
        mail.zxh_mail_mailinfo_folderid = [rs intForColumn:zxh_mail_mailinfo_folderid_def];
        mail.zxh_mail_mailinfo_remoteid = [rs stringForColumn:zxh_mail_mailinfo_remoteid_def];
        mail.zxh_mail_mailinfo_subject = [rs stringForColumn:zxh_mail_mailinfo_subject_def];
        mail.zxh_mail_mailinfo_abstract = [rs stringForColumn:zxh_mail_mailinfo_abstract_def];
        mail.zxh_mail_mailinfo_fromemail = [rs stringForColumn:zxh_mail_mailinfo_fromemail_def];
        mail.zxh_mail_mailinfo_tos = [rs stringForColumn:zxh_mail_mailinfo_tos_def];
        mail.zxh_mail_mailinfo_ccs = [rs stringForColumn:zxh_mail_mailinfo_ccs_def];
        mail.zxh_mail_mailinfo_bcc = [rs stringForColumn:zxh_mail_mailinfo_bcc_def];
        mail.zxh_mail_mailinfo_replyto = [rs stringForColumn:zxh_mail_mailinfo_replyto_def];
        mail.zxh_mail_mailinfo_hasAttach = [rs intForColumn:zxh_mail_mailinfo_hasAttach_def];
        mail.zxh_mail_mailinfo_receiveUtc = [rs doubleForColumn:zxh_mail_mailinfo_receiveUtc_def];
        mail.zxh_mail_mailinfo_sendUtc = [rs doubleForColumn:zxh_mail_mailinfo_sendUtc_def];
        mail.zxh_mail_mailinfo_isRead = [rs intForColumn:zxh_mail_mailinfo_isRead_def];
        mail.zxh_mail_mailinfo_isStar = [rs intForColumn:zxh_mail_mailinfo_isStar_def];
        mail.zxh_mail_mailinfo_isReplay = [rs intForColumn:zxh_mail_mailinfo_isReplay_def];
        mail.zxh_mail_mailinfo_isForward = [rs intForColumn:zxh_mail_mailinfo_isForward_def];
        mail.zxh_mail_mailinfo_mailAdType = [rs intForColumn:zxh_mail_mailinfo_mailAdType_def];
        mail.zxh_mail_mailinfo_isVip = [rs intForColumn:zxh_mail_mailinfo_isVip_def];
        mail.zxh_mail_mailinfo_convId = [rs intForColumn:zxh_mail_mailinfo_convId_def];
        mail.zxh_mail_mailinfo_mailType = [rs intForColumn:zxh_mail_mailinfo_mailType_def];
        mail.zxh_mail_mailinfo_messageId = [rs stringForColumn:zxh_mail_mailinfo_messageId_def];
        mail.zxh_mail_mailinfo_labels = [rs stringForColumn:zxh_mail_mailinfo_labels_def];
        mail.zxh_mail_mailinfo_ref = [rs stringForColumn:zxh_mail_mailinfo_ref_def];
        mail.zxh_mail_mailinfo_deleted = [rs intForColumn:zxh_mail_mailinfo_deleted_def];
        mail.zxh_mail_mailinfo_accountid = [rs intForColumn:zxh_mail_mailinfo_accountid_def];
        mail.zxh_mail_mailinfo_convCount = [rs intForColumn:zxh_mail_mailinfo_convCount_def];
        mail.zxh_mail_mailinfo_changeKey = [rs stringForColumn:zxh_mail_mailinfo_changeKey_def];
        mail.zxh_mail_mailinfo_gid = [rs stringForColumn:zxh_mail_mailinfo_gid_def];
        mail.zxh_mail_mailinfo_isGroup = [rs intForColumn:zxh_mail_mailinfo_isGroup_def];
        mail.zxh_mail_mailinfo_folderName = [rs stringForColumn:zxh_mail_mailinfo_folderName_def];
        mail.zxh_mail_mailinfo_size = [rs stringForColumn:zxh_mail_mailinfo_size_def];
        mail.zxh_mail_mailinfo_colid = [rs stringForColumn:zxh_mail_mailinfo_colid_def];
        mail.zxh_mail_mailinfo_fremoteId = [rs stringForColumn:zxh_mail_mailinfo_fremoteId_def];
        mail.zxh_mail_mailinfo_fromNick = [rs stringForColumn:zxh_mail_mailinfo_fromNick_def];
        mail.zxh_mail_mailinfo_cheatCode = [rs intForColumn:zxh_mail_mailinfo_cheatCode_def];
        mail.zxh_mail_mailinfo_ip = [rs stringForColumn:zxh_mail_mailinfo_ip_def];
        mail.zxh_mail_mailinfo_convType = [rs intForColumn:zxh_mail_mailinfo_convType_def];
        mail.zxh_mail_mailinfo_attach_count = [rs intForColumn:zxh_mail_mailinfo_attach_count_def];
    }
    [rs close];
    return mail;
}

@end


#pragma mark - ZXHMail_Local_ItemObject
@implementation ZXHMail_Local_ItemObject
@synthesize  zxh_mail_local_item_id;
@synthesize  zxh_mail_local_item_data;
@synthesize  zxh_mail_local_item_accountid;
@synthesize  zxh_mail_local_item_type;
@synthesize  zxh_mail_local_item_state;
@synthesize  zxh_mail_local_item_createtime;
@synthesize  zxh_mail_local_item_updatetime;


@end

#pragma mark - ZXHMail_FolderObject
@implementation ZXHMail_FolderObject
@synthesize  zxh_mail_folder_id;
@synthesize  zxh_mail_folder_accountid;
@synthesize  zxh_mail_folder_remoteid;
@synthesize  zxh_mail_folder_name;
@synthesize  zxh_mail_folder_totalCnt;
@synthesize  zxh_mail_folder_unReadCnt;
@synthesize  zxh_mail_folder_isTop;
@synthesize  zxh_mail_folder_isVirtual;
@synthesize  zxh_mail_folder_parentid;
@synthesize  zxh_mail_folder_folderType;
@synthesize  zxh_mail_folder_sequence_idr;
@synthesize  zxh_mail_folder_showName;
@synthesize  zxh_mail_folder_parentName;
@synthesize  zxh_mail_folder_syncStatus;
@synthesize  zxh_mail_folder_svrKey;
@synthesize  zxh_mail_folder_syncUtc;
@synthesize  zxh_mail_folder_outDate;
@synthesize  zxh_mail_folder_hasNewMail;
@synthesize  zxh_mail_folder_remoteFolderType;
@synthesize  zxh_mail_folder_rType;
@synthesize  zxh_mail_folder_uidIder;
@synthesize  zxh_mail_folder_accountemail;
@synthesize  zxh_mail_folder_acctid;
@synthesize  zxh_mail_folder_editType;
@synthesize  zxh_mail_folder_uidNext;

+(BOOL)checkTableMail_FolderTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' INTEGER,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' INTEGER,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' INTEGER)",zxh_mail_folder_table,zxh_mail_folder_id_def,zxh_mail_folder_accountid_def,zxh_mail_folder_remoteid_def,zxh_mail_folder_name_def,zxh_mail_folder_totalCnt_def,zxh_mail_folder_unReadCnt_def,zxh_mail_folder_isTop_def,zxh_mail_folder_isVirtual_def,zxh_mail_folder_parentid_def,zxh_mail_folder_folderType_def,zxh_mail_folder_sequence_idr_def,zxh_mail_folder_showName_def,zxh_mail_folder_parentName_def,zxh_mail_folder_syncStatus_def,zxh_mail_folder_svrKey_def,zxh_mail_folder_syncUtc_def,zxh_mail_folder_outDate_def,zxh_mail_folder_hasNewMail_def,zxh_mail_folder_remoteFolderType_def,zxh_mail_folder_rType_def,zxh_mail_folder_uidIder_def,zxh_mail_folder_accountemail_def,zxh_mail_folder_acctid_def,zxh_mail_folder_editType_def,zxh_mail_folder_uidNext_def];
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}
+(BOOL)saveNewFolder:(ZXHMail_FolderObject *)folder  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_FolderObject checkTableMail_FolderTableCreatedInDb:db];
    
    NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",zxh_mail_folder_table,zxh_mail_folder_id_def,zxh_mail_folder_accountid_def,zxh_mail_folder_remoteid_def,zxh_mail_folder_name_def,zxh_mail_folder_totalCnt_def,zxh_mail_folder_unReadCnt_def,zxh_mail_folder_isTop_def,zxh_mail_folder_isVirtual_def,zxh_mail_folder_parentid_def,zxh_mail_folder_folderType_def,zxh_mail_folder_sequence_idr_def,zxh_mail_folder_showName_def,zxh_mail_folder_parentName_def,zxh_mail_folder_syncStatus_def,zxh_mail_folder_svrKey_def,zxh_mail_folder_syncUtc_def,zxh_mail_folder_outDate_def,zxh_mail_folder_hasNewMail_def,zxh_mail_folder_remoteFolderType_def,zxh_mail_folder_rType_def,zxh_mail_folder_uidIder_def,zxh_mail_folder_accountemail_def,zxh_mail_folder_acctid_def,zxh_mail_folder_editType_def,zxh_mail_folder_uidNext_def];
   BOOL worked = [db executeUpdate:insertStr,folder.zxh_mail_folder_id,[NSNumber numberWithInteger:folder.zxh_mail_folder_accountid],folder.zxh_mail_folder_remoteid,folder.zxh_mail_folder_name,folder.zxh_mail_folder_totalCnt,folder.zxh_mail_folder_unReadCnt,folder.zxh_mail_folder_isTop,folder.zxh_mail_folder_isVirtual,folder.zxh_mail_folder_parentid,[NSNumber numberWithInteger:folder.zxh_mail_folder_folderType],folder.zxh_mail_folder_sequence_idr,folder.zxh_mail_folder_showName,folder.zxh_mail_folder_parentName,folder.zxh_mail_folder_syncStatus,folder.zxh_mail_folder_svrKey,folder.zxh_mail_folder_syncUtc,folder.zxh_mail_folder_outDate,folder.zxh_mail_folder_hasNewMail,folder.zxh_mail_folder_remoteFolderType,folder.zxh_mail_folder_rType,folder.zxh_mail_folder_uidIder,folder.zxh_mail_folder_accountemail,folder.zxh_mail_folder_acctid,folder.zxh_mail_folder_editType,[NSNumber numberWithInteger:folder.zxh_mail_folder_uidNext]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;

}
+(BOOL)deleteFolderById:(NSInteger)folderid  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_FolderObject checkTableMail_FolderTableCreatedInDb:db];
    NSString *deleteStr = [NSString stringWithFormat:@"delete from %@ where %@=?",zxh_mail_folder_table,zxh_mail_folder_id_def];
    BOOL worked=[db executeUpdate:deleteStr,[NSNumber numberWithInteger:folderid]];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}

+(BOOL)updateFolder:(ZXHMail_FolderObject*)folder  dbPath:(NSString *)dbPath;
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_FolderObject checkTableMail_FolderTableCreatedInDb:db];

    NSString *updateStr = [NSString stringWithFormat:@"UPDATE '%@' SET '%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=?,'%@'=? WHERE %@=? AND %@=?",zxh_mail_folder_table,zxh_mail_folder_name_def,zxh_mail_folder_totalCnt_def,zxh_mail_folder_unReadCnt_def,zxh_mail_folder_isTop_def,zxh_mail_folder_isVirtual_def,zxh_mail_folder_parentid_def,zxh_mail_folder_folderType_def,zxh_mail_folder_sequence_idr_def,zxh_mail_folder_showName_def,zxh_mail_folder_parentName_def,zxh_mail_folder_syncStatus_def,zxh_mail_folder_svrKey_def,zxh_mail_folder_syncUtc_def,zxh_mail_folder_outDate_def,zxh_mail_folder_hasNewMail_def,zxh_mail_folder_remoteFolderType_def,zxh_mail_folder_rType_def,zxh_mail_folder_uidIder_def,zxh_mail_folder_accountemail_def,zxh_mail_folder_acctid_def,zxh_mail_folder_editType_def,zxh_mail_folder_uidNext_def,zxh_mail_folder_accountid_def,zxh_mail_folder_remoteid_def];
    BOOL worked = [db executeUpdate:updateStr,folder.zxh_mail_folder_name,folder.zxh_mail_folder_totalCnt,folder.zxh_mail_folder_unReadCnt,folder.zxh_mail_folder_isTop,folder.zxh_mail_folder_isVirtual,folder.zxh_mail_folder_parentid,[NSNumber numberWithInteger:folder.zxh_mail_folder_folderType],folder.zxh_mail_folder_sequence_idr,folder.zxh_mail_folder_showName,folder.zxh_mail_folder_parentName,folder.zxh_mail_folder_syncStatus,folder.zxh_mail_folder_svrKey,folder.zxh_mail_folder_syncUtc,folder.zxh_mail_folder_outDate,folder.zxh_mail_folder_hasNewMail,folder.zxh_mail_folder_remoteFolderType,folder.zxh_mail_folder_rType,folder.zxh_mail_folder_uidIder,folder.zxh_mail_folder_accountemail,folder.zxh_mail_folder_acctid,folder.zxh_mail_folder_editType,[NSNumber numberWithInteger:folder.zxh_mail_folder_uidNext],[NSNumber numberWithInteger:folder.zxh_mail_folder_accountid],folder.zxh_mail_folder_remoteid];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}
+(BOOL)haveSaveFolderById:(ZXHMail_FolderObject*)folder dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_FolderObject checkTableMail_FolderTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select count(*) from %@ where %@=? and %@=?",zxh_mail_folder_table,zxh_mail_folder_accountid_def,zxh_mail_folder_remoteid_def];
    
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:folder.zxh_mail_folder_accountid],folder.zxh_mail_folder_remoteid];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
}

+(ZXHMail_FolderObject *)fetchFolderUidNextFromLocal:(ZXHMail_FolderObject*)folder dbPath:(NSString *)dbPath
{
    ZXHMail_FolderObject *obj = [[ZXHMail_FolderObject alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    };
    [ZXHMail_FolderObject checkTableMail_FolderTableCreatedInDb:db];
    NSString *executeStr = [NSString stringWithFormat:@"select %@,%@ from %@ where %@=? and %@=?",zxh_mail_folder_id_def,zxh_mail_folder_uidNext_def,zxh_mail_folder_table,zxh_mail_folder_accountid_def,zxh_mail_folder_remoteid_def];
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:folder.zxh_mail_folder_accountid],folder.zxh_mail_folder_remoteid];
    while ([rs next]) {
        long uidnext= [rs longForColumn:zxh_mail_folder_uidNext_def];
        NSInteger folderid = [rs intForColumn:zxh_mail_folder_id_def];
        obj.zxh_mail_folder_uidNext = uidnext;
        obj.zxh_mail_folder_id = folderid;
        
        return obj;
    }
    return nil;
}

+(NSMutableArray*)fetchAllFolderFromLocal:(NSString *)dbPath accountid:(NSInteger)accountid
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return resultArr;
    };
    [ZXHMail_FolderObject checkTableMail_FolderTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select * from %@ where %@=? order by %@,%@ asc",zxh_mail_folder_table,zxh_mail_folder_accountid_def,zxh_mail_folder_editType_def,zxh_mail_folder_folderType_def];
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:accountid]];
    while ([rs next]) {
        ZXHMail_FolderObject *folder = [[ZXHMail_FolderObject alloc] init];
        folder.zxh_mail_folder_id = [rs intForColumn:zxh_mail_folder_id_def];
        folder.zxh_mail_folder_accountid = [rs intForColumn:zxh_mail_folder_accountid_def];
        folder.zxh_mail_folder_remoteid = [rs stringForColumn:zxh_mail_folder_remoteid_def];
        folder.zxh_mail_folder_name = [rs stringForColumn:zxh_mail_folder_name_def];
        folder.zxh_mail_folder_totalCnt = [rs stringForColumn:zxh_mail_folder_totalCnt_def];
        folder.zxh_mail_folder_unReadCnt = [rs stringForColumn:zxh_mail_folder_unReadCnt_def];
        folder.zxh_mail_folder_isTop = [rs stringForColumn:zxh_mail_folder_isTop_def];
        folder.zxh_mail_folder_isVirtual = [rs stringForColumn:zxh_mail_folder_isVirtual_def];
        folder.zxh_mail_folder_parentid = [rs stringForColumn:zxh_mail_folder_parentid_def];
        folder.zxh_mail_folder_folderType = [rs intForColumn:zxh_mail_folder_folderType_def];
        folder.zxh_mail_folder_sequence_idr = [rs stringForColumn:zxh_mail_folder_sequence_idr_def];
        folder.zxh_mail_folder_showName = [rs stringForColumn:zxh_mail_folder_showName_def];
        folder.zxh_mail_folder_parentName = [rs stringForColumn:zxh_mail_folder_parentName_def];
        folder.zxh_mail_folder_syncStatus = [rs stringForColumn:zxh_mail_folder_syncStatus_def];
        folder.zxh_mail_folder_svrKey = [rs stringForColumn:zxh_mail_folder_svrKey_def];
        folder.zxh_mail_folder_syncUtc = [rs stringForColumn:zxh_mail_folder_syncUtc_def];
        folder.zxh_mail_folder_outDate = [rs stringForColumn:zxh_mail_folder_outDate_def];
        folder.zxh_mail_folder_hasNewMail = [rs stringForColumn:zxh_mail_folder_hasNewMail_def];
        folder.zxh_mail_folder_remoteFolderType = [rs stringForColumn:zxh_mail_folder_remoteFolderType_def];
        folder.zxh_mail_folder_rType = [rs stringForColumn:zxh_mail_folder_rType_def];
        folder.zxh_mail_folder_uidIder = [rs stringForColumn:zxh_mail_folder_uidIder_def];
        folder.zxh_mail_folder_accountemail = [rs stringForColumn:zxh_mail_folder_accountemail_def];
        folder.zxh_mail_folder_acctid = [rs stringForColumn:zxh_mail_folder_acctid_def];
        folder.zxh_mail_folder_editType = [rs stringForColumn:zxh_mail_folder_editType_def];
        folder.zxh_mail_folder_uidNext = [rs intForColumn:zxh_mail_folder_uidNext_def];
        [resultArr addObject:folder];
    }
    [rs close];
    return resultArr;
}

@end

#pragma mark - ZXHMail_AccountSettingObject
@implementation ZXHMail_AccountSettingObject
@synthesize  zxh_mail_account_setting_id;
@synthesize  zxh_mail_account_setting_name;
@synthesize  zxh_mail_account_setting_image;
@synthesize  zxh_mail_account_setting_sign;
@synthesize  zxh_mail_account_setting_pushFolderlist;
@synthesize  zxh_mail_account_setting_accountNewMailTip;
@synthesize  zxh_mail_account_setting_revieveFolderTip;
@synthesize  zxh_mail_account_setting_showConversasion;
@synthesize  zxh_mail_account_setting_enableAccountNewMailTip;
@synthesize  zxh_mail_account_setting_accountWebDiscKey;
@synthesize  zxh_mail_account_setting_folderAccessNeedPassword;
@synthesize  zxh_mail_account_setting_userInputAccessFolderPassword;
@synthesize  zxh_mail_account_setting_userHandleFolderToAccount;
@synthesize  zxh_mail_account_setting_descubcnt;

+(BOOL)checkTableAccountSettingTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT)",zxh_mail_account_setting_table,zxh_mail_account_id_def,zxh_mail_account_setting_name_def,zxh_mail_account_setting_image_def,zxh_mail_account_setting_sign_def,zxh_mail_account_setting_pushFolderlist_def,zxh_mail_account_setting_accountNewMailTip_def,zxh_mail_account_setting_revieveFolderTip_def,zxh_mail_account_setting_showConversasion_def,zxh_mail_account_setting_enableAccountNewMailTip_def,zxh_mail_account_setting_accountWebDiscKey_def,zxh_mail_account_setting_folderAccessNeedPassword_def,zxh_mail_account_setting_userInputAccessFolderPassword_def,zxh_mail_account_setting_userHandleFolderToAccount_def,zxh_mail_account_setting_descubcn_def];
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}
+(BOOL)saveNewAccount:(ZXHMail_AccountSettingObject *)accountsetting  dbPath:(NSString *)dbPath
{
//    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
//    if (![db open]) {
//        NSLog(@"数据库打开失败");
//        return NO;
//    };
//    
//    if (account.z == nil) return NO;
//    [ZXHMail_AccountSettingObject checkTableAccountSettingTableCreatedInDb:db];
//    
//    NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES (?,?,?,?,?,?,?,?,?,?,?)",zxh_mail_account_table,zxh_mail_account_id_def,zxh_mail_account_name_def,zxh_mail_account_alias_def,zxh_mail_account_profile_def,zxh_mail_account_type_def,zxh_mail_account_isChief_def,zxh_mail_account_isCloudPush_def,zxh_mail_account_state_def,zxh_mail_account_syncUtc_def,zxh_mail_account_synckey_def,zxh_mail_account_intervalPullTime_def];
//    
//    BOOL worked = [db executeUpdate:insertStr,account.zxh_mail_account_id,account.zxh_mail_account_name,account.zxh_mail_account_alias,account.zxh_mail_account_profile,account.zxh_mail_account_type,account.zxh_mail_account_isChief,account.zxh_mail_account_isCloudPush,account.zxh_mail_account_state,account.zxh_mail_account_syncUtc,account.zxh_mail_account_synckey,account.zxh_mail_account_intervalPullTime];
//    FMDBQuickCheck(worked);
//    [db close];
//    return worked;
    return NO;
}
+(BOOL)deleteAccountById:(NSInteger)accountId  dbPath:(NSString *)dbPath
{
    return NO;
}
+(BOOL)updateAccount:(ZXHMail_AccountSettingObject*)account  dbPath:(NSString *)dbPath
{
    return NO;
}
+(BOOL)haveSaveAccountById:(NSInteger)accountId dbPath:(NSString *)dbPath
{
    return NO;
}
+(NSMutableArray*)fetchAllAccountFromLocal:(NSString *)dbPath
{
    return nil;
}
+(ZXHMail_AccountSettingObject*)fetchAccountFromLocalByID:(NSInteger)account dbPath:(NSString *)dbPath
{
    return nil;
}
//将对象转换为字典
-(NSDictionary*)toDictionary
{
    return nil;
}
+(ZXHMail_AccountSettingObject*)accountFromDictionary:(NSDictionary*)aDic
{
    return nil;
}
@end

#pragma mark - ZXHMail_ContainObjectContoller
@implementation ZXHMail_ContainObjectContoller
@synthesize  zxh_mail_account_id;
@synthesize  zxh_mail_account_name;
@synthesize  zxh_mail_account_alias;
@synthesize  zxh_mail_account_profile;
@synthesize  zxh_mail_account_type;
@synthesize  zxh_mail_account_isChief;
@synthesize  zxh_mail_account_isCloudPush;
@synthesize  zxh_mail_account_state;
@synthesize  zxh_mail_account_syncUtc;
@synthesize  zxh_mail_account_synckey;
@synthesize  zxh_mail_account_intervalPullTime;

//数据库增删改查
+(BOOL)checkTableAccountTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' BLOB,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT)",zxh_mail_account_table,zxh_mail_account_id_def,zxh_mail_account_name_def,zxh_mail_account_alias_def,zxh_mail_account_profile_def,zxh_mail_account_type_def,zxh_mail_account_isChief_def,zxh_mail_account_isCloudPush_def,zxh_mail_account_state_def,zxh_mail_account_syncUtc_def,zxh_mail_account_synckey_def,zxh_mail_account_intervalPullTime_def];
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}
+(BOOL)saveNewAccount:(ZXHMail_ContainObjectContoller *)account  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    if (account.zxh_mail_account_name == nil) return NO;
    [ZXHMail_ContainObjectContoller checkTableAccountTableCreatedInDb:db];
    
    NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') VALUES (?,?,?,?,?,?,?,?,?,?,?)",zxh_mail_account_table,zxh_mail_account_id_def,zxh_mail_account_name_def,zxh_mail_account_alias_def,zxh_mail_account_profile_def,zxh_mail_account_type_def,zxh_mail_account_isChief_def,zxh_mail_account_isCloudPush_def,zxh_mail_account_state_def,zxh_mail_account_syncUtc_def,zxh_mail_account_synckey_def,zxh_mail_account_intervalPullTime_def];
    
    BOOL worked = [db executeUpdate:insertStr,account.zxh_mail_account_id,account.zxh_mail_account_name,account.zxh_mail_account_alias,account.zxh_mail_account_profile,account.zxh_mail_account_type,account.zxh_mail_account_isChief,account.zxh_mail_account_isCloudPush,account.zxh_mail_account_state,account.zxh_mail_account_syncUtc,account.zxh_mail_account_synckey,account.zxh_mail_account_intervalPullTime];
    FMDBQuickCheck(worked);
    [db close];
    return worked;
}
+(BOOL)deleteAccountById:(NSInteger)accountId  dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_ContainObjectContoller checkTableAccountTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"delete from %@ where %@=?",zxh_mail_account_table,zxh_mail_account_id_def];
    BOOL worked=[db executeUpdate:executeStr,accountId];
    FMDBQuickCheck(worked);
    return worked;
}
+(BOOL)updateAccount:(ZXHMail_ContainObjectContoller*)account  dbPath:(NSString *)dbPath
{
    return NO;
}
+(BOOL)haveSaveAccountByName:(NSString *)accountName dbPath:(NSString *)dbPath
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ZXHMail_ContainObjectContoller checkTableAccountTableCreatedInDb:db];
    
    
    NSString *executeStr = [NSString stringWithFormat:@"select count(*) from %@ where %@=? COLLATE NOCASE",zxh_mail_account_table,zxh_mail_account_name_def];
    
    FMResultSet *rs=[db executeQuery:executeStr,accountName];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
}
+(NSMutableArray*)fetchAllAccountFromLocal:(NSString *)dbPath
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return resultArr;
    };
   [ZXHMail_ContainObjectContoller checkTableAccountTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select * from %@",zxh_mail_account_table];
    FMResultSet *rs=[db executeQuery:executeStr];
    while ([rs next]) {
        ZXHMail_ContainObjectContoller *account = [[ZXHMail_ContainObjectContoller alloc] init];
        account.zxh_mail_account_id = [rs intForColumn:zxh_mail_account_id_def];
        account.zxh_mail_account_name = [rs stringForColumn:zxh_mail_account_name_def];
        account.zxh_mail_account_alias = [rs stringForColumn:zxh_mail_account_alias_def];
        account.zxh_mail_account_profile = [rs dataForColumn:zxh_mail_account_profile_def];
        account.zxh_mail_account_type = [rs stringForColumn:zxh_mail_account_type_def];;
        account.zxh_mail_account_isChief = [rs stringForColumn:zxh_mail_account_isChief_def];;
        account.zxh_mail_account_isCloudPush = [rs stringForColumn:zxh_mail_account_isCloudPush_def];;
        account.zxh_mail_account_state = [rs stringForColumn:zxh_mail_account_state_def];;
        account.zxh_mail_account_syncUtc = [rs stringForColumn:zxh_mail_account_syncUtc_def];;
        account.zxh_mail_account_synckey = [rs stringForColumn:zxh_mail_account_synckey_def];;
        account.zxh_mail_account_intervalPullTime = [rs stringForColumn:zxh_mail_account_intervalPullTime_def];
        [resultArr addObject:account];
    }
    [rs close];
    return resultArr;
}

+(ZXHMail_ContainObjectContoller*)fetchAccountFromLocalByID:(NSInteger)account dbPath:(NSString *)dbPath
//将对象转换为字典
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    };
    [ZXHMail_ContainObjectContoller checkTableAccountTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select * from %@ where %@=?",zxh_mail_account_table,zxh_mail_account_id_def];
    FMResultSet *rs=[db executeQuery:executeStr,[NSNumber numberWithInteger:account]];
    ZXHMail_ContainObjectContoller *accountinfo = [[ZXHMail_ContainObjectContoller alloc] init];
    while ([rs next]) {
        accountinfo.zxh_mail_account_id = [rs intForColumn:zxh_mail_account_id_def];
        accountinfo.zxh_mail_account_name = [rs stringForColumn:zxh_mail_account_name_def];
        accountinfo.zxh_mail_account_alias = [rs stringForColumn:zxh_mail_account_alias_def];
        accountinfo.zxh_mail_account_profile = [rs dataForColumn:zxh_mail_account_profile_def];
        accountinfo.zxh_mail_account_type = [rs stringForColumn:zxh_mail_account_type_def];;
        accountinfo.zxh_mail_account_isChief = [rs stringForColumn:zxh_mail_account_isChief_def];;
        accountinfo.zxh_mail_account_isCloudPush = [rs stringForColumn:zxh_mail_account_isCloudPush_def];;
        accountinfo.zxh_mail_account_state = [rs stringForColumn:zxh_mail_account_state_def];;
        accountinfo.zxh_mail_account_syncUtc = [rs stringForColumn:zxh_mail_account_syncUtc_def];;
        accountinfo.zxh_mail_account_synckey = [rs stringForColumn:zxh_mail_account_synckey_def];;
        accountinfo.zxh_mail_account_intervalPullTime = [rs stringForColumn:zxh_mail_account_intervalPullTime_def];
    }
    [rs close];
    return accountinfo;
}

+(ZXHMail_ContainObjectContoller*)fetchAccountFromLocalByName:(NSString *)account dbPath:(NSString *)dbPath;
//将对象转换为字典
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    };
    [ZXHMail_ContainObjectContoller checkTableAccountTableCreatedInDb:db];
    
    NSString *executeStr = [NSString stringWithFormat:@"select * from %@ where %@=?",zxh_mail_account_table,zxh_mail_account_name_def];
    FMResultSet *rs=[db executeQuery:executeStr,account];
    ZXHMail_ContainObjectContoller *accountinfo = [[ZXHMail_ContainObjectContoller alloc] init];
    while ([rs next]) {
        
        accountinfo.zxh_mail_account_id = [rs intForColumn:zxh_mail_account_id_def];
        accountinfo.zxh_mail_account_name = [rs stringForColumn:zxh_mail_account_name_def];
        accountinfo.zxh_mail_account_alias = [rs stringForColumn:zxh_mail_account_alias_def];
        accountinfo.zxh_mail_account_profile = [rs dataForColumn:zxh_mail_account_profile_def];
        accountinfo.zxh_mail_account_type = [rs stringForColumn:zxh_mail_account_type_def];;
        accountinfo.zxh_mail_account_isChief = [rs stringForColumn:zxh_mail_account_isChief_def];;
        accountinfo.zxh_mail_account_isCloudPush = [rs stringForColumn:zxh_mail_account_isCloudPush_def];;
        accountinfo.zxh_mail_account_state = [rs stringForColumn:zxh_mail_account_state_def];;
        accountinfo.zxh_mail_account_syncUtc = [rs stringForColumn:zxh_mail_account_syncUtc_def];;
        accountinfo.zxh_mail_account_synckey = [rs stringForColumn:zxh_mail_account_synckey_def];;
        accountinfo.zxh_mail_account_intervalPullTime = [rs stringForColumn:zxh_mail_account_intervalPullTime_def];
    }
    [rs close];
    return accountinfo;
}

-(NSDictionary*)toDictionary
{
    NSNumber *kid = [NSNumber numberWithInteger:self.zxh_mail_account_id];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:kid,zxh_mail_account_id_def,self.zxh_mail_account_name,zxh_mail_account_name_def,self.zxh_mail_account_alias,zxh_mail_account_alias_def,self.zxh_mail_account_profile,zxh_mail_account_profile_def,self.zxh_mail_account_type,zxh_mail_account_type_def,self.zxh_mail_account_isChief,zxh_mail_account_isChief_def,self.zxh_mail_account_isCloudPush,zxh_mail_account_isCloudPush_def,zxh_mail_account_state,zxh_mail_account_state_def,self.zxh_mail_account_syncUtc,zxh_mail_account_syncUtc_def,self.zxh_mail_account_synckey,zxh_mail_account_synckey_def,self.zxh_mail_account_intervalPullTime,zxh_mail_account_intervalPullTime_def,nil];
    
    return dic;
}
+(ZXHMail_ContainObjectContoller*)accountFromDictionary:(NSDictionary*)aDic
{
    ZXHMail_ContainObjectContoller *accountinfo = [[ZXHMail_ContainObjectContoller alloc]init];
    accountinfo.zxh_mail_account_id = [[NSString stringWithFormat:@"%@",[aDic objectForKey:zxh_mail_account_name_def]] intValue];
    accountinfo.zxh_mail_account_name = [aDic objectForKey:zxh_mail_account_name_def];
    accountinfo.zxh_mail_account_alias = [aDic objectForKey:zxh_mail_account_alias_def];
    accountinfo.zxh_mail_account_profile = [aDic objectForKey:zxh_mail_account_profile_def];
    accountinfo.zxh_mail_account_type = [aDic objectForKey:zxh_mail_account_type_def];;
    accountinfo.zxh_mail_account_isChief = [aDic objectForKey:zxh_mail_account_isChief_def];;
    accountinfo.zxh_mail_account_isCloudPush = [aDic objectForKey:zxh_mail_account_isCloudPush_def];;
    accountinfo.zxh_mail_account_state = [aDic objectForKey:zxh_mail_account_state_def];;
    accountinfo.zxh_mail_account_syncUtc = [aDic objectForKey:zxh_mail_account_syncUtc_def];;
    accountinfo.zxh_mail_account_synckey = [aDic objectForKey:zxh_mail_account_synckey_def];;
    accountinfo.zxh_mail_account_intervalPullTime = [aDic objectForKey:zxh_mail_account_intervalPullTime_def];
    return accountinfo;
}

@end
