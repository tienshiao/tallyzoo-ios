//
//  CountsViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CountsViewController.h"
#import "EditCountViewController.h"
#import "TZCount.h"
#import "FlurryAPI.h"


@implementation CountsViewController

@synthesize activity;

- (id)initWithActivity:(TZActivity *)a {
    if (self = [super init]) {
		self.activity = a;
		
		self.title = activity.name;
		
		formatter = [[NSNumberFormatter alloc] init];
		[formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
    }
    return self;	
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[activity.counts removeAllObjects];
	[activity loadCounts];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [activity.counts count] + 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	if (indexPath.row == [activity.counts count]) {
		cell.textLabel.text = @"Initial Value";
		[formatter setMaximumFractionDigits:activity.init_sig];
		[formatter setMinimumFractionDigits:activity.init_sig];
		
		NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:activity.initial_value]];
		
		
		cell.detailTextLabel.text = numberString;		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		TZCount *c = [activity.counts objectAtIndex:[activity.counts count] - indexPath.row - 1];
		cell.textLabel.text = c.created_on;
		
		[formatter setMaximumFractionDigits:c.amount_sig];
		[formatter setMinimumFractionDigits:c.amount_sig];
		
		NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:c.amount]];
		
		
		cell.detailTextLabel.text = numberString;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
		
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	if (indexPath.row == [activity.counts count]) {
		return;
	}
	
	[FlurryAPI logEvent:@"Edit Count"];
	
	TZCount *c = [activity.counts objectAtIndex:[activity.counts count] - indexPath.row - 1];
	EditCountViewController *ecvc = [[EditCountViewController alloc] initNonModalWithCount:c];
	[self.navigationController pushViewController:ecvc animated:YES];
	[ecvc release];					
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[activity release];
	activity = nil;
	[formatter release];
	formatter = nil;

    [super dealloc];
}


@end

