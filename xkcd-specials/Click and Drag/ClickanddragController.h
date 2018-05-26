//
//  ViewController.h
//  xkcd-clickanddrag
//
//  Created by Edwin Groothuis on 23/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClickanddragController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UILabel *labelZoomLevel;
@property (nonatomic, retain) IBOutlet UISlider *sliderZoomLevel;

- (IBAction)moveSlider:(UISlider *)slider;
- (IBAction)doubleTap:(UITapGestureRecognizer *)gesture;

@end

