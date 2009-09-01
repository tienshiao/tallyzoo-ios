//
//  LandscapeGraphView.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LandscapeGraphView.h"


@implementation LandscapeGraphView


- (id)initWithFrame:(CGRect)frame activities:(NSMutableArray *)a {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		activities = a;
		
		int screens = [activities count];
		
		self.backgroundColor = [UIColor blackColor];
		
		graphs = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < screens; i++) {
			[graphs addObject:[NSNull null]];
		}
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 480, 280)];
		_scrollView.pagingEnabled = YES;
		_scrollView.contentSize = CGSizeMake(480 * screens, _scrollView.frame.size.height);
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.scrollsToTop = NO;
		_scrollView.delegate = self;
		_scrollView.backgroundColor = [UIColor blackColor];
		[self addSubview:_scrollView];
		
		_pageControl = [[UIPageControl alloc] init];
		_pageControl.numberOfPages = screens;
		_pageControl.backgroundColor = [UIColor blackColor];
		_pageControl.frame = CGRectMake(0, 305, 0, 10);
		[self addSubview:_pageControl];
		[_pageControl sizeToFit];
		CGRect frame = _pageControl.frame;
		frame.size.height = 10;
		_pageControl.frame = frame;
		[_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
		
		self.currentPage = 0;
		
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
	
	// load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)pageChanged:(id)sender {
	int page = _pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;	
}

- (void)loadScrollViewWithPage:(int)page {
	if (page < 0) return;
    if (page >= [activities count]) return;
	
    // replace the placeholder if necessary
    GraphView *graph = [graphs objectAtIndex:page];
    if ((NSNull *)graph == [NSNull null]) {
        graph = [[GraphView alloc] initWithFrame:CGRectZero];
        [graphs replaceObjectAtIndex:page withObject:graph];
        [graph release];
    }
	graph.activity = [activities objectAtIndex:page];

    // add the controller's view to the scroll view
    if (nil == graph.superview) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
		frame.origin.x += 5;
		frame.size.width -= 10;
		graph.frame = frame;
        [_scrollView addSubview:graph];
    }
}

- (NSMutableArray *)activities {
	return activities;
}

- (void)setActivities:(NSMutableArray *) a{
	activities = a;
	
	_scrollView.contentSize = CGSizeMake(480 * [a count], _scrollView.frame.size.height);
	_pageControl.numberOfPages = [a count];
	for (unsigned i = [graphs count]; i < [a count]; i++) {
		[graphs addObject:[NSNull null]];
	}
	
	[_pageControl sizeToFit];
	CGRect frame = _pageControl.frame;
	frame.size.height = 10;
	_pageControl.frame = frame;
	
	// reload them
	self.currentPage = currentPage;

	[self loadScrollViewWithPage:currentPage - 1];
    [self loadScrollViewWithPage:currentPage];
    [self loadScrollViewWithPage:currentPage + 1];
}

- (int)currentPage {
	return currentPage;
}

- (void)setCurrentPage:(int)p {
	currentPage = p;
	
	_pageControl.currentPage = p;
}

- (void)dealloc {
    [super dealloc];
	
	[graphs release];
}


@end
