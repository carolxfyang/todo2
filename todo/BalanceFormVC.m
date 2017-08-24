//
//  BalanceFormVC.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "BalanceFormVC.h"
#import <UserNotifications/UserNotifications.h>

NSString * const ktitleB = @"title";
NSString * const kEndTimeB = @"endTime";
NSString * const kAlertFlagB = @"alertFlag";
NSString * const kCommentB = @"comment";
NSString * const kItemIndexB = @"itemIndex";
NSString * const kFinishedFlagB = @"finishedFlag";

@interface BalanceFormVC()

@property (nonatomic, strong) NSDictionary *formData;
@property (nonatomic) BOOL isAdd;

@end

@implementation BalanceFormVC


-  (instancetype)initWithValues:(NSDictionary *)values {
    self = [super init];
    if (self) {
        self.formData = values;
        [self initializeForm:values];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (NSString *)getBalancePlistPath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return [docPath stringByAppendingPathComponent:@"balance.plist"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.formData) {
        
        self.navigationItem.title = @"information";
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(addBalance)];
        self.navigationItem.title = @"Add";
    }
}

    
- (void)addBalance {
    NSDictionary *values = [self.form formValues];
    
    NSString *balancePath = [self getBalancePlistPath];
    
    int currentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *index = [defaults valueForKey:kItemIndexB];
    if (index == nil) {
        index = [[NSNumber alloc]initWithInt:1];
    }
    currentIndex = index?index.intValue:1;
    [defaults setValue:[[NSNumber alloc]initWithInt:(currentIndex+1)] forKey:kItemIndexB];
    [defaults synchronize];
    
    
    NSMutableArray *listItemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:balancePath];
    
    if (listItemArray==nil) {
        listItemArray = [NSMutableArray arrayWithCapacity:100];
    }
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc]initWithDictionary:values];
    [mDict setValue:index forKey:kItemIndexB];
    
    [listItemArray addObject:mDict];
    
    [NSKeyedArchiver archiveRootObject:listItemArray toFile:balancePath];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.callbackDelegate callback];
}

- (void)initializeForm:(NSDictionary *)values {
    XLFormDescriptor *form;
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:ktitleB rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    //row.required = true;
    if(values){
        NSString *title = [values objectForKey:ktitleB];
        row.value = [title isKindOfClass:[NSNull class]]?@"":title;
    }
    //row.requireMsg = @"不能为空";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCommentB rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Amount" forKey:@"textField.placeholder"];
    
    if (values) {
        NSString *amount = [values objectForKey:kCommentB];
        row.value = [amount isKindOfClass:[NSNull class]]?@"":amount;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEndTimeB rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Time"];
    
    if (values) {
        row.value = [values objectForKey:kEndTimeB];
    } else {
        row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    }
    [section addFormRow:row];
    
    row= [XLFormRowDescriptor formRowDescriptorWithTag:kCommentB rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Location" forKey:@"textField.placeholder"];
    if (values) {
        NSString *location = [values valueForKey:kCommentB];
        row.value = [location isKindOfClass:[NSNull class]]?@"":location;
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCommentB rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Comment" forKey:@"textView.placeholder"];
    if (values) {
        NSString *comment = [values valueForKey:kCommentB];
        row.value = [comment isKindOfClass:[NSNull class]]?@"":comment;
    } else {
        row.value = @"";
    }
    [section addFormRow:row];
    
    self.form = form;
    
    if (values) {
        self.form.disabled = YES;
        self.isAdd = NO;
    } else {
        self.isAdd = YES;
    }
}



   
@end
