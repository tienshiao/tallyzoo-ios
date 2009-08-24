//
//  GraphViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphCell.h"
#import "TallyZooAppDelegate.h"
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
	UIView *containerView = [[UIView alloc] init];
	containerView.backgroundColor = [UIColor blackColor];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor blackColor];
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[containerView addSubview:_tableView];
	
	UpperLeftView *ulView = [[UpperLeftView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
	[containerView addSubview:ulView];
	[ulView release];

	UpperRightView *urView = [[UpperRightView alloc] initWithFrame:CGRectMake(300, 0, 10, 10)];
	[containerView addSubview:urView];
	[urView release];

	LowerLeftView *llView = [[LowerLeftView alloc] initWithFrame:CGRectMake(10, _tableView.bounds.size.height - 10, 10, 10)];
	[containerView addSubview:llView];
	[llView release];
		
	LowerRightView *lrView = [[LowerRightView alloc] initWithFrame:CGRectMake(300, _tableView.bounds.size.height - 10, 10, 10)];
	[containerView addSubview:lrView];
	[lrView release];
	
	graphView = [[GraphView alloc] initWithFrame:CGRectMake(10, 227, 300, 180)];
	[containerView addSubview:graphView];	
	
	[self setView:containerView];
	[containerView release];
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
	
	[_tableView reloadData];

	if ([activities count]) {
		oldSelection = 0;
		[_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
		graphView.activity = [activities objectAtIndex:0];
	}
	
	[_tableView flashScrollIndicators];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([activities count] < 5) ? 5 : [activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
    static NSString *CellIdentifier = @"Graph Cell";
    
    GraphCell *cell = (GraphCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GraphCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
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
}


@end
