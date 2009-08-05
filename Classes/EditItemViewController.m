//
//  AddItemViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditItemViewController.h"
#import "EditTextFieldViewController.h"
#import "EditTextViewViewController.h"

@implementation EditItemViewController

@synthesize item;

- (id)initWithItem:(TZItem *)i {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.title = @"Item";
		
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
		barButtonItem.enabled = NO;
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		self.item = i;
		
		if (item.key) {
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
    return 11;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Set up the cell...
	switch (indexPath.row) {
		case 0:
			// name
			cell.textLabel.text = @"Name";
			cell.detailTextLabel.text = item.name;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 1:
			// default_note
			cell.textLabel.text = @"Note";
			cell.detailTextLabel.text = item.default_note;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 2:
			// default tags
			cell.textLabel.text = @"Tags";
			cell.detailTextLabel.text = item.default_tags;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 3:
			// color
			cell.textLabel.text = @"Color";
			break;
		case 4:
			// group - private/public
			cell.textLabel.text = @"Public";
			break;
		case 5:
			// display_total
			cell.textLabel.text = @"Show Count";
			break;
		case 6:
			// initial value
			cell.textLabel.text = @"Initial Value";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.initial_value]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 7:
			// goal
			cell.textLabel.text = @"Goal";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.goal]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 8:
			// default_step
			cell.textLabel.text = @"Default Increment";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.default_step]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 9:
			// count_updown
			cell.textLabel.text = @"Count";
			if (item.count_updown > 0) {
				cell.detailTextLabel.text = @"count up"; 
			} else {
				cell.detailTextLabel.text = @"count down";
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;			
			break;
		case 10:
			// created_on
			cell.textLabel.text = @"Date";
			cell.detailTextLabel.text = item.created_on;
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
			// name
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = item;
			etfvc.textValue = item.name;
			etfvc.editedFieldKey = @"name";
			etfvc.title = @"Name";
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];
			break;
		}
		case 1: {
			// default_note
			EditTextViewViewController *etvvc = [[EditTextViewViewController alloc] init];
			etvvc.editedObject = item;
			etvvc.textValue = item.default_note;
			etvvc.editedFieldKey = @"default_note";
			etvvc.title = @"Default Note";
			[self.navigationController pushViewController:etvvc animated:YES];
			[etvvc release];			
			break;
		}
		case 2: {
			// default tags
			EditTextViewViewController *etvvc = [[EditTextViewViewController alloc] init];
			etvvc.editedObject = item;
			etvvc.textValue = item.default_tags;
			etvvc.editedFieldKey = @"default_tags";
			etvvc.title = @"Default Tags";
			[self.navigationController pushViewController:etvvc animated:YES];
			[etvvc release];						
			break;
		}
		case 3:
			// color
			// TODO custom color picker
			break;
		case 4:
			// group - private/public
			// TODO choose list
			break;
		case 5:
			// display_total
			// nothing
			break;
		case 6: {
			// initial value
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = item;
			etfvc.textValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.initial_value]];
			etfvc.editedFieldKey = @"initial_value";
			etfvc.title = @"Initial Value";
			etfvc.numberEditing = YES;
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];			
			break;
		}
		case 7: {
			// goal
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = item;
			etfvc.textValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.goal]];
			etfvc.editedFieldKey = @"goal";
			etfvc.title = @"Goal";
			etfvc.numberEditing = YES;
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];				
			break;
		}
		case 8: {
			// default_step
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = item;
			etfvc.textValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:item.default_step]];
			etfvc.editedFieldKey = @"default_step";
			etfvc.title = @"Default Step";
			etfvc.numberEditing = YES;
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];							
			break;
		}
		case 9:
			// count_updown
			// TODO choose list
			break;
		case 10:
			// created_on
			// TODO date picker
			break;
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
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
    [super dealloc];
	
	[item release];
}


@end

