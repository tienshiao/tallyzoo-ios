//
//  EditCountViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditCountViewController.h"
#import "EditTextFieldViewController.h"
#import "EditTextViewViewController.h"

@implementation EditCountViewController
@synthesize count;
@synthesize created;

- (id)initNonModalWithCount:(TZCount *)c {
	nonmodal = YES;
	if (self = [self initWithCount:c]) {
	}
	
	return self;
}

- (id)initWithCount:(TZCount *)c {
	if (self = [super init]) {
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
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		self.created = [dateFormatter dateFromString:c.created_on];
	}
	return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *containerView = [[UIView alloc] init];
	containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.view = containerView;
	[containerView sizeToFit];
	
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	[containerView addSubview:tableView];
	
	datePicker = [[UIDatePicker alloc] init];
	[containerView addSubview:datePicker];
	datePickerShown = NO;
	datePicker.date = created;
	[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	
	if (count.key) {
		deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
		[deleteButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
		deleteButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
		[deleteButton setTitle:@"Delete Count" forState:UIControlStateNormal];
		
		UIImage *image = [UIImage imageNamed:@"red_up.png"];
		UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
		[deleteButton setBackgroundImage:newImage forState:UIControlStateNormal];
		
		UIImage *imagePressed = [UIImage imageNamed:@"red_down.png"];
		UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
		[deleteButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
		
		deleteButton.frame = CGRectMake(10, 20, 300, 40);
		[deleteButton addTarget:self action:@selector(deleteCount:) forControlEvents:UIControlEventTouchUpInside];
		
		tableView.tableFooterView = deleteButton;
	}
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[tableView reloadData];	

	CGRect r = datePicker.frame;
	r.origin.y = datePicker.superview.frame.size.height;
	datePicker.frame = r;
	
	r = tableView.frame;
	r.size.height = tableView.superview.frame.size.height;
	tableView.frame = r;
	
}

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

- (void)dateChanged:(id)sender {
	self.created = datePicker.date;
	[tableView reloadData];
}

- (void)showDatePicker {
	if (datePickerShown) {
		return;
	}
	
	CGRect r = datePicker.frame;
	double dHeight = r.size.height;
	
	[UIView beginAnimations:@"showDatePicker" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:.25];
	
	r.origin.y = r.origin.y - dHeight;
	datePicker.frame = r;
	
	r = tableView.frame;
	r.size.height = r.size.height - dHeight;
	tableView.frame = r;
	
	[UIView commitAnimations];		
	
	datePickerShown = YES;
}

- (void)hideDatePicker {
	if (!datePickerShown) {
		return;
	}
	
	CGRect r = datePicker.frame;
	double dHeight = r.size.height;
	
	[UIView beginAnimations:@"hideDatePicker" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:.25];
	
	r.origin.y = r.origin.y + dHeight;
	datePicker.frame = r;
	
	r = tableView.frame;
	r.size.height = r.size.height + dHeight;
	tableView.frame = r;
	
	[UIView commitAnimations];			
	
	datePickerShown = NO;
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
			cell.textLabel.text = @"Created";
			cell.detailTextLabel.text = [dateFormatter stringFromDate:created];
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
			[self hideDatePicker];
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
			[self hideDatePicker];
			break;
		}
		case 2: {
			// created_on
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			if (datePickerShown) {
				[self hideDatePicker];
			} else {
				[self showDatePicker];
			}
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

- (void)deleteCount:(id)sender {
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:@"Delete Count" 
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.navigationController.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0) {
		count.deleted = YES;
		[count save];
		if (nonmodal) {
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self.navigationController dismissModalViewControllerAnimated:YES];		
		}
	}
}

- (void)cancel:(id)sender {
	if (nonmodal) {
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
}

- (void)save:(id)sender {
	count.created_on = [dateFormatter stringFromDate:created];
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[dateFormatter setTimeZone:timeZone];
	count.created_on_UTC = [dateFormatter stringFromDate:created];
	
	if (![count save]) {
	}
	if (nonmodal) {
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
}


- (void)dealloc {
    [super dealloc];

	[tableView release];
	[datePicker release];
	[deleteButton release];
	
	[dateFormatter release];
}


@end
