//
//  ViewController.m
//  xkcd-clickanddrag
//
//  Created by Edwin Groothuis on 23/5/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import "ClickanddragController.h"

@interface ClickanddragController ()

@property (nonatomic, retain) NSArray<NSArray<UIImageView *> *> *imageViews;
@property (nonatomic, retain) NSArray<NSString *> *tileNames;
@property (nonatomic        ) CGFloat zoomLevel;
@property (nonatomic        ) NSArray<NSString *> *introImages;
@property (nonatomic, retain) NSOperationQueue *introQueue;

@end

@implementation ClickanddragController

#define WIDTH 81
#define HEIGHT 32
#define WEST 33
#define EAST 48
#define NORTH 13
#define SOUTH 19

#define BOXSIZE 2048

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.introImages = @[
        [NSString stringWithFormat:@"%@/Images - Click and Drag/Click-1.png", [[NSBundle mainBundle] resourcePath]],
        [NSString stringWithFormat:@"%@/Images - Click and Drag/Click-2.png", [[NSBundle mainBundle] resourcePath]],
        [NSString stringWithFormat:@"%@/Images - Click and Drag/Click-3.png", [[NSBundle mainBundle] resourcePath]],
    ];

    self.introQueue = [[NSOperationQueue alloc] init];
    [self.introQueue addOperationWithBlock:^{
        [self viewLoadIntro:0];
        [NSThread sleepForTimeInterval:2];
        [self viewLoadIntro:1];
        [NSThread sleepForTimeInterval:2];
        [self viewLoadIntro:2];
        [NSThread sleepForTimeInterval:2];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.introImage.hidden = YES;
            [self viewLoadScrollView];
        }];
    }];
}

- (void)viewLoadIntro:(NSInteger)intro
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.introImage.image = [UIImage imageWithContentsOfFile:[self.introImages objectAtIndex:intro]];
    }];
}


- (void)viewLoadScrollView
{
    NSMutableArray<NSMutableArray *> *imageViews = [NSMutableArray arrayWithCapacity:(NORTH + SOUTH)];
    [self initTiles];

    self.zoomLevel = 1;
    self.sliderZoomLevel.value = 0.5;
    self.scrollview.delegate = self;

    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];

    for (NSInteger lat = -NORTH; lat < SOUTH; lat++) {
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:(EAST + WEST)];

        for (NSInteger lon = -WEST; lon < EAST; lon++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
            iv.backgroundColor = lat < 0 ? [UIColor whiteColor] : [UIColor blackColor];
            [self.scrollview addSubview:iv];
            [views addObject:iv];
        }
        [imageViews addObject:views];
    }
    self.imageViews = imageViews;
    [self adjustTiles];

    self.scrollview.contentOffset = CGPointMake(WEST * BOXSIZE, (NORTH - 1) * BOXSIZE + BOXSIZE / 2);
}

