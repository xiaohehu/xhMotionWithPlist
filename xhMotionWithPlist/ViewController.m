//
//  ViewController.m
//  xhMotionWithPlist
//
//  Created by Xiaohe Hu on 10/29/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSDictionary  *dict_motionData;
@property (nonatomic, strong) motionImgView *motionImg;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

	// Do any additional setup after loading the view, typically from a nib.
    [self loadData];
    
    _motionImg = [[motionImgView alloc] initWithFrame:self.view.frame andDataDict:_dict_motionData];
    [_motionImg setMotionEnable:YES];
    [_motionImg setZoomingEnable:YES];
    [self.view addSubview:_motionImg];

     
}

-(void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"motionImgs" ofType:@"plist"];
    _dict_motionData = [[NSDictionary alloc] initWithContentsOfFile:path];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
