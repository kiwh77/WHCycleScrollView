//
//  WHCycleScrollView.m
//  WHForeverScrollView
//
//  Created by 吴浩 on 15/11/2.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import "WHCycleScrollView.h"
#import "UIImageView+WebCache.h"

#define WIDTH_WH CGRectGetWidth(self.frame)
#define HEIGHT_WH CGRectGetHeight(self.frame)

#define totalImageCount 3
#define Space_bottom 16

#define DefaultAutoCycleInterval 5.0f
#define MinAutoCyleInterval 0.35f

typedef enum : NSUInteger {
    GestureTypeTap = 1,
    GestureTypeLongPress = 2,
} GestureType;

@interface WHCycleScrollView()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@end

@implementation WHCycleScrollView
{
    NSMutableArray * imageViews;
    NSInteger totalPageCount;
    NSInteger currentIndex;
    
    NSTimer * timer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

+(instancetype)cycleScrollViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource pageControl:(BOOL)needPageControl autoCycle:(BOOL)needAutoCycle
{
    WHCycleScrollView * cycleScrollView = [[[self class] alloc] initWithFrame:frame];
    [cycleScrollView setDataSource:dataSource];
    cycleScrollView.needPageControl = needPageControl;
    cycleScrollView.needAutoCycle = needAutoCycle;
    return cycleScrollView;
}

-(void)setup
{
    [self addSubview:self.scrollView];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timer invalidate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_needAutoCycle && timer) {
        [self setupTimer];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x >= WIDTH_WH*2){
        currentIndex = [self validIndex:currentIndex+1];
        if (_needPageControl && _pageControl) {
            _pageControl.currentPage = currentIndex;
        }
        [self reloadImageViews];
    }else if(offset.x <= 0){
        currentIndex = [self validIndex:currentIndex-1];
        if (_needPageControl && _pageControl) {
            _pageControl.currentPage = currentIndex;
        }
        [self reloadImageViews];
    }
}


#pragma mark - Action

//初始化视图
-(void)setupContentView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    imageViews = [NSMutableArray array];
    
    NSArray * indexs = [self getTotalIndexs];
    NSInteger forIndex = 0;
    for (NSNumber * index in indexs) {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(forIndex++*WIDTH_WH, 0, WIDTH_WH, HEIGHT_WH)];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        id data = [_dataSource objectAtIndex:index.integerValue];
        if ([data isKindOfClass:[NSURL class]]) {
            if (_placeholderImage) {
                [iv sd_setImageWithURL:data placeholderImage:_placeholderImage];
            }else{
                [iv sd_setImageWithURL:data];
            }
        }else if([data isKindOfClass:[NSString class]]){
            [iv setImage:[UIImage imageNamed:data]];
        }
        [imageViews addObject:iv];
        [_scrollView addSubview:iv];
    }
    
    if (_dataSource.count>2) {
        [_scrollView setContentOffset:CGPointMake(WIDTH_WH, 0) animated:NO];
    }
}


-(void)reloadImageViews
{
    NSArray * indexs = [self getTotalIndexs];
    for (int i=0; i<imageViews.count; i++) {
        UIImageView * iv = [imageViews objectAtIndex:i];
        [iv setContentMode:UIViewContentModeScaleToFill];
        NSInteger index = [[indexs objectAtIndex:i] integerValue];
        id data = [_dataSource objectAtIndex:index];
        if ([data isKindOfClass:[NSURL class]]) {
            if (_placeholderImage) {
                [iv sd_setImageWithURL:data placeholderImage:_placeholderImage];
            }else{
                [iv sd_setImageWithURL:data];
            }
        }else if([data isKindOfClass:[NSString class]]){
            [iv setImage:[UIImage imageNamed:data]];
        }
    }
    
    if (_dataSource.count > 1) {
        [_scrollView setContentOffset:CGPointMake(WIDTH_WH, 0) animated:NO];
    }
}


/** 获取对应数据源下标 */
-(NSArray*)getTotalIndexs
{
    return @[@([self validIndex:currentIndex-1]),@([self validIndex:currentIndex]),@([self validIndex:currentIndex+1])];
}

-(NSInteger)validIndex:(NSInteger)index
{
    if (index == _dataSource.count) {
        return 0;
    }else if(index == -1){
        return _dataSource.count-1;
    }else{
        return index;
    }
}

-(void)setupTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:_autoCycleInterval target:self selector:@selector(autoCycleAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)autoCycleAction:(NSTimer*)theTimer
{
    CGFloat offsetX = _cycleDirection == WHCycleDirectionLeft ? 0 : WIDTH_WH*2;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

-(void)setupTapGesture
{
    [imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * iv = obj;
        iv.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView)];
        [iv addGestureRecognizer:tap];
    }];
}

-(void)didTapImageView
{
    if (_delegate && [_delegate respondsToSelector:@selector(CycleScrollView:didTapAtIndex:)]) {
        [_delegate CycleScrollView:self didTapAtIndex:currentIndex];
    }
    if (_tapAction) {
        _tapAction(currentIndex);
    }
}

