//
//  ZXHMySearchBar.h
//  MailTest
//
//  Created by 朱星海 on 14-6-10.
//  Copyright (c) 2014年 朱星海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHMySearchBar : UISearchBar<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIButton *button;
@end
