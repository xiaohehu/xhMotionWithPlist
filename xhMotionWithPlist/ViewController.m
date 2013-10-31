//
//  ViewController.m
//  xhMotionWithPlist
//
//  Created by Xiaohe Hu on 10/29/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray           *arr_motionData;
@property (nonatomic, strong) UIPageControl     *uis_pageContorlDots;
@property (nonatomic, strong) NSMutableArray    *arr_motionImgArray;
@property (nonatomic, strong) UIScrollView      *uis_bigScrView;

@property (nonatomic, strong) motionImgView     *motionImg;
@property (nonatomic, strong) motionImgView     *motionImg1;
@property (nonatomic, strong) motionImgView     *motionImg2;
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
    [self addMotionImgToArray];
    [self addMotionImgToBigScrView];
}

-(void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"motionImgs" ofType:@"plist"];
    _arr_motionData = [[NSArray alloc] initWithContentsOfFile:path];
}

-(void)addMotionImgToArray
{
    _arr_motionImgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _arr_motionData.count; i++) {
        _motionImg = [[motionImgView alloc] initWithFrame:self.view.frame andDataDict:[_arr_motionData objectAtIndex:i]];
        if (i==0)
        {
            [_motionImg setMotionEnable:NO];
            [_motionImg setZoomingEnable:NO];
        }
        if (i==1)
        {
            [_motionImg setMotionEnable:NO];
            [_motionImg setZoomingEnable:YES];
        }
        if (i==2)
        {
            [_motionImg setMotionEnable:YES];
            [_motionImg setZoomingEnable:YES];
        }
        [_arr_motionImgArray addObject:_motionImg];

    }
    NSLog(@"aaaaaaaaaaa %@", [_arr_motionImgArray description]);
}

-(void)addMotionImgToBigScrView
{
    _uis_bigScrView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
    //_uis_bigScrView.clipsToBounds = YES;
    _uis_bigScrView.delegate = self;
    _uis_bigScrView.scrollEnabled = YES;
    _uis_bigScrView.pagingEnabled = YES;
    [_uis_bigScrView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_uis_bigScrView];
    _uis_bigScrView.contentSize = CGSizeMake(_uis_bigScrView.frame.size.width*_arr_motionImgArray.count, _uis_bigScrView.frame.size.height);
    
    for (motionImgView *tmp in _arr_motionImgArray) {
        CGFloat x = [_arr_motionImgArray indexOfObject:tmp] * _uis_bigScrView.frame.size.width;
        tmp.frame = CGRectMake(x, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        [_uis_bigScrView addSubview: tmp];
    }
    _uis_pageContorlDots = [[UIPageControl alloc] initWithFrame:CGRectMake(412, 700, 200, 50)];
    [_uis_pageContorlDots setNumberOfPages:_arr_motionImgArray.count];
    [_uis_pageContorlDots setCurrentPage:0];
    [_uis_pageContorlDots setBackgroundColor:[UIColor clearColor]];
    [_uis_pageContorlDots addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: _uis_pageContorlDots];
}
-(IBAction)changePage:(id)sender {
    UIPageControl *pager=sender;
    int page = (int)pager.currentPage;
    CGRect frame = _uis_bigScrView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_uis_bigScrView scrollRectToVisible:frame animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int newOffset = scrollView.contentOffset.x;
    int newPage = (int)(newOffset/(scrollView.frame.size.width));
    [_uis_pageContorlDots setCurrentPage:newPage];

    NSLog(@"Trying to change the scale of contents");
    for (motionImgView *tmp in scrollView.subviews) {
        for (UIScrollView *tmpScr in tmp.subviews) {
            [tmpScr setZoomScale:1.0 animated:NO];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    for (UIView *view in scrollView.subviews) {
//        if([view isKindOfClass:[UIScrollView class]]) {
//            [(UIScrollView*)view setZoomScale:1.0 animated:NO];
//        }
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
