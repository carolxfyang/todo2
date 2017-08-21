//
//  ViewController.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "TODOViewController.h"
#import "MJRefresh.h"
#import "TODOFormVC.h"

NSString * const kFinishedFlagTODO = @"finishedFlag";

@interface TODOViewController()<TodoFormDelegate>

@property(nonatomic, strong) NSArray *listItemArray;

@end

@implementation TODOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTodo)];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"TODO";
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *todoPath = [docPath stringByAppendingPathComponent:@"todo.plist"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.listItemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:todoPath];
        
        if (self.listItemArray == nil) {
            self.listItemArray = [NSMutableArray arrayWithCapacity:100];
        }
        
        self.listItemArray = [self.listItemArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2){
            NSComparisonResult result = [[obj1 objectForKey:@"endTime"] compare:[obj2 objectForKey:@"endTime"]];
            return result;
        }];
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setHidesBottomBarWhenPushed:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
