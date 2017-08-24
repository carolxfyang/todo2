//
//  TODOFormVC.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "TODOFormVC.h"
#import <UserNotifications/UserNotifications.h>

NSString * const ktitle = @"title";
NSString * const kEndTime = @"endTime";
NSString * const kAlertFlag = @"alertFlag";
NSString * const kComment = @"comment";
NSString * const kItemIndex = @"itemIndex";
NSString * const kFinishedFlag = @"finishedFlag";

@interface TODOFormVC ()

@property (nonatomic, strong) NSDictionary *formData;
@property (nonatomic) BOOL isAdd;

@end

@implementation TODOFormVC

- (instancetype)initWithValues:(NSDictionary *)values {
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

- (NSString *)getTodoPlistPath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return [docPath stringByAppendingPathComponent:@"todo.plist"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.formData) {
        if (![self.formData objectForKey:kFinishedFlag]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Complete" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        }
        self.navigationItem.title = @"information";
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(addTodo)];
        self.navigationItem.title = @"Add";
    }
}

- (void)done {
    NSNumber *itemIndex = [self.formData valueForKey:kItemIndex];
    
    NSString *todoPath = [self getTodoPlistPath];
    
    NSMutableArray *listItemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:todoPath];
    
    if (listItemArray!=nil) {
        for (NSMutableDictionary *dictItem in listItemArray) {
            if ([[dictItem valueForKey:kItemIndex] isEqualToNumber:itemIndex]) {
                [dictItem setValue:@YES forKey:kFinishedFlag];
                break;
            }
        }
        [NSKeyedArchiver archiveRootObject:listItemArray toFile:todoPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.callbackDelegate callback];
}

- (void)addTodo {
    
    NSDictionary *values = [self.form formValues];
    
    NSString *todoPath = [self getTodoPlistPath];
    
    int currentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *index = [defaults valueForKey:kItemIndex];
    if (index == nil) {
        index = [[NSNumber alloc]initWithInt:1];
    }
    currentIndex = index?index.intValue:1;
    [defaults setValue:[[NSNumber alloc]initWithInt:(currentIndex+1)] forKey:kItemIndex];
    [defaults synchronize];
    
    
    NSMutableArray *listItemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:todoPath];
    
    if (listItemArray==nil) {
        listItemArray = [NSMutableArray arrayWithCapacity:100];
    }
    
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc]initWithDictionary:values];
    [mDict setValue:index forKey:kItemIndex];
    
    [listItemArray addObject:mDict];
    
    [NSKeyedArchiver archiveRootObject:listItemArray toFile:todoPath];
    
    //[self addNotifaication];
    
    NSNumber *alertFlag = [self.form.formValues valueForKey:kAlertFlag];
    if ([alertFlag isEqualToNumber:@1]) {
        [self registerNotification];
    }
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
    
    // 标题
    row = [XLFormRowDescriptor formRowDescriptorWithTag:ktitle rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    //row.required = true;
    if(values){
        NSString *title = [values objectForKey:ktitle];
        row.value = [title isKindOfClass:[NSNull class]]?@"":title;
    }
    //row.requireMsg = @"不能为空";
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEndTime rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Due"];
    
    if (values) {
        row.value = [values objectForKey:kEndTime];
    } else {
        row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    }
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAlertFlag rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Remaind"];
    
    if (values) {
        NSNumber *alertFlag = [values valueForKey:kAlertFlag];
        row.value = [alertFlag isEqualToNumber:@1]?@YES:@NO;
    } else {
        row.value = @YES;
    }
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kComment rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Comment" forKey:@"textView.placeholder"];
    if (values) {
        NSString *comment = [values valueForKey:kComment];
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



-(void)registerNotification{
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    NSString *title = [self.form.formValues valueForKey:ktitle];
    content.title = title==nil?@" ":title;
    NSString *body = [self.form.formValues valueForKey:kComment];
    content.body = body==nil?@" ":body;
    content.sound = [UNNotificationSound defaultSound];
    
    NSDate *endTime = [self.form.formValues valueForKey:kEndTime];
    
    NSTimeInterval interval = [endTime timeIntervalSinceDate:[NSDate new]];
    
    //interval = 10;
    
    // 在 alertTime 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:interval repeats:NO];
    
    NSString *alertId = [NSString stringWithFormat:@"alertid_%@",[self.form.formValues valueForKey:kItemIndex]];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:alertId
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

@end
