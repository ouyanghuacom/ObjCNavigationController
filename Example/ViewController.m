//
//  ViewController.m
//  Example
//
//  Created by ouyanghuacom on 2019/12/27.
//  Copyright © 2019 ouyanghuacom. All rights reserved.
//

#import "ViewController.h"
#import "PushViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pushViewController:[[PushViewController alloc]init] animated:NO];
    // Do any additional setup after loading the view.
}


@end
