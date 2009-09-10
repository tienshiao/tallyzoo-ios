//
//  EditCountViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditCountViewController.h"
#import "EditTextFieldViewController.h"
#import "EditTextViewViewController.h"

@implementation EditCountViewController

@synthesize count;


- (id)initWithCount:(TZCount *)c {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.title = c.activity.name;
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										  target:self 
										  action:@selector(cancel:)];
		self.navigationItem.leftBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		barButtonItem = [[UIBarButtonItem alloc] 
						 initWithBarButtonSystemItem:UIBarButtonSystemItemSave
						 target:self 
						 action:@selector(save:)];
		//		barButtonItem.enabled = NO;
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		
		self.count = c;
		
		if (count.key) {
			// TODO show delete option
		}
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
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.accessoryView = nil;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // Set up the cell...
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Amount";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:count.amount]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;			
			break;
		case 1:
			cell.textLabel.text = @"Note";
			cell.detailTextLabel.text = count.note;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 2:
			cell.textLabel.text = @"Categories";
			cell.detailTextLabel.text = count.tags;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	switch (indexPath.row) {
		case 0: {
			// amount
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = count;
			etfvc.textValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:count.amount]];
			etfvc.editedFieldKey = @"amount";
			etfvc.sigFieldKey = @"amount_sig";
			etfvc.title = @"Amount";
			etfvc.numberEditing = YES;
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];							
			break;
		}			
		case 1: {
			// note
			EditTextViewViewController *etvvc = [[EditTextViewViewController alloc] init];
			etvvc.editedObject = count;
			etvvc.textValue = count.note;
			etvvc.editedFieldKey = @"note";
			etvvc.title = @"Note";
			[self.navigationController pushViewController:etvvc animated:YES];
			[etvvc release];						
			break;
		}
		case 2: {
			// tags
			EditTextViewViewController *etvvc = [[EditTextViewViewController alloc] init];
			etvvc.editedObject = count;
			etvvc.textValue = count.tags;
			etvvc.editedFieldKey = @"tags";
			etvvc.title = @"Tags";
			[self.navigationController pushViewController:etvvc animated:YES];
			[etvvc release];									
			break;
		}
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

- (void)cancel:(id)sender {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)save:(id)sender {
	if (![count save]) {
	}
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
    [super dealloc];
}


@end

