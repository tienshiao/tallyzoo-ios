//
//  AddItemViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditActivityViewController.h"
#import "ColorPickerViewController.h"
#import "ChooseCountViewController.h"
#import "EditTextFieldViewController.h"
#import "EditTextViewViewController.h"

@implementation EditActivityViewController

@synthesize activity;

#define COLOR_TAG 1

- (id)initWithActivity:(TZActivity *)a {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.title = @"Activity";
		
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
		
		showPublicSwitch = [[UISwitch alloc] init];
		showPublicSwitch.on = a.public;
		
		showCountSwitch = [[UISwitch alloc] init];
		showCountSwitch.on = a.display_total;
		
		colorView = [[ColorView alloc] initWithFrame:CGRectMake(250, 8, 25, 25)];
		colorView.tag = COLOR_TAG;
		
		self.activity = a;
		
		if (activity.key) {
			deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
			[deleteButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
			deleteButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
			[deleteButton setTitle:@"Delete Activity" forState:UIControlStateNormal];
			
			UIImage *image = [UIImage imageNamed:@"red_up.png"];
			UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
			[deleteButton setBackgroundImage:newImage forState:UIControlStateNormal];
			
			UIImage *imagePressed = [UIImage imageNamed:@"red_down.png"];
			UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
			[deleteButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
			
			deleteButton.frame = CGRectMake(10, 20, 300, 40);
			[deleteButton addTarget:self action:@selector(deleteActivity:) forControlEvents:UIControlEventTouchUpInside];
			
			self.tableView.tableFooterView = deleteButton;			
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
    return 9;
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
    
    // Set up the cell...
	switch (indexPath.row) {
		case 0:
			// name
			cell.textLabel.text = @"Name";
			cell.detailTextLabel.text = activity.name;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 1:
			// default_note
			cell.textLabel.text = @"Note";
			cell.detailTextLabel.text = activity.default_note;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 2:
			// default tags
			cell.textLabel.text = @"Tags";
			cell.detailTextLabel.text = activity.default_tags;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 3:
			// color
			cell.textLabel.text = @"Color";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			colorView.color = activity.color;
			[cell.contentView addSubview:colorView];
			break;
		case 4:
			// group - private/public
			cell.textLabel.text = @"Public";
			cell.accessoryView = showPublicSwitch;
			break;
		case 5:
			// display_total
			cell.textLabel.text = @"Show Count";
			cell.accessoryView = showCountSwitch;
			break;
		case 6:
			// initial value
			cell.textLabel.text = @"Initial Value";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:activity.initial_value]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 7:
			// default_step
			cell.textLabel.text = @"Default Increment";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:activity.default_step]];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 8:
			// count_updown
			cell.textLabel.text = @"Count";
			if (activity.count_updown > 0) {
				cell.detailTextLabel.text = @"count up"; 
			} else {
				cell.detailTextLabel.text = @"count down";
			}
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
			etfvc.editedObject = activity;
			etfvc.textValue = activity.name;
			etfvc.editedFieldKey = @"name";
			etfvc.title = @"Name";
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];
			break;
		}
		case 1: {
			// default_note
			EditTextViewViewController *etvvc = [[EditTextViewViewController alloc] init];
			etvvc.editedObject = activity;
			etvvc.textValue = activity.default_note;
			etvvc.editedFieldKey = @"default_note";
			etvvc.title = @"Default Note";
			[self.navigationController pushViewController:etvvc animated:YES];
			[etvvc release];			
			break;
		}
		case 2: {
			// default tags
			EditTextViewViewController *etvvc = [[EditTextViewViewController alloc] init];
			etvvc.editedObject = activity;
			etvvc.textValue = activity.default_tags;
			etvvc.editedFieldKey = @"default_tags";
			etvvc.title = @"Default Tags";
			[self.navigationController pushViewController:etvvc animated:YES];
			[etvvc release];						
			break;
		}
		case 3: {
			// color
			ColorPickerViewController *cpvc = [[ColorPickerViewController alloc] init];
			cpvc.editedObject = activity;
			cpvc.colorValue = activity.color;
			cpvc.editedFieldKey = @"color";
			cpvc.title = @"Color";
			[self.navigationController pushViewController:cpvc animated:YES];
			[cpvc release];					
			break;
		}
		case 4:
			// group - private/public
			// nothing
			break;
		case 5:
			// display_total
			// nothing
			break;
		case 6: {
			// initial value
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = activity;
			etfvc.textValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:activity.initial_value]];
			etfvc.editedFieldKey = @"initial_value";
			etfvc.sigFieldKey = @"init_sig";
			etfvc.title = @"Initial Value";
			etfvc.numberEditing = YES;
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];			
			break;
		}
		case 7: {
			// default_step
			EditTextFieldViewController *etfvc = [[EditTextFieldViewController alloc] init];
			etfvc.editedObject = activity;
			etfvc.textValue = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:activity.default_step]];
			etfvc.editedFieldKey = @"default_step";
			etfvc.sigFieldKey = @"step_sig";
			etfvc.title = @"Default Step";
			etfvc.numberEditing = YES;
			[self.navigationController pushViewController:etfvc animated:YES];
			[etfvc release];							
			break;
		}
		case 8: {
			// count_updown
			ChooseCountViewController *ccvc = [[ChooseCountViewController alloc] init];
			ccvc.editedObject = activity;
			ccvc.selection = activity.count_updown;
			ccvc.editedFieldKey = @"count_updown";
			ccvc.title = @"Count";
			[self.navigationController pushViewController:ccvc animated:YES];
			[ccvc release];					
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
	if (![activity save]) {
	}
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)deleteActivity:(id)sender {
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:@"Delete Activity" 
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.navigationController.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		activity.deleted = YES;
		[activity save];
		[self.navigationController dismissModalViewControllerAnimated:YES];		
	}
}


- (void)dealloc {
    [super dealloc];
	
	[activity release];
	[showCountSwitch release];
	[colorView release];
	
	[deleteButton release];
}


@end

