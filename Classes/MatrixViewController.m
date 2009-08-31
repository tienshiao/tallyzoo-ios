//
//  MatrixViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MatrixViewController.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"
#import "EditActivityViewController.h"
#import "EditCountViewController.h"
#import "TZActivity.h"
#import "TZCount.h"
#import "MatrixButton.h"
#import "ShakeView.h"

@implementation MatrixViewController

-(id)init {
	if (self = [super init]) {
		self.title = @"TallyZoo";
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										  target:self 
										  action:@selector(addItem:)];
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																		  target:self 
																		  action:@selector(editButtons:)];
		self.navigationItem.leftBarButtonItem = editBarButtonItem;

		doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		  target:self 
																		  action:@selector(doneButtons:)];
		editting = NO;
		
		matrices = [[NSMutableArray alloc] init];
		for (int i = 0; i < [self getNumberOfScreens]; i++) {
			[matrices addObject:[NSNull null]];
		}
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		button_behavior = [defaults integerForKey:@"behavior_preference"];
		
		locationSheet = [[UIActionSheet alloc] initWithTitle:@"Retrieving Location ..."
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
									  destructiveButtonTitle:@"Save Without Location" 
										   otherButtonTitles:nil];
		locationSheet.actionSheetStyle = UIActionSheetStyleAutomatic;		
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

- (void)loadButtons:(MatrixView *)mv screen:(int)screen {
	[mv clearButtons];
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM activities WHERE deleted = 0 AND screen = ?",
					   [NSNumber numberWithInt:screen]];
	while ([rs next]) {
		TZActivity *a = [[TZActivity alloc] initWithKey:[rs intForColumn:@"id"]];
		MatrixButton *button = [[MatrixButton alloc] initWithActivity:a];
		
		// setup frame
		CGRect r = CGRectMake(0, 0, mv.bounds.size.width/3, mv.bounds.size.height/3);
		r.origin.x = (a.position % 3) * r.size.width;
		r.origin.y = (a.position / 3) * r.size.height;
		button.frame = r;
		button.delegate = self;
		
		if (editting) {
			[self wobbleView:button];
		}
		
		[mv.buttons replaceObjectAtIndex:a.position withObject:button];
		[mv addSubview:button];
		[a release];
		[button release];
	}	
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
    }
	
	[self loadButtons:matrix screen:page];
	
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
	ShakeView *containerView = [[ShakeView alloc] init];
	containerView.backgroundColor = [UIColor blackColor];
	containerView.delegate = self;
	
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
	
	locationBusyView = [[LocationBusyView alloc] initWithFrame:CGRectMake(110, 100, 100, 100)];
	locationBusyView.hidden = YES;
	[containerView addSubview:locationBusyView];
	
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
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];	
}

- (void)viewDidAppear:(BOOL)animater {
	[self.view becomeFirstResponder];
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

- (void)addItem:(id)sender {
	TZActivity *newActivity = [[TZActivity alloc] initWithKey:0];
	EditActivityViewController *eavc = [[EditActivityViewController alloc] initWithActivity:newActivity];
	UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:eavc];
	
	[[self navigationController] presentModalViewController:addNavigationController animated:YES];
	
	[addNavigationController release];
	[eavc release];	
}

- (void)wobbleView:(UIView *)v {
	CALayer *l = v.layer;
	
	l.transform = CATransform3DMakeScale(0.9, 0.9, 1);
	
	// here is an example wiggle
	CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
	wiggle.duration = 0.1;
	wiggle.repeatCount = 1e100f;
	wiggle.autoreverses = YES;
	wiggle.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(l.transform,-0.05, 0.0 ,1.0 ,2.0)];
	wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(l.transform,0.05, 0.0 ,1.0 ,2.0)];
	
	// doing the wiggle
	[l addAnimation:wiggle forKey:@"wiggle"];
}

- (void)stopWobbleView:(UIView *)v {
	[v.layer removeAllAnimations];
	v.layer.transform = CATransform3DIdentity;
}

- (void)editButtons:(id)sender {
	editting = YES;
	self.navigationItem.leftBarButtonItem = doneBarButtonItem;
	
	for (MatrixView *matrix in matrices) {
		if ((NSNull *)matrix == [NSNull null]) {
			continue;
		}
		
		for (MatrixButton *button in matrix.buttons) {
			if ((NSNull *)button == [NSNull null]) {
				continue;
			}
			[self wobbleView:button];
		}
	}
}

