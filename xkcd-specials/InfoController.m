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
    self.labelIntroduction.text =
        @"\"Time\" is a 3099 picture comic strip. Set 11,000 years in the future in the basin of the Mediterranean Sea during a supposed recurrence of the Zanclean flood, features two characters journeying up-hill in order to discover where the rising water is originating from. By the end of the story, the characters return home in order to save their people.\n\n"
        "\"Click and Drag\" featured a panel which can be explored via dragging the image. The large image nested in the panel measures 165,888 pixels wide by 79,822 pixels high.";
    self.labelAboutXkcd.text = @"xkcd is licensed by Randall Munroe under a Creative Commons Attribution-NonCommercial 2.5 License.\nYou can find all his work at http://xkcd.com/";
    self.labelAboutApp.text = @"This app \"xkcd: Specials\" is made by Edwin Groothuis <xkcd-specials@mavetju.org>\nThe source can be found at https://github.com/MavEtJu/xkcd-time/";
}

- (IBAction)closeInfo:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
