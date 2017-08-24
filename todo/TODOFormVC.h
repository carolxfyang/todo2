//
//  TODOFormVC.h
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import <XLForm/XLForm.h>

@protocol TodoFormDelegate

- (void) callback;

@end

@interface TODOFormVC: XLFormViewController

- (instancetype)initWithValues:(NSDictionary *)values;

@property (nonatomic, weak) id<TodoFormDelegate> callbackDelegate;

@end

