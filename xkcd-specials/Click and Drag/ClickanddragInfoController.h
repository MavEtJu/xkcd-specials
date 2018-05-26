//
//  InfoViewController.h
//  xkcd-clickanddrag
//
//  Created by Edwin Groothuis on 25/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickanddragInfoController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelUsage;

- (IBAction)closeInfo:(id)sender;

@end
