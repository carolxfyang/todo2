//
//  MainViewController.m
//  todo
//
//  Created by icbc on 2017/8/21.
//  Copyright © 2017年 carolxfyang. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TODOViewController *todoVC = [[TODOViewController alloc]init];
    UINavigationController *todoNC = [[UINavigationController alloc]initWithRootViewController:todoVC];
    UITabBarItem *todoTBI = [[UITabBarItem alloc]initWithTitle:@"TODO" image:[UIImage imageNamed:@"todolist"] tag:0];
    todoNC.tabBarItem = todoTBI;
    
    BalanceViewController *balanceVC = [[BalanceViewController alloc]init];
    UINavigationController *balanceNC = [[UINavigationController alloc]initWithRootViewController:balanceVC];
    UITabBarItem *balanceTBI = [[UITabBarItem alloc]initWithTitle:@"Balance" image:[UIImage imageNamed:@"Balance"] tag:1];
    balanceNC.tabBarItem = balanceTBI;
    
    [self setViewControllers:@[todoNC,balanceNC] animated:YES];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