-(void)setupGestureWithType:(GestureType)type
{
    [imageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * iv = obj;
        iv.userInteractionEnabled = YES;
        if (type | GestureTypeTap) {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView)];
            [iv addGestureRecognizer:tap];
        }
        if (type | GestureTypeLongPress) {
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
            [iv addGestureRecognizer:longPress];
        }
    }];
}

-(void)longPressGestureAction:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            if (_needAutoCycle || [timer isValid]) {
                [timer invalidate];
            }
            break;
            case UIGestureRecognizerStateEnded:
            if (_needAutoCycle) {
                [self setupTimer];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(CycleScrollView:longPressAtIndex:)]) {
                [_delegate CycleScrollView:self longPressAtIndex:currentIndex];
            }
            if (_longPressAction) {
                _longPressAction(currentIndex);
            }
            break;
        default:
            break;
    }
}


#pragma mark - Get

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setContentSize:CGSizeMake(WIDTH_WH*totalImageCount, HEIGHT_WH)];
    }
    return _scrollView;
}


-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

-(UIColor *)currentPageIndicatorTintColor
{
    return _pageControl.currentPageIndicatorTintColor;
}

-(UIColor *)pageIndicatorTintColor
{
    return _pageControl.pageIndicatorTintColor;
}


#pragma mark - Set

-(void)setTapAction:(void (^)(NSInteger))tapAction
{
    _tapAction = tapAction;
    if (_tapAction) {
        [self setupGestureWithType:GestureTypeTap];
    }
}

-(void)setLongPressAction:(void (^)(NSInteger))longPressAction
{
    _longPressAction = longPressAction;
    if (_longPressAction) {
        [self setupGestureWithType:GestureTypeLongPress];
    }
}

-(void)setNeedPageControl:(BOOL)needPageControl
{
    _needPageControl = needPageControl;
    if (_needPageControl && totalPageCount > 1) {
        if (![self.subviews containsObject:_pageControl]) {
            [self insertSubview:self.pageControl aboveSubview:self.scrollView];
        }
        _pageControl.numberOfPages = totalPageCount;
        _pageControl.currentPage = 0;
        [self setPageControlType:WHPageControlLocationCenter];
    }
}

-(void)setPageControlType:(WHPageControlLocation)pageControlType
{
    _pageControlType = pageControlType;
    if (_needPageControl) {
        CGRect pageControlFrame = CGRectZero;
        CGSize size = [_pageControl sizeForNumberOfPages:totalPageCount];
        pageControlFrame.size = size;
        pageControlFrame.origin.y = HEIGHT_WH-size.height-Space_bottom;
        switch (_pageControlType) {
            case WHPageControlLocationLeft:
                pageControlFrame.origin.x = 0;
                break;
            case WHPageControlLocationCenter:
                pageControlFrame.origin.x = (WIDTH_WH-size.width)/2;
                break;
            case WHPageControlLocationRight:
                pageControlFrame.origin.x = WIDTH_WH-size.width;
                break;
        }
        _pageControl.frame = pageControlFrame;
    }
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    if (_pageControl) {
        [_pageControl setPageIndicatorTintColor:pageIndicatorTintColor];
    }
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    if (_pageControl) {
        [_pageControl setCurrentPageIndicatorTintColor:currentPageIndicatorTintColor];
    }
}

-(void)setNeedAutoCycle:(BOOL)needAutoCycle
{
    _needAutoCycle = needAutoCycle;
    if (_needAutoCycle && totalPageCount > 1) {
        if (_autoCycleInterval == 0.0f) {
            _autoCycleInterval = DefaultAutoCycleInterval;
        }
        [self setupTimer];
    }
}

-(void)setAutoCycleInterval:(NSTimeInterval)autoCycleInterval
{
    _autoCycleInterval = autoCycleInterval >= MinAutoCyleInterval ? autoCycleInterval : DefaultAutoCycleInterval;
    if (_needAutoCycle && totalPageCount > 1) {
        [timer invalidate];
        [self setupTimer];
    }
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    if (_dataSource.count > 1) {
        _scrollView.scrollEnabled = YES;
        if (_needAutoCycle && ![timer isValid]) {
            [self setupTimer];
        }
        if (_needPageControl) {
            _pageControl.hidden = NO;
        }
    }else{
        _scrollView.scrollEnabled = NO;
        if (_needAutoCycle) {
            [timer invalidate];
        }
        if (_needPageControl) {
            _pageControl.hidden = YES;
        }
    }
    totalPageCount = dataSource.count;
    _pageControl.numberOfPages = totalPageCount;
    currentIndex = 0;
    [self setupContentView];
}

-(void)dealloc
{
    [timer invalidate];
    timer = nil;
    _scrollView = nil;
    _pageControl = nil;
}


@end
