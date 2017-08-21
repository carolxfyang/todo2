//
//  ViewController.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "TODOViewController.h"
#import "MJRefresh.h"

NSString * const kFinishedFlagTODO = @"finishedFlag";

@interface TODOViewController()<TODOFormDelegate>

@property(nonatomic, strong) NSArray *listItemArray;

@end

@implementation TODOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
