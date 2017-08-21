//
//  TODOFormVC.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "TODOFormVC.h"

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
}





@end