- (void)doneButtons:(id)sender {
	editting = NO;
	self.navigationItem.leftBarButtonItem = editBarButtonItem;

	for (MatrixView *matrix in matrices) {
		if ((NSNull *)matrix == [NSNull null]) {
			continue;
		}
		
		for (MatrixButton *button in matrix.buttons) {
			if ((NSNull *)button == [NSNull null]) {
				continue;
			}
			[self stopWobbleView:button];
		}
	}
	
}

- (void)matrixButtonClicked:(MatrixButton *)mb {
	if (editting) {
		EditActivityViewController *eavc = [[EditActivityViewController alloc] initWithActivity:mb.activity];
		UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:eavc];
		
		[[self navigationController] presentModalViewController:addNavigationController animated:YES];
		
		[addNavigationController release];
		[eavc release];			
	} else {
		if (button_behavior == 0) {
			NSLog(@"accuracy %f", UIAppDelegate.location.horizontalAccuracy);
			if (UIAppDelegate.location.horizontalAccuracy <= 0) {
				tmp_button = mb;
				[self waitForLocation];
			} else {
				[mb.activity simpleCount];
/*				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location" 
																message:[NSString stringWithFormat:@"%@", UIAppDelegate.location] 
															   delegate:nil
													  cancelButtonTitle:@"Close"
													  otherButtonTitles:nil];
				alert.delegate = self;
				[alert show];*/
				
			}
		} else {
			TZCount *newCount = [[TZCount alloc] initWithKey:0 andActivity:mb.activity];
			EditCountViewController *ecvc = [[EditCountViewController alloc] initWithCount:newCount];
			UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:ecvc];
			
			[[self navigationController] presentModalViewController:addNavigationController animated:YES];
			
			[addNavigationController release];
			[ecvc release];				
		}
	}
}

- (void)matrixButtonHeld:(MatrixButton *)mb {
	if (editting) {
	} else {
		if (button_behavior == 0) {
			TZCount *newCount = [[TZCount alloc] initWithKey:0 andActivity:mb.activity];
			EditCountViewController *ecvc = [[EditCountViewController alloc] initWithCount:newCount];
			UINavigationController *addNavigationController =[[UINavigationController alloc] initWithRootViewController:ecvc];
	
			[[self navigationController] presentModalViewController:addNavigationController animated:YES];
	
			[addNavigationController release];
			[ecvc release];	
		} else {
			if (UIAppDelegate.location.horizontalAccuracy <= 0) {
				tmp_button = mb;
				[self waitForLocation];
			} else {
				[mb.activity simpleCount];
			}
		}
	}
}

-(void)shakeHappened:(ShakeView*)view {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM counts WHERE deleted = 0 ORDER BY created_on DESC LIMIT 1"];
	[rs next];
	
	TZCount *c = [[TZCount alloc] initWithKey:[rs intForColumn:@"id"] andActivity:nil];
	undo_count_id = c.key;
	
	TZActivity *a = [[TZActivity alloc] initWithKey:c.activity_id];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo" 
													message:[NSString stringWithFormat:@"Undo last count on '%@'?", a.name] 
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:@"Undo Count", nil];
	alert.delegate = self;
	[alert show];
	
	[c release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex) {
		FMDatabase *dbh = UIAppDelegate.database;
		FMResultSet *rs = [dbh executeQuery:@"UPDATE counts SET deleted = 1 WHERE id = ?", [NSNumber numberWithInt:undo_count_id]];
		[rs next];
		
		int screens = [self getNumberOfScreens];
		for (int i = 0; i < screens; i++) {
			[self loadScrollViewWithPage:i];
		}
		
	}
}

- (void)waitForLocation {
	locationBusyView.hidden = NO;
	UIAppDelegate.locationDelegate = self;
	[locationSheet showInView:self.tabBarController.view]; // show from our table view (pops up in the middle of the table)
}

- (void)locationFound {
	[locationSheet dismissWithClickedButtonIndex:1 animated:YES];
	[tmp_button.activity simpleCount];
	[tmp_button setNeedsDisplay];
	tmp_button = nil;
	locationBusyView.hidden = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		[tmp_button.activity simpleCount];
		[tmp_button setNeedsDisplay];
		tmp_button.activity = nil;
		locationBusyView.hidden = YES;
	}
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
	
	[editBarButtonItem release];
	[doneBarButtonItem release];
	
	[locationSheet release];
}


@end
