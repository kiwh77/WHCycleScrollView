//
//  WHCycleScrollView.h
//  WHForeverScrollView
//
//  Created by 吴浩 on 15/11/2.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WHCycleScrollView;
typedef NS_ENUM(NSInteger, WHPageControlLocation ){
    WHPageControlLocationLeft,      //left
    WHPageControlLocationCenter,    // center
    WHPageControlLocationRight,     //right
};

typedef NS_ENUM(NSInteger, WHCycleDirection){
    WHCycleDirectionRight,
    WHCycleDirectionLeft,
};

@protocol WHCycleScrollViewDelegate <NSObject>

/** tap gesture action */
-(void)CycleScrollView:(nonnull WHCycleScrollView*)cycleScrollView didTapAtIndex:(NSInteger)index;

/** LongPress gesture action */
-(void)CycleScrollView:(nonnull WHCycleScrollView *)cycleScrollView longPressAtIndex:(NSInteger)index;

@end

@interface WHCycleScrollView : UIView<UIScrollViewDelegate>

/*
 * The data source of scrollView,element is NSURL or NSString(Local image name)
 */
@property (nonnull, nonatomic, strong) NSArray * dataSource;

/** If dataSource's element is NSURL , When loading image to show placeholder image */
@property (nullable, nonatomic, strong) UIImage * placeholderImage;

/**
 * If want have pageControl, Set YES
 */
@property (nonatomic, assign) BOOL needPageControl;   //default is NO

@property (nonatomic, assign) WHPageControlLocation pageControlType;  //default is WHPageControlLocationCenter

/**
 * Properties of UIPageControl
 */
@property (nullable, nonatomic, strong) UIColor * pageIndicatorTintColor;
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor;
/**
 * If want auto cycle , Set YES.
 * Set cycle interval @see autoCycleInterval
 */
@property (nonatomic, assign) BOOL needAutoCycle;     //default is NO

@property (nonatomic, assign) NSTimeInterval autoCycleInterval;  //default is 5.0f

@property (nonatomic, assign) WHCycleDirection cycleDirection;  //default is right

/** 
 * TapGesture actino callBack
 */
@property (nullable, nonatomic, copy) void (^tapAction)(NSInteger index);

/** 
 * LongPressGesture action callBack
 */
@property (nullable, nonatomic, copy) void (^longPressAction)(NSInteger index);

@property (nonatomic, weak) id<WHCycleScrollViewDelegate> delegate;


+(nonnull instancetype)cycleScrollViewWithFrame:(CGRect)frame dataSource:(nonnull NSArray*)dataSource pageControl:(BOOL)yesOrNo autoCycle:(BOOL)yesOrNo;

@end
