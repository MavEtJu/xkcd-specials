//
//  InfoController.m
//  xkcd-specials
//
//  Created by Edwin Groothuis on 26/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "InfoController.h"

@interface InfoController ()

@end

@implementation InfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.labelTitle.text = @"XKCD";
    self.labelAboutXkcd.text = @"xkcd is licensed by Randall Munroe under a Creative Commons Attribution-NonCommercial 2.5 License.\nYou can find all his work at http://xkcd.com/";
    self.labelAboutApp.text = @"This app is made by Edwin Groothuis.\nThe source can be found at https://github.com/MavEtJu/xkcd-time/";
}

- (IBAction)closeInfo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
