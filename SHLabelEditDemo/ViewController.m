//
//  ViewController.m
//  SHLabelEditDemo
//
//  Created by shshy on 15/11/18.
//  Copyright © 2015年 expai. All rights reserved.
//

#import "ViewController.h"
#import "SHLabelEditController.h"
#import "SHLabelModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)actionHandler:(id)sender {
    SHLabelEditController *editVC = [[SHLabelEditController alloc]initWithCurrentChannelIndex:0 myChannels:nil recChannels:nil selectHandler:^(SHLabelModel *model, NSInteger index) {
        
    } resultHandler:^(NSArray *models) {
        
    }];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editVC];
    [self presentViewController:nav animated:NO completion:nil];
}


@end
