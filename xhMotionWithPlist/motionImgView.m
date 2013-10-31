//
//  motionImgView.m
//  xhMotionWithPlist
//
//  Created by Xiaohe Hu on 10/30/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import "motionImgView.h"

//static CGFloat kMinZoom = 1.0;
static CGFloat kMaxZoom = 2.0;
@implementation motionImgView

@synthesize motionEnable, zoomingEnable;

- (id)initWithFrame:(CGRect)frame andDataDict:(NSDictionary*)dictData
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dict_data = dictData;
        [self initImg];
    }
    return self;
}
#pragma mark - Set 2 Bool value: ZoomingEnable and MotionEnable
-(void)setZoomingEnable:(BOOL)zooming
{
    zoomingEnable = zooming;
    [self initImg];
}
-(void)setMotionEnable:(BOOL)motion
{
    motionEnable = motion;
    [self initImg];
}

#pragma mark - Init the view with data
-(void)initImg
{
    [uis_scrView removeFromSuperview];
    uiv_imgLayers = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    uiv_imgLayers.clipsToBounds = NO;
    [self loadData];
    [self readAndSetData];
    [self addSubview:uis_scrView];
}

#pragma mark - Get data from Dictionary
-(void)loadData
{
    arr_offsets = [[NSArray alloc] initWithArray:[dict_data objectForKey:@"offsets"]];
    arr_imgs = [[NSArray alloc] initWithArray:[dict_data objectForKey:@"images"]];
}
//Get different image layers from array and set to a UIImageView (container)
//Add the container to UIScrollView
-(void)readAndSetData
{
    [self initScrView];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0)
    {
        for (int i = 0; i < [arr_imgs count]; i++)
        {
            NSString *imgName = [arr_imgs objectAtIndex:i];
            float offset = [[arr_offsets objectAtIndex:i] floatValue];
            UIImageView *motionImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
            motionImg.frame = CGRectMake(-20.0f, -20.0f, self.frame.size.width + 40, self.frame.size.height + 40);
            [uiv_imgLayers insertSubview:motionImg atIndex:i];
            
            if (motionEnable == YES) {
                [motionImg addMotionEffects:offset];
            }
        }
    }
    else
    {
        for (int i = 0; i < [arr_imgs count]; i++)
        {
            NSString *imgName = [arr_imgs objectAtIndex:i];
            UIImageView *motionImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
            motionImg.frame = CGRectMake(-20.0f, -20.0f, self.frame.size.width + 40, self.frame.size.height + 40);
            [uiv_imgLayers insertSubview:motionImg atIndex:i];
        }

    }
    
    [uis_scrView addSubview:uiv_imgLayers];
}
#pragma mark - Init ScrView
//Init UIScrollView and turn on/off zooming function
-(void)initScrView
{
    uis_scrView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    uis_scrView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    uis_scrView.clipsToBounds = YES;
    uis_scrView.delegate = self;
    uis_scrView.scrollEnabled = YES;
    uis_scrView.pagingEnabled = NO;
    if (zoomingEnable == YES) {
        uis_scrView.maximumZoomScale = 4.0;
        uis_scrView.minimumZoomScale = 1.0;
        
        // add doubletap for zooming
        UITapGestureRecognizer *tapDblRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMyPlan:)];
        [tapDblRecognizer setNumberOfTapsRequired:2];
        [tapDblRecognizer setDelegate:self];
        [uis_scrView addGestureRecognizer:tapDblRecognizer];
    }
    else
    {
        uis_scrView.maximumZoomScale = 1.0;
        uis_scrView.minimumZoomScale = 1.0;
    }

}

#pragma mark Scroll DoubleTap
-(void)zoomMyPlan:(UITapGestureRecognizer *)sender {
	
	// 1 determine which to zoom
	UIScrollView *tmp;
	tmp = uis_scrView;
	
	if (tmp == uis_scrView) {
		CGPoint pointInView = [sender locationInView:tmp];
		
		// 2
		CGFloat newZoomScale = tmp.zoomScale * kMaxZoom;
		newZoomScale = MIN(newZoomScale, tmp.maximumZoomScale);
		
		// 3
		CGSize scrollViewSize = tmp.bounds.size;
		
		CGFloat w = scrollViewSize.width / newZoomScale;
		CGFloat h = scrollViewSize.height / newZoomScale;
		CGFloat x = pointInView.x - (w / kMaxZoom);
		CGFloat y = pointInView.y - (h / kMaxZoom);
		CGRect rectToZoomTo = CGRectMake(x, y, w, h);
		
		// 4
		if (tmp.zoomScale >= kMaxZoom-.01) {		// sets midpoint for zooming back the other way
			[tmp setZoomScale: 1.0 animated:YES];
			
		} else if (tmp.zoomScale < kMaxZoom) {
			[tmp zoomToRect:rectToZoomTo animated:YES];
		}
	}
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return uiv_imgLayers;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
