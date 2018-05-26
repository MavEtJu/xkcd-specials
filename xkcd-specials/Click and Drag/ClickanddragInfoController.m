//
//  InfoViewController.m
//  xkcd-clickanddrag
//
//  Created by Edwin Groothuis on 25/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "ClickanddragInfoController.h"

@interface ClickanddragInfoController ()

@end

@implementation ClickanddragInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labelTitle.text = @"XKCD - CLICK AND DRAG";
    self.labelUsage.text = @"Just scroll around and discover the world.\nZoom in or out on the slider to see more (or less).\nTap to recenter a position.";
}

- (IBAction)closeInfo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
