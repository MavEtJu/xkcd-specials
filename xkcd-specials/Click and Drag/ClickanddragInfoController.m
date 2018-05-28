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

    self.labelTitle.text = @"XKCD 1110 - CLICK AND DRAG";
    self.labelUsage.text = @"Just scroll around and discover the world.\n"
    "Zoom in or out on the slider to see more (or less).\n"
    "Pinch to zoom in or out.\n"
    "Tap to recenter a position.\n"
    "Double Tap to recenter and zoom in.\n"
    ;
}

- (IBAction)closeInfo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
