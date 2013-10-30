//
//  motionImgView.h
//  xhMotionWithPlist
//
//  Created by Xiaohe Hu on 10/30/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Motion.h"

@interface motionImgView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{

    NSArray         *arr_imgs;
    NSArray         *arr_offsets;
    NSDictionary    *dict_data;
    UIScrollView    *uis_scrView;
    UIImageView     *uiiv_imgLayers;
}

@property (nonatomic, readwrite) BOOL motionEnable;
@property (nonatomic, readwrite) BOOL zoomingEnable;

- (id)initWithFrame:(CGRect)frame andDataDict:(NSDictionary*)dictData;
@end
