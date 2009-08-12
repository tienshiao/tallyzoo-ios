//
//  MatrixViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MatrixViewController.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"
#import "EditItemViewController.h"
#import "TZActivity.h"

@implementation MatrixViewController

-(id)init {
	if (self = [super init]) {
		self.title = @"Tally Zoo";
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										  target:self 
										  action:@selector(addItem:)];
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
														target:self 
														action:@selector(editButtons:)];
		self.navigationItem.leftBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		matrices = [[NSMutableArray alloc] init];
		for (int i = 0; i < [self getNumberOfScreens]; i++) {
			[matrices addObject:[NSNull null]];
		}
		
	}
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


- (int)getNumberOfScreens {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT max(screen) AS max_screen FROM activities WHERE deleted = 0"];
	[rs next];
	return [rs intForColumn:@"max_screen"] + 1;
}

- (void)loadScrollViewWithPage:(int)page {
	if (page < 0) return;
	if (page >= [self getNumberOfScreens]) return;
	
	if (page >= [matrices count]) {
		for (int i = [matrices count] - 1; i < page; i++) {
			[matrices addObject:[NSNull null]];
		}
	}
	
	// replace the placeholder if necessary
    MatrixView *matrix = [matrices objectAtIndex:page];
    if ((NSNull *)matrix == [NSNull null]) {
        matrix = [[MatrixView alloc] initWithFrame:_scrollView.bounds andScreenNumber:page];
        [matrices replaceObjectAtIndex:page withObject:matrix];
        [matrix release];
    } else {
		[matrix reloadData];
	}
	
    if (nil == matrix.superview) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        matrix.frame = frame;
        [_scrollView addSubview:matrix];
    }	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *containerView = [[UIView alloc] init];
	containerView.backgroundColor = [UIColor blackColor];
	
	int screens = [self getNumberOfScreens];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 342)];
	_scrollView.pagingEnabled = YES;
	_scrollView.contentSize = CGSizeMake(320 * screens, _scrollView.frame.size.height);
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.scrollsToTop = NO;
	_scrollView.delegate = self;
	[containerView addSubview:_scrollView];
	
/*	for (int i = 0; i < screens; i++) {
		[self loadScrollViewWithPage:i];
	}*/
	
	_pageControl = [[UIPageControl alloc] init];
	_pageControl.numberOfPages = screens;
	_pageControl.backgroundColor = [UIColor blackColor];
	_pageControl.frame = CGRectMake(0, 300, 0, 20);
	[containerView addSubview:_pageControl];
	[_pageControl sizeToFit];
	CGRect frame = _pageControl.frame;
	frame.size.height = 20;
	frame.origin.y = 365 - frame.size.height;
	_pageControl.frame = frame;
	[_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
	
	[self setView:containerView];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	int screens = [self getNumberOfScreens];

	_scrollView.contentSize = CGSizeMake(320 * screens, _scrollView.frame.size.height);
	_pageControl.numberOfPages = screens;
	
	for (int i = 0; i < screens; i++) {
		[self loadScrollViewWithPage:i];
	}
//	[self.tableView reloadData];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)addItem:(id)sender {
	TZActivity *newItem = [[TZActivity alloc] initWithKey:0];
	EditItemViewController *eivc = [[EditItemViewController alloc] initWithItem:newItem];
	UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:eivc];
	
	[[self navigationController] presentModalViewController:addNavigationController animated:YES];
	
	[addNavigationController release];
	[eivc release];	
}


- (void)editButtons:(id)sender {
}

- (void)pageChanged:(id)sender {
	int page = _pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page - 1];
    //[self loadScrollViewWithPage:page];
    //[self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[_pageControl release];
	[_scrollView release];
	[matrices release];
}


@end
