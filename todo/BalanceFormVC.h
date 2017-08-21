//
//  BalanceFormVC.h
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import <XLForm/XLForm.h>

@protocol BalanceFormDelegate

- (void) callback;

@end

@interface BalanceFormVC: XLFormViewController

- (instancetype)initWithValues:(NSDictionary *)values;

@property (nonatomic, weak) id<BalanceFormDelegate> callbackDelegate;

@end
