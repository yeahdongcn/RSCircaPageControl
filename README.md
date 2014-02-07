RSCircaPageControl
==================

![ScreenShot](https://s3.amazonaws.com/cocoacontrols_production/uploads/control_image/image/1815/iOS_Simulator_Screen_shot_Sep_9__2013_10.52.52_AM.png)

Clones 'Circa' news detail view's page control and provide an easy-to-follow sample.

It's quite simple to use this page control, there are only 3 functions available.

- (id)initWithNumberOfPages:(NSInteger)numberOfPages;

- (void)setCurrentPage:(NSInteger)currentPage usingScroller:(BOOL)usingScroller;

- (void)updateScrollerAtPercentage:(float)percentage animated:(BOOL)animated;

The first one should be used to Initialize the control after alloc.

The second function takes two parameters, current page and whether to use scroller, the later parameter should be YES when you have a scrollview as subview and its contentSize's width or height is larger than its bounds', you could calculate the value by BOOL usingScroller = sv.contentSize.height > sv.bounds.size.height;.

The last function will update the scroller (page indicator). You should use scroll view's delegate to do this.

In - (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        float percentage = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height);
        [self.pageControl updateScrollerAtPercentage:percentage animated:YES];
    }
}

######How manually go to one page

Check `- (IBAction)buttonClicked:(id)sender` in `RSViewController`, first scroll the scrollview to fit the page and then update the page control with current page.

------

Explore more in sample.

------


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/yeahdongcn/rscircapagecontrol/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

