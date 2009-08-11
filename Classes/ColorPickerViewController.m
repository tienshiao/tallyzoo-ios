//
//  ColorPickerViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "CustomColorViewController.h";
#import "UIColor-Expanded.h"

@implementation ColorPickerViewController

@synthesize colorValue;
@synthesize editedObject;
@synthesize editedFieldKey;
@synthesize customColor;

- (id)init {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					   target:self 
																					   action:@selector(save:)];
		self.navigationItem.rightBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	  target:self 
																	  action:@selector(cancel:)];
		self.navigationItem.leftBarButtonItem = barButtonItem;
		[barButtonItem release];
		
		//old_row = -1;
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

- (int)getColorRow {
	if ([[colorValue hexStringFromColor] isEqual:[[UIColor blackColor] hexStringFromColor]]) {
		return 0;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor blueColor] hexStringFromColor]]) {
		return 1;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor brownColor] hexStringFromColor]]) {
		return 2;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor cyanColor] hexStringFromColor]]) {
		return 3;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor darkGrayColor] hexStringFromColor]]) {
		return 4;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor grayColor] hexStringFromColor]]) {
		return 5;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor greenColor] hexStringFromColor]]) {
		return 6;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor lightGrayColor] hexStringFromColor]]) {
		return 7;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor magentaColor] hexStringFromColor]]) {
		return 8;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor orangeColor] hexStringFromColor]]) {
		return 9;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor purpleColor] hexStringFromColor]]) {
		return 10;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor redColor] hexStringFromColor]]) {
		return 11;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor whiteColor] hexStringFromColor]]) {
		return 12;
	} else if ([[colorValue hexStringFromColor] isEqual:[[UIColor yellowColor] hexStringFromColor]]) {
		return 13;
	} else {
		return -1;
	}
}

- (void)generateRandomCustomColor {
	self.customColor = [[UIColor blueColor] retain];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	int temp = [self getColorRow];
	if (temp >= 0) {
		// found a match
		old_row = temp;
		if (customColor == nil) {
			[self generateRandomCustomColor];
		}
	} else {
		self.customColor = self.colorValue;
		old_row = 14;
	}
	
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
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 15;
	} else {
		return 1;
	}
}


#define COLOR_TAG 1

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {    
		static NSString *ColorCellIdentifier = @"Color Cell";
    
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ColorCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ColorCellIdentifier] autorelease];
		
			UIView *colorSample = [[UIView alloc] initWithFrame:CGRectMake(10, 1, 20, cell.frame.size.height - 1)];
			colorSample.tag = COLOR_TAG;
			[cell addSubview:colorSample];
			[colorSample release];
		
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		// Set up the cell...
	
		CGRect r = cell.textLabel.frame;
		r.origin.x = 50;
		cell.textLabel.frame = r;
		
		switch (indexPath.row) {
			case 0: {
				cell.textLabel.text = @"Black";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor blackColor]];
				break;
			}
			case 1: {
				cell.textLabel.text = @"Blue";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor blueColor]];
				break;
			}
			case 2: {
				cell.textLabel.text = @"Brown";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor brownColor]];
				break;
			}
			case 3: {
				cell.textLabel.text = @"Cyan";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor cyanColor]];
				break;
			}
			case 4: {
				cell.textLabel.text = @"Dark Gray";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor darkGrayColor]];
				break;
			}
			case 5: {
				cell.textLabel.text = @"Gray";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor grayColor]];
				break;
			}
			case 6: {
				cell.textLabel.text = @"Green";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor greenColor]];
				break;
			}
			case 7: {
				cell.textLabel.text = @"Light Gray";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor lightGrayColor]];
				break;
			}
			case 8: {
				cell.textLabel.text = @"Magenta";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor magentaColor]];
				break;
			}
			case 9: {
				cell.textLabel.text = @"Orange";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor orangeColor]];
				break;
			}
			case 10: {
				cell.textLabel.text = @"Purple";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor purpleColor]];
				break;
			}
			case 11: {
				cell.textLabel.text = @"Red";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor redColor]];
				break;
			}	
			case 12: {
				cell.textLabel.text = @"White";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor whiteColor]];
				break;
			}
			case 13: {
				cell.textLabel.text = @"Yellow";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:[UIColor yellowColor]];
				break;
			}
			case 14: {
				cell.textLabel.text = @"Custom";
				[[cell viewWithTag:COLOR_TAG] setBackgroundColor:customColor];
				break;
			}				
		}
		
		if ([[colorValue hexStringFromColor] isEqual:[[[cell viewWithTag:COLOR_TAG] backgroundColor] hexStringFromColor]]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			if (old_row == -1) {
				old_row = indexPath.row;
			}
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		return cell;
	} else {
		static NSString *CustomCellIdentifier = @"Custom Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		// Set up the cell...
		cell.textLabel.text = @"Edit Custom Color";

		return cell;
	}
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if (indexPath.section == 0) {
	
		if (old_row == indexPath.row) {
			return;
		}
		
		NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:old_row inSection:0];
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
		if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
			oldCell.accessoryType = UITableViewCellAccessoryNone;
		}	
		
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		if (newCell.accessoryType == UITableViewCellAccessoryNone) {
			newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		
		old_row = indexPath.row;
		self.colorValue = [[newCell viewWithTag:COLOR_TAG] backgroundColor];
	} else {
		CustomColorViewController *ccvc = [[CustomColorViewController alloc] init];
		ccvc.editedObject = self;
		ccvc.colorValue = customColor;
		ccvc.editedFieldKey = @"customColor";
		ccvc.title = @"Custom Color";
		[self.navigationController pushViewController:ccvc animated:YES];
		[ccvc release];							
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

- (void)save:(id)sender {
	[editedObject setValue:colorValue forKey:editedFieldKey];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
	
	[colorValue release];
	[customColor release];
}


@end

