//
//  MoreTableViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MoreTableViewController.h"
#import "HelpWebViewController.h"
#import "ShoutOutViewController.h"

@implementation MoreTableViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.title = @"More";
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

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
    return 4;
}

- (void)configureTopCell:(UITableViewCell *)cell {
	CGRect rect = cell.frame;
	rect.size.height = 53;
	cell.frame = rect;
	
	UILabel *label;
	
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	rect = CGRectMake(10, 3, 280, 25);
	label = [[UILabel alloc] initWithFrame:rect];
	label.font = [UIFont boldSystemFontOfSize:20];
	label.adjustsFontSizeToFitWidth = YES;
	label.textAlignment = UITextAlignmentCenter;
	label.text = [NSString stringWithFormat:@"TallyZoo v%@", version];
	[cell.contentView addSubview:label];
	label.highlightedTextColor = [UIColor whiteColor];
	[label release];
	
	rect = CGRectMake(10, 28, 280, 25);
	label = [[UILabel alloc] initWithFrame:rect];
	label.font = [UIFont systemFontOfSize:12];
	label.textAlignment = UITextAlignmentCenter;
	label.text = @"Copyright © 2009 XXXXX";
	[cell.contentView addSubview:label];
	label.highlightedTextColor = [UIColor whiteColor];
	[label release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 54;
	} else {
		return 40;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *RegCellIdentifier = @"Cell";
	static NSString *TopCellIdentifier = @"Top Cell";
    
	NSString *cellIdentifier;
	
	if (indexPath.row == 0) {
		cellIdentifier = TopCellIdentifier;
	} else {
		cellIdentifier = RegCellIdentifier;
	}
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }

    // Set up the cell...
	if (indexPath.row == 0) {
		[self configureTopCell:cell];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Tips";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"FAQs";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	} else if (indexPath.row == 3) {
		cell.textLabel.text = @"Shout Outs";
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
	
	if (indexPath.row == 1) {
		HelpWebViewController *hwvc = [[HelpWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.tallyzoo.com/iphonetips.php"]];
		hwvc.title = @"Tips";
		[[self navigationController] pushViewController:hwvc animated:YES];
		[hwvc release];
	} else if (indexPath.row == 2) {
		HelpWebViewController *hwvc = [[HelpWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.tallyzoo.com/iphonefaqs.php"]];
		hwvc.title = @"FAQs";
		[[self navigationController] pushViewController:hwvc animated:YES];
		[hwvc release];
	} else if (indexPath.row == 3) {
		ShoutOutViewController *sovc = [[ShoutOutViewController alloc] init];
		[[self navigationController] pushViewController:sovc animated:YES];
		[sovc release];		
	}
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
    [super dealloc];
}


@end

