//
//  InfoController.h
//  xkcd-time
//
//  Created by Edwin Groothuis on 23/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeInfoController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *labelAboutXkcd;
@property (nonatomic, retain) IBOutlet UILabel *labelAboutApp;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel *labelUsage;

- (IBAction)closeInfo:(id)sender;

@end