- (void)adjustTiles
{
    NSInteger oldSize = self.scrollview.contentSize.width;
    CGPoint oldOffset = self.scrollview.contentOffset;

    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGSize size = bounds.size;

    [self.imageViews enumerateObjectsUsingBlock:^(NSArray<UIImageView *> * _Nonnull ivs, NSUInteger outidx, BOOL * _Nonnull stop) {
        [ivs enumerateObjectsUsingBlock:^(UIImageView * _Nonnull iv, NSUInteger inidx, BOOL * _Nonnull stop) {
            iv.frame = CGRectMake(self.zoomLevel * inidx * BOXSIZE, self.zoomLevel * outidx * BOXSIZE, self.zoomLevel * BOXSIZE, self.zoomLevel * BOXSIZE);
        }];
    }];
    self.scrollview.contentSize = CGSizeMake(self.zoomLevel * (EAST + WEST) * BOXSIZE, self.zoomLevel * (NORTH + SOUTH) * BOXSIZE);

    NSInteger newSize = self.scrollview.contentSize.width;

    if (oldSize == 0) {
        self.scrollview.contentOffset = CGPointMake(WEST * BOXSIZE, (NORTH - 1) * BOXSIZE + BOXSIZE / 2);
    } else {
        CGFloat ratio = 1.0 * newSize / oldSize;
        self.scrollview.contentOffset = CGPointMake((oldOffset.x + size.width / 2) * ratio - size.width / 2, (oldOffset.y + size.height / 2) * ratio - size.height / 2);
    }

    if (self.zoomLevel >= 1)
        self.labelZoomLevel.text = [NSString stringWithFormat:@"%0.0f x", self.zoomLevel];
    else if (self.zoomLevel > 0.4)
        self.labelZoomLevel.text = [NSString stringWithFormat:@"%0.1f x", self.zoomLevel];
    else if (self.zoomLevel > 0.2)
        self.labelZoomLevel.text = [NSString stringWithFormat:@"%0.2f x", self.zoomLevel];
    else if (self.zoomLevel > 0.0)
        self.labelZoomLevel.text = [NSString stringWithFormat:@"%0.3f x", self.zoomLevel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGSize size = bounds.size;

    // Adjust colours of scroll bars
    UIImageView *verticalIndicator = ((UIImageView *)[scrollView.subviews objectAtIndex:(scrollView.subviews.count-1)]);
    [verticalIndicator setBackgroundColor:[UIColor redColor]];

    UIImageView *horizontalIndicator = ((UIImageView *)[scrollView.subviews objectAtIndex:(scrollView.subviews.count-2)]);
    [horizontalIndicator setBackgroundColor:[UIColor redColor]];

    // Keep track of which images we already have
    NSMutableArray<UIImageView *> *alreadyloaded = [NSMutableArray arrayWithCapacity:9];
    [self.imageViews enumerateObjectsUsingBlock:^(NSArray<UIImageView *> * _Nonnull ivs, NSUInteger idx, BOOL * _Nonnull stop) {
        [ivs enumerateObjectsUsingBlock:^(UIImageView * _Nonnull iv, NSUInteger idx, BOOL * _Nonnull stop) {
            if (iv.image != nil)
                [alreadyloaded addObject:iv];
        }];
    }];

    // Load what is needed (more or less)
    NSInteger svlat = (self.scrollview.contentOffset.y - self.zoomLevel * NORTH * BOXSIZE) / (self.zoomLevel * BOXSIZE);
    NSInteger svlon = (self.scrollview.contentOffset.x - self.zoomLevel * WEST * BOXSIZE) / (self.zoomLevel * BOXSIZE);
    NSInteger blocksLat = size.height / (self.zoomLevel * BOXSIZE) + 1;
    NSInteger blocksLon = size.width / (self.zoomLevel * BOXSIZE) + 1;
    for (NSInteger lon = svlon - 1; lon < svlon + blocksLon + 1; lon++) {
        for (NSInteger lat = svlat - 1; lat < svlat + blocksLat + 1; lat++) {
            if (NORTH + lat < 0 || NORTH + lat >= [self.imageViews count])
                continue;
            NSArray *ivs = [self.imageViews objectAtIndex:NORTH + lat];
            if (WEST + lon < 0 || WEST + lon >= [ivs count])
                continue;
            UIImageView *iv = [ivs objectAtIndex:WEST + lon];
            if (iv.image == nil)
                iv.image = [[UIImage alloc] initWithContentsOfFile:[self tilePath:lat lon:lon]];

            [alreadyloaded removeObject:iv];
        }
    }

    // Discard what is not needed
    [alreadyloaded enumerateObjectsUsingBlock:^(UIImageView  * _Nonnull iv, NSUInteger idx, BOOL * _Nonnull stop) {
        iv.image = nil;
    }];
}

- (IBAction)moveSlider:(UISlider *)slider
{
    NSInteger i = slider.value * 5;

    switch (i) {
        case 0:
            self.zoomLevel = 0.25;
            break;
        case 1:
            self.zoomLevel = 0.5;
            break;
        case 2:
            self.zoomLevel = 1;
            break;
        case 3:
            self.zoomLevel = 2;
            break;
        case 4:
            self.zoomLevel = 3;
            break;
        case 5:
            self.zoomLevel = 4;
            break;
    }
    [self adjustTiles];
}

- (IBAction)singleTap:(UITapGestureRecognizer *)gesture
{
    // Just relocate
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGSize size = bounds.size;

    CGPoint touchPoint = [gesture locationInView:self.scrollview];

    // Do not react to a tap on the slider.
    CGPoint point = [self.scrollview convertPoint:touchPoint toView:self.view];
    if (self.sliderZoomLevel.frame.origin.x < point.x &&
        point.x < self.sliderZoomLevel.frame.origin.x + 3 * self.sliderZoomLevel.frame.size.width &&
        self.sliderZoomLevel.frame.origin.y < point.y &&
        point.y < self.sliderZoomLevel.frame.origin.y + 3 * self.sliderZoomLevel.frame.size.height)
        return;

    [self.scrollview setContentOffset:CGPointMake(touchPoint.x - size.width / 2, touchPoint.y - size.height / 2) animated:TRUE];
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)gesture
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGSize size = bounds.size;

    [UIView animateWithDuration:0.5 animations:^{
        // First zoom in
        if (self.zoomLevel < 1) {
            self.zoomLevel *= 2;
        } else if (self.zoomLevel < 4) {
            self.zoomLevel++;
        }

        if (self.zoomLevel >= 1)
            self.sliderZoomLevel.value = (self.zoomLevel + 1) / 5.0;
        else
            self.sliderZoomLevel.value = (self.zoomLevel * 4 - 1) / 5.0;

        // them move to the right place
        CGPoint touchPoint = [gesture locationInView:self.scrollview];
        [self.scrollview setContentOffset:CGPointMake(touchPoint.x - size.width / 2, touchPoint.y - size.height / 2) animated:FALSE];

        // And update the size
        [self adjustTiles];
    }];
}

- (IBAction)zoomGesture:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"zoomGesture");
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.scale > 1) {    // Zoom in
            if (self.zoomLevel < 1) {
                self.zoomLevel *= 2;
            } else if (self.zoomLevel < 4) {
                self.zoomLevel++;
            }
        } else {                    // Zoom out
            if (self.zoomLevel > 1) {
                self.zoomLevel--;
            } else if (self.zoomLevel > 0.4) {
                self.zoomLevel /= 2;
            }
        }

        if (self.zoomLevel >= 1)
            self.sliderZoomLevel.value = (self.zoomLevel + 1) / 5.0;
        else
            self.sliderZoomLevel.value = (self.zoomLevel * 4 - 1) / 5.0;

        [self adjustTiles];
    }
}

- (void)initTiles
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *dirname = [NSString stringWithFormat:@"%@/Images - Click and Drag", [[NSBundle mainBundle] resourcePath]];
    self.tileNames = [fm contentsOfDirectoryAtPath:dirname error:nil];
}

- (NSString *)tilePath:(NSInteger)lat lon:(NSInteger)lon
{
    NSString *filename = [NSString stringWithFormat:@"%ld%@%ld%@.png", lat < 0 ? -lat : lat + 1, lat < 0 ? @"n" : @"s", lon < 0 ? -lon : lon + 1, lon < 0 ? @"w" : @"e"];
    if ([self.tileNames containsObject:filename] == YES)
        return [NSString stringWithFormat:@"%@/Images - Click and Drag/%@", [[NSBundle mainBundle] resourcePath], filename];
    return nil;
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
