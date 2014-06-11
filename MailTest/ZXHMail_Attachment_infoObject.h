//
//  ZXHMail_Attachment_infoObject.h
//  MailTest
//
//  Created by 朱星海 on 14-6-4.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
@interface ZXHMail_Attachment_infoObject : NSObject

@property (nonatomic, strong) NSString      *filename;
@property (nonatomic, strong) NSString      *description;
@property (nonatomic, strong) NSString      *mimetype;
@property (nonatomic, assign) MCOEncoding   encoding;
@property (nonatomic, assign) NSInteger     filesize;
@property (nonatomic, strong) NSString      *uniqueid;
@property (nonatomic, strong) NSString      *partid;
@end
