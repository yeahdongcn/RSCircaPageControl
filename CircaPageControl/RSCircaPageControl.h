//
//  RSCircaPageControl.h
//  Circa
//
//  Created by R0CKSTAR on 7/31/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCircaPageControl : UIView

- (id)initWithNumberOfPages:(NSInteger)numberOfPages;

- (void)setCurrentPage:(NSInteger)currentPage usingScroller:(BOOL)usingScroller;

- (void)updateScrollerAtPercentage:(float)percentage animated:(BOOL)animated;

@end
