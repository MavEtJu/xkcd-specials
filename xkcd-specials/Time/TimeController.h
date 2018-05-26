//
//  ViewController.h
//  xkcd-time
//
//  Created by Edwin Groothuis on 23/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UIImageView *imgview;
@property (nonatomic, retain) IBOutlet UIButton *buttonForward;
@property (nonatomic, retain) IBOutlet UIButton *buttonPausePlay;
@property (nonatomic, retain) IBOutlet UIButton *buttonBackward;
@property (nonatomic, retain) IBOutlet UILabel *labelRight;
@property (nonatomic, retain) IBOutlet UILabel *labelLeft;

- (IBAction)closeView:(id)sender;
- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)buttonStop:(UIButton *)sender;
- (IBAction)buttonForward:(UIButton *)sender;
- (IBAction)buttonBackward:(UIButton *)sender;
- (IBAction)swipeLeft:(UIGestureRecognizer *)sender;
- (IBAction)swipeRight:(UIGestureRecognizer *)sender;
- (IBAction)tapToStop:(UIGestureRecognizer *)sender;
- (IBAction)doubleTapToStart:(UIGestureRecognizer *)sender;

@end

