//
//  BalanceViewController.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "BalanceViewController.h"
#import "MJRefresh.h"
#import "BalanceFormVC.h"

NSString * const kFinishedFlagBalance = @"finishedFlag";

@interface BalanceViewController()<BalanceFormDelegate>

@property (nonatomic, strong) NSArray *listItemArray;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBalance)];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Balance";
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *balancePath = [docPath stringByAppendingPathComponent:@"balance.plist"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.listItemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:balancePath];
        
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

- (void)deleteItem:(NSNumber *)itemIndex {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *balancePath = [docPath stringByAppendingPathComponent:@"balance.plist"];
    
    self.listItemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:balancePath];
    
    if (self.listItemArray == nil) {
        self.listItemArray = [NSMutableArray arrayWithCapacity:100];
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.listItemArray];
    
    
    [tempArr removeObjectAtIndex:[itemIndex integerValue]];
            
    
    self.listItemArray = [[NSArray alloc]initWithArray:tempArr];
    
    
    self.listItemArray = [self.listItemArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2){
        NSComparisonResult result = [[obj1 objectForKey:@"endTime"] compare:[obj2 objectForKey:@"endTime"]];
        return result;
    }];
    
    [NSKeyedArchiver archiveRootObject:self.listItemArray toFile:balancePath];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)addBalance {
    [self setHidesBottomBarWhenPushed:YES];
    
    BalanceFormVC *newBalance = [[BalanceFormVC alloc]initWithValues:nil];
    newBalance.callbackDelegate = self;
    [self.navigationController pushViewController:newBalance animated:YES];
    
}

- (void)callback{
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)alertWithMsg:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"title" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull acion) {
        NSLog(@"OK");
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *idetifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idetifier];
    }
    NSDictionary *dict = [self.listItemArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"balance"];
    
    cell.textLabel.text = [dict valueForKey:@"title"] == nil?@"":[dict valueForKey:@"title"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[dict valueForKey:@"endTime"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Due to: %@",strDate];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView  editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"Delete");
        [self deleteItem:[NSNumber numberWithInteger:indexPath.row]];
    }];
    
    return @[deleteRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [self.listItemArray objectAtIndex:indexPath.row];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    BalanceFormVC *newBalance = [[BalanceFormVC alloc]initWithValues:data];
    newBalance.callbackDelegate = self;
    [self.navigationController pushViewController:newBalance animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
