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
    
    
}



@end
