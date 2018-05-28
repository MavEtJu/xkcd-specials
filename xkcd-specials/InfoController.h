//
//  InfoController.h
//  xkcd-specials
//
//  Created by Edwin Groothuis on 26/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelAboutXkcd;
@property (nonatomic, retain) IBOutlet UILabel *labelIntroduction;
@property (nonatomic, retain) IBOutlet UILabel *labelAboutApp;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;

- (IBAction)closeInfo:(id)sender;

@end
