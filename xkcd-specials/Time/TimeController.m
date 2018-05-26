//
//  ViewController.m
//  xkcd-time
//
//  Created by Edwin Groothuis on 23/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "TimeController.h"

typedef NS_ENUM(NSInteger, Direction) {
    DIRECTION_PAUSE,
    DIRECTION_FORWARD,
    DIRECTION_BACKWARD,
};

@interface TimeController ()

@property (nonatomic        ) NSInteger imgnumber;
@property (nonatomic        ) NSInteger delayValue;
@property (nonatomic        ) NSArray<NSString *> *images;

@end

@implementation TimeController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imgnumber = 0;
    self.delayValue = 1;
    [self loadImages];
    [self loadCurrentPicture];
    [self showDelayValue];

    [self performSelectorInBackground:@selector(playLoop) withObject:nil];
}

- (void)playLoop
{
    while (1) {
        if (self.delayValue == 0) {
            [NSThread sleepForTimeInterval:0.5];
            continue;
        }
        if (self.delayValue > 0) {
            @synchronized (self) {
                if (self.imgnumber == [self.images count] - 1)
                    continue;
                self.imgnumber++;
            }
        } else if (self.delayValue < 0) {
            @synchronized (self) {
                if (self.imgnumber == 0)
                    continue;
                self.imgnumber--;
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self loadCurrentPicture];
        }];
//        NSLog(@"Sleeping for %f seconds", [self delay]);
        [NSThread sleepForTimeInterval:[self delay]];
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    @synchronized (self) {
        self.imgnumber = ([self.images count] - 1) * sender.value;
    }
    [self loadCurrentPicture];
}

- (IBAction)buttonStop:(UIButton *)sender
{
    self.delayValue = 0;
    [self showDelayValue];
}

- (IBAction)buttonForward:(UIButton *)sender
{
    self.delayValue++;
    [self showDelayValue];
}

- (IBAction)buttonBackward:(UIButton *)sender
{
    self.delayValue--;
    [self showDelayValue];
}

- (IBAction)swipeLeft:(UIGestureRecognizer *)sender
{
    @synchronized (self) {
        if (self.imgnumber == [self.images count] - 1)
            return;
        self.imgnumber++;
    }
    [self loadCurrentPicture];
    [self showDelayValue];
}

- (IBAction)swipeRight:(UIGestureRecognizer *)sender
{
    self.delayValue = 0;
    @synchronized (self) {
        if (self.imgnumber == 0)
            return;
        self.imgnumber--;
    }
    [self loadCurrentPicture];
    [self showDelayValue];
}

- (IBAction)tapToStop:(UIGestureRecognizer *)sender
{
    if (self.delayValue != 0) {
        self.delayValue = 0;
        return;
    }
    @synchronized (self) {
        if (self.imgnumber == [self.images count] - 1)
            return;
        self.imgnumber++;
    }
    [self loadCurrentPicture];
    [self showDelayValue];
}

- (IBAction)doubleTapToStart:(UIGestureRecognizer *)sender
{
    if (self.delayValue != 0)
        return;
    @synchronized (self) {
        self.delayValue = 1;
        [self showDelayValue];
    }
}

- (void)loadCurrentPicture
{
//    NSLog(@"imgnumber: %ld", self.imgnumber);
    UIImage *img = [UIImage imageNamed:[self imagePath:[self.images objectAtIndex:self.imgnumber]]];
    self.imgview.image = img;
    self.slider.value = 1.0 * self.imgnumber / ([self.images count] - 1);

    self.labelLeft.text = [NSString stringWithFormat:@"%ld / %ld", self.imgnumber + 1, [self.images count]];
}

- (void)showDelayValue
{
    if (self.delayValue == 0)
        self.labelRight.text = @"Paused";
    else if (self.delayValue > 0)
        self.labelRight.text = [NSString stringWithFormat:@"%ldx >", self.delayValue];
    else
        self.labelRight.text = [NSString stringWithFormat:@"%ldx <", -self.delayValue];
}

- (NSString *)imagePath:(NSString *)file
{
    return [NSString stringWithFormat:@"%@/Images - Time/%@", [[NSBundle mainBundle] resourcePath], file];
}

- (CGFloat)delay
{
    if (self.delayValue == 0)
        return 2;
    return 1.0 / labs(self.delayValue);
}

- (void)loadImages
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    self.images = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Images - Time", [[NSBundle mainBundle] resourcePath]] error:nil];
    self.images = [self.images sortedArrayUsingSelector:@selector(compare:)];
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
