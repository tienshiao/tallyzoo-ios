//
//  GraphViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "TallyZooAppDelegate.h"
#import "CountsViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "UpperLeftView.h"
#import "UpperRightView.h"
#import "LowerLeftView.h"
#import "LowerRightView.h"

@implementation GraphViewController

- (id)init {
	if (self = [super init]) {
		activities = [[NSMutableArray alloc] init];
		
		self.tabBarController.view.backgroundColor = [UIColor blackColor];
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	portraitView = [[UIView alloc] init];
	portraitView.backgroundColor = [UIColor blackColor];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor blackColor];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[portraitView addSubview:_tableView];
	
	UpperLeftView *ulView = [[UpperLeftView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
	[portraitView addSubview:ulView];
	[ulView release];

	UpperRightView *urView = [[UpperRightView alloc] initWithFrame:CGRectMake(300, 0, 10, 10)];
	[portraitView addSubview:urView];
	[urView release];

	LowerLeftView *llView = [[LowerLeftView alloc] initWithFrame:CGRectMake(10, _tableView.bounds.size.height - 10, 10, 10)];
	[portraitView addSubview:llView];
	[llView release];
		
	LowerRightView *lrView = [[LowerRightView alloc] initWithFrame:CGRectMake(300, _tableView.bounds.size.height - 10, 10, 10)];
	[portraitView addSubview:lrView];
	[lrView release];
	
	graphView = [[GraphView alloc] initWithFrame:CGRectMake(10, 227, 300, 180)];
	[portraitView addSubview:graphView];	
	
	[self setView:portraitView];

	landscapeView = [[LandscapeGraphView alloc] initWithFrame:CGRectMake(0, 0, 480, 320) activities:activities];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[activities removeAllObjects];
	
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM activities WHERE deleted = 0 ORDER BY upper(name)"];
	while ([rs next]) {
		TZActivity *a = [[TZActivity alloc] initWithKey:[rs intForColumn:@"id"]];
		[activities addObject:a];
		[a release];
	}
	
	landscapeView.activities = activities;
	[_tableView reloadData];

	if ([activities count]) {
		oldSelection = 0;
		[_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
		graphView.activity = [activities objectAtIndex:0];
	}
	
	[_tableView flashScrollIndicators];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
	
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)animateToFullScreen:(BOOL)isFullScreen duration:(NSTimeInterval)duration {
	CGRect tabBarFrame = self.tabBarController.tabBar.frame;
	if (isFullScreen == NO && tabBarFrame.origin.y != 480) {
		// what?
		tabBarFrame.origin.y = 480;
		self.tabBarController.tabBar.frame = tabBarFrame;	
	}
	
	[UIView beginAnimations:@"animateToFullScreen" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:duration];
	
	//move tab bar up/down
	tabBarFrame = self.tabBarController.tabBar.frame;
	int tabBarHeight = tabBarFrame.size.height;
	int offset = isFullScreen ? tabBarHeight : -1 * tabBarHeight;
	int tabBarY = tabBarFrame.origin.y + offset;
	tabBarFrame.origin.y = tabBarY;
	self.tabBarController.tabBar.frame = tabBarFrame;
	
	//fade it in/out
	self.tabBarController.tabBar.alpha = isFullScreen ? 0 : 1;

	[UIView commitAnimations];	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	duration = 5;
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self animateToFullScreen:YES duration:duration];
		[UIView beginAnimations:@"fadeout_portrait" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:duration];
		
		portraitView.alpha = 0;
		
		[UIView commitAnimations];					
	} else {
		[UIView beginAnimations:@"fadeout_landscape" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:duration];
		
		landscapeView.alpha = 0;
		
		[UIView commitAnimations];							
	}
//	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	NSTimeInterval duration = .25;
	if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self animateToFullScreen:NO duration:duration];
		[landscapeView removeFromSuperview];
		
		[_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:landscapeView.currentPage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		[self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:landscapeView.currentPage inSection:0]];
		
		[UIView beginAnimations:@"fadein_portrait" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:duration];
		
		portraitView.alpha = 1;
		
		[UIView commitAnimations];					
	} else {
		landscapeView.alpha = 0;
		[self.tabBarController.view addSubview:landscapeView];
		[UIView beginAnimations:@"fadein_landscape" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:duration];
		
		landscapeView.alpha = 1;
		
		[UIView commitAnimations];							
	}
//	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([activities count] < 5) ? 5 : [activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    static NSString *CellIdentifier = @"Graph Cell";
    
    GraphCell *cell = (GraphCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GraphCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		cell.delegate = self;
    }
	
	if (indexPath.row < [activities count]) {
		TZActivity *a = [activities objectAtIndex:indexPath.row];
		cell.activity = a;
	} else {
		cell.activity = nil;
	}
	
	if ([activities count] < 5) {
		cell.last = indexPath.row == 4;
	} else {
		cell.last = indexPath.row == [activities count] - 1;
	}
	
	cell.index = indexPath.row;
	cell.first = indexPath.row == 0;
	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([activities count] == 0) {
		return nil;
	}
	if (indexPath.row < [activities count]) {
		return indexPath;
	}
	return [NSIndexPath indexPathForRow:oldSelection inSection:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	oldSelection = indexPath.row;
	graphView.activity = [activities objectAtIndex:indexPath.row];
	landscapeView.currentPage = indexPath.row;
}

- (void)graphCellAccessoryClicked:(GraphCell *)gc {
	CountsViewController *cvc = [[CountsViewController alloc] initWithActivity:gc.activity];
	[self.navigationController pushViewController:cvc animated:YES];
	[cvc release];	
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
	
	[activities release];
	[graphView release];
	[_tableView release];
	
	[portraitView release];
	[landscapeView release];
}


@end
