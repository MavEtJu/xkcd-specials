//
//  ViewController.m
//  xkcd-specials
//
//  Created by Edwin Groothuis on 26/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.timeIV.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Images - Time/Time - Logo.png", [[NSBundle mainBundle] resourcePath]]];
    self.clickanddragIV.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Images - Click and Drag/Click-logo.png", [[NSBundle mainBundle] resourcePath]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
