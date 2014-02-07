//
//  RSViewController.m
//  Circa
//
//  Created by R0CKSTAR on 7/31/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSViewController.h"

#import "RSCircaPageControl.h"

@interface RSView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation RSView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *child = nil;
    if ((child = [super hitTest:point withEvent:event]) == self) {
    	return self.scrollView;
    }
    return child;
}

@end

@interface RSViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) RSView *clipView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RSCircaPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation RSViewController

static const int kScrollViewHeight        = 420;
static const int kScrollViewContentHeight = 600;
static const int kScrollViewTagBase       = 500;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // From http://stackoverflow.com/questions/1220354/uiscrollview-horizontal-paging-like-mobile-safari-tabs/1220605#1220605
    self.clipView = [[RSView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.clipView.clipsToBounds = YES;
    [self.view addSubview:self.clipView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.clipView.bounds.size.width, kScrollViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    self.clipView.scrollView = self.scrollView;
    
    self.pageControl = [[RSCircaPageControl alloc] initWithNumberOfPages:10];
    CGRect frame = self.pageControl.frame;
    frame.origin.x = self.view.bounds.size.width - frame.size.width - 10;
    frame.origin.y = roundf((self.view.bounds.size.height - frame.size.height) / 2.);
    self.pageControl.frame = frame;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.pageControl setCurrentPage:0 usingScroller:NO];
    [self.view addSubview:self.pageControl];
    
    CGFloat currentY = 0;
    for (int i = 0; i < 10; i++) {
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentY, self.scrollView.bounds.size.width, kScrollViewHeight)];
        sv.tag = kScrollViewTagBase + i;
        sv.delegate = self;
        sv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        sv.backgroundColor = [UIColor colorWithRed:(arc4random() % 257) / 256. green:(arc4random() % 257) / 256. blue:(arc4random() % 257) / 256. alpha:1];
        if (i == 2 || i == 6) {
            sv.contentSize = CGSizeMake(sv.contentSize.width, kScrollViewContentHeight);
        }
        [self.scrollView addSubview:sv];
        currentY += kScrollViewHeight;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, currentY);
    
    [self.view bringSubviewToFront:self.button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        float percentage = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height);
        [self.pageControl updateScrollerAtPercentage:percentage animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        int index = (int)(scrollView.contentOffset.y / kScrollViewHeight);
        UIScrollView *sv = (UIScrollView *)[self.scrollView viewWithTag:kScrollViewTagBase + index];
        BOOL usingScroller = sv.contentSize.height > sv.bounds.size.height;
        [self.pageControl setCurrentPage:index
                           usingScroller:usingScroller];
        if (usingScroller) {
            float percentage = sv.contentOffset.y / (sv.contentSize.height - sv.bounds.size.height);
            [self.pageControl updateScrollerAtPercentage:percentage animated:NO];
        }
    }
}

- (IBAction)buttonClicked:(id)sender
{
    int page = 2; // Which page you want to go
    
    [self.scrollView setContentOffset:CGPointMake(0, kScrollViewHeight * page) animated:YES];
    UIScrollView *sv = (UIScrollView *)[self.scrollView viewWithTag:kScrollViewTagBase + page];
    BOOL usingScroller = sv.contentSize.height > sv.bounds.size.height;
    [self.pageControl setCurrentPage:page usingScroller:usingScroller];
}

@end
