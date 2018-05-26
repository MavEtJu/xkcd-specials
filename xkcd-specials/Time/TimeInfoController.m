//
//  InfoController.m
//  xkcd-time
//
//  Created by Edwin Groothuis on 23/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "TimeInfoController.h"

@interface TimeInfoController ()

@end

@implementation TimeInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labelTitle.text = @"XKCD - TIME";
    self.labelAboutXkcd.text = @"xkcd is licensed by Randall Munroe under a Creative Commons Attribution-NonCommercial 2.5 License.\nYou can find all his work at http://xkcd.com/";
    self.labelAboutApp.text = @"This app is made by Edwin Groothuis.\nThe source can be found at https://github.com/MavEtJu/xkcd-time/";
    self.labelUsage.text = @"Press the backward, pause and forward button to play automatically.\nSwipe left and right to go forward one by one frame.\nTap to stop, tap to go one further. Double tap to play again.";
}

- (IBAction)closeInfo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
