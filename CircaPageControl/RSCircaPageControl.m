//
//  RSCircaPageControl.m
//  Circa
//
//  Created by R0CKSTAR on 7/31/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCircaPageControl.h"

#import <objc/runtime.h>

@interface RSCircaPageControl ()

@property (nonatomic, assign) NSInteger numberOfPages;

@property (nonatomic, assign) NSInteger currentPage;

- (UIView *)__RSCCreateDot;

- (UIView *)__RSCCreateCurrentDot;

- (UIView *)__RSCCreateCurrentScroller;

@end

#define SCRUBBLE_CURRENT_BG_IMAGE    [UIImage imageNamed:@"scrubblebg"]
#define SCRUBBLE_CURRENT_BLACK_IMAGE [UIImage imageNamed:@"scrubble_black"]
#define SCRUBBLE_CURRENT_DOT_IMAGE   [UIImage imageNamed:@"scrubble_scrollerdot_black"]
#define SCRUBBLE_DOT_IMAGE           [UIImage imageNamed:@"scrubber_bigdot"]

static const int   kScrubbleDotTagBase   = 100;
static const int   kScrubbleDotTag       = 1000;
static const float kPageControlWidth     = 15;
static const float kPageControlDotHeight = 30;

static const void *kDotFrameOriginYMinKey = @"dot_frame_origin_y_min";
static const void *kDotFrameOriginYMaxKey = @"dot_frame_origin_y_max";

@implementation RSCircaPageControl

#pragma mark - Privates

- (UIView *)__RSCCreateDot
{
    UIImageView *dot = [[UIImageView alloc] initWithImage:SCRUBBLE_DOT_IMAGE];
    [dot sizeToFit];
    return dot;
}

- (UIView *)__RSCCreateCurrentDot
{
    UIImageView *bg = [[UIImageView alloc] initWithImage:SCRUBBLE_CURRENT_BG_IMAGE];
    [bg sizeToFit];
    
    UIImageView *black = [[UIImageView alloc] initWithImage:SCRUBBLE_CURRENT_BLACK_IMAGE];
    [black sizeToFit];
    
    CGRect frame = black.frame;
    frame.origin.x = ((bg.frame.size.width - frame.size.width) / 2.);
    frame.origin.y = ((bg.frame.size.height - frame.size.height) / 2.) - 1;
    black.frame = frame;
    
    [bg addSubview:black];
    return bg;
}

- (UIView *)__RSCCreateCurrentScroller
{
    UIImage *bgImg = [SCRUBBLE_CURRENT_BG_IMAGE resizableImageWithCapInsets:UIEdgeInsetsMake(6, 0, 8, 0)];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImg];
    [bg sizeToFit];
    
    CGRect frame = bg.frame;
    frame.size.height = 40;
    bg.frame = frame;
    
    UIImage *blackImg = [SCRUBBLE_CURRENT_BLACK_IMAGE resizableImageWithCapInsets:UIEdgeInsetsMake(6, 0, 6, 0)];
    UIImageView *black = [[UIImageView alloc] initWithImage:blackImg];
    [black sizeToFit];
    
    frame = black.frame;
    frame.size.height = bg.frame.size.height - 4;
    frame.origin.x = ((bg.frame.size.width - frame.size.width) / 2.);
    frame.origin.y = ((bg.frame.size.height - frame.size.height) / 2.) - 1;
    black.frame = frame;
    
    UIImageView *dot = [[UIImageView alloc] initWithImage:SCRUBBLE_CURRENT_DOT_IMAGE];
    dot.tag = kScrubbleDotTag;
    [dot sizeToFit];
    frame = dot.frame;
    frame.origin.x = ((black.frame.size.width - frame.size.width) / 2.);
    frame.origin.y = 2;
    dot.frame = frame;
    
    objc_setAssociatedObject(bg, kDotFrameOriginYMinKey, [NSNumber numberWithFloat:2], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(bg, kDotFrameOriginYMaxKey, [NSNumber numberWithFloat:(black.frame.size.height - frame.size.height - 2)], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [black addSubview:dot];
    [bg addSubview:black];
    return bg;
}

- (id)initWithNumberOfPages:(NSInteger)numberOfPages
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, kPageControlWidth, kPageControlDotHeight * numberOfPages);
        
        self.numberOfPages = numberOfPages;
        self.currentPage = 0;
    }
    return self;
}

- (void)updateScrollerAtPercentage:(float)percentage animated:(BOOL)animated;
{
    UIView *scroller = [self viewWithTag:kScrubbleDotTagBase + _currentPage];
    UIView *dot = [scroller viewWithTag:kScrubbleDotTag];
    float minY = [objc_getAssociatedObject(scroller, kDotFrameOriginYMinKey) floatValue];
    float maxY = [objc_getAssociatedObject(scroller, kDotFrameOriginYMaxKey) floatValue];
    void (^update)() = ^{
        CGRect frame = dot.frame;
        frame.origin.y = minY + (maxY - minY) * percentage;
        dot.frame = frame;
    };
    if (animated) {
        [UIView animateWithDuration:.3 animations:update];
    } else {
        update();
    }
}

- (void)setCurrentPage:(NSInteger)currentPage usingScroller:(BOOL)usingScroller
{
    UIView *dot = [self viewWithTag:kScrubbleDotTagBase + _currentPage];
    UIView *currentDot = [self __RSCCreateDot];
    currentDot.center = dot.center;
    currentDot.tag = dot.tag;
    [self addSubview:currentDot];
    [dot removeFromSuperview];
    
    _currentPage = currentPage;
    
    dot = [self viewWithTag:kScrubbleDotTagBase + _currentPage];
    if (usingScroller) {
        currentDot = [self __RSCCreateCurrentScroller];
    } else {
        currentDot = [self __RSCCreateCurrentDot];
    }
    currentDot.center = dot.center;
    currentDot.tag = dot.tag;
    [self addSubview:currentDot];
    [dot removeFromSuperview];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    for (int i = 0; i < _numberOfPages; i++) {
        UIView *dot = [self __RSCCreateDot];
        dot.tag = kScrubbleDotTagBase + i;
        CGRect frame = dot.frame;
        frame.origin.x = ((self.frame.size.width - dot.frame.size.width) / 2.);
        frame.origin.y = kPageControlDotHeight * i + ((kPageControlDotHeight - dot.frame.size.height) / 2.);
        dot.frame = frame;
        [self addSubview:dot];
    }
}

@end
