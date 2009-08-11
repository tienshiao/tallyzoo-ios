//
//  ColorPickerViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorPickerViewController : UITableViewController {
	UIColor *colorValue;
	id editedObject;
	NSString *editedFieldKey;
	
	int old_row;
	UIColor	*customColor;
}

@property (nonatomic, retain) UIColor *colorValue;
@property (assign, nonatomic) id editedObject;
@property (copy, nonatomic) NSString *editedFieldKey;
@property (nonatomic, retain) UIColor *customColor;

@end
