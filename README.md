WHCycleScrollView

	
* 轮播循环滚动，可自定义循环时间，方向；
* 数据源支持URL和本地资源图片同时混用；
* 通过block和协议回调点击和长按事件；
* 集成UIPageControl,且支持左中右三个位置；
	
---

支持CocoaPod
> pod 'WHCycleScrollView', '~>1.0.0'

---

一行代码实现自动轮播和pageControl  

		  WHCycleScrollView* cycleScrollView = [WHCycleScrollView cycleScrollViewWithFrame:self.view.bounds dataSource:urls pageControl:YES autoCycle:YES];
		  
####属性说明:

> @property (nonnull, nonatomic, strong) NSArray * dataSource;
	
	dataSource支持URL和本地图片名混用，URL元素以NSURL形式，本地图片以NSString形式放入数组中。在数据源有变化时，直接设置此属性即可，PageControl会跟着变化。  
	

> @property (nullable, nonatomic, strong) UIImage * placeholderImage;

	placeholderImage是加载URL资源时的占位图

---
> @property (nonatomic, assign) BOOL needPageControl;   //default is NO

	needPageControl默认为NO，如果需要可设置为YES，即可集成

> @property (nonatomic, assign) WHPageControlLocation pageControlType;
	
	pageControlType是设置pageControl位置的属性，有三个枚举值，默认是在中间
	
	typedef NS_ENUM(NSInteger, WHPageControlLocation ){
    	WHPageControlLocationLeft,
		WHPageControlLocationCenter,
    	WHPageControlLocationRight,
	};

> @property (nullable, nonatomic, strong) UIColor * pageIndicatorTintColor;
> @property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor;

	这两个属性用于设置pageContol的当前page颜色和其它page颜色

---

> @property (nonatomic, assign) BOOL needAutoCycle;
	
	needAutoCycle默认为NO，如果需要轮播则设置为YES

> @property (nonatomic, assign) NSTimeInterval autoCycleInterval;
	
	autoCycleInterval用于设置轮播间隔，默认为5.0f
	
> @property (nonatomic, assign) WHCycleDirection cycleDirection
	
	cycleDirection用于设置轮播滚动方向,默认是向右
	
	typedef NS_ENUM(NSInteger, WHCycleDirection){
  	  	WHCycleDirectionRight,
    	WHCycleDirectionLeft,
	};

	
---

> @property (nullable, nonatomic, copy) void (^tapAction)(NSInteger index);
	
	tapAction，单击事件block回调
	
> @property (nullable, nonatomic, copy) void (^longPressAction)(NSInteger index);
	
	longPressAction,长按事件block回调
	
	
---

* 除了用block回调外，还可以通过**WHCycleScrollViewDelegate**协议来回调
* ps:URL加载采用SDWebImage


	
	
