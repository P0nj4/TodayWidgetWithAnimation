//
//  TodayViewController.m
//  theWidget
//
//  Created by German Pereyra on 5/25/15.
//  Copyright (c) 2015 German Pereyra. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *lblNewsText;
@property (weak, nonatomic) IBOutlet UIButton *btnInfoButton;
- (IBAction)btnInfoButtonPressed:(id)sender;

@property (nonatomic) BOOL first;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView.layer.cornerRadius = 8;
    self.containerView.clipsToBounds = YES;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.textBackgroundView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.textBackgroundView addSubview:blurEffectView];
    self.textBackgroundView.alpha = 0.3;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

-(void)viewWillTransitionToSize:(CGSize)size
      withTransitionCoordinator:
(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.containerView setAlpha:1.0];
     } completion:nil];
}

- (IBAction)btnShowNextPressed:(id)sender {
    UIGraphicsBeginImageContext(self.containerView.frame.size);
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.containerView.frame];
    imgView.frame = CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
    imgView.image = screenShot;
    imgView.hidden = NO;
    imgView.alpha = 1;
    [self.view addSubview:imgView];
    
    UIView *overlayView = [[UIView alloc] initWithFrame:imgView.frame];
    overlayView.layer.cornerRadius = self.containerView.layer.cornerRadius;
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.alpha = 0;
    [self.view addSubview:overlayView];
    self.containerView.alpha = 0;

    if (!self.first) {
        self.imageView.image = [UIImage imageNamed:@"corky2.jpg"];
        self.lblNewsText.text = @"En condición crítica, pero estable, hijo del baloncelista Andrés Ortiz";
    } else {
        self.imageView.image = [UIImage imageNamed:@"guardia_1.jpg"];
        self.lblNewsText.text = @"El conductor fue transportado al Centro Médico de Río Piedras en condición grave, informó la Policía.  (Suministrada)";
    }
    self.first = !self.first;
    
    [UIView animateWithDuration:0.6 animations:^{
        overlayView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.containerView.transform = CGAffineTransformIdentity;
            self.containerView.alpha = 1;
            imgView.frame = CGRectMake(self.view.frame.size.width, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height);
            overlayView.frame = imgView.frame;
        } completion:^(BOOL finished){
            [imgView removeFromSuperview];
        }];
    }];
    
}
- (IBAction)btnInfoButtonPressed:(id)sender {
}
@end
