//
//  LandscapeGraphView.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"


@interface LandscapeGraphView : UIView<UIScrollViewDelegate> {
	UIPageControl *_pageControl;
	UIScrollView *_scrollView;
	BOOL _pageControlUsed;
	
	NSMutableArray *activities;
	NSMutableArray *graphs;
	
	int currentPage;
}

@property(nonatomic, assign) NSMutableArray *activities;
@property(nonatomic, assign) int currentPage;

- (void)loadScrollViewWithPage:(int)page;
- (id)initWithFrame:(CGRect)frame activities:(NSMutableArray *)a;

@end
