//
//  AddItemViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZActivity.h"
#import "ColorView.h"

@class EditItemViewController;

@interface EditItemViewController : UITableViewController {
	TZActivity *item;
	
	ColorView *colorView;
	
	UISwitch *showPublicSwitch;
	UISwitch *showCountSwitch;
	
	// TODO support a dirty flag for save button
}

@property(nonatomic, retain) TZActivity *item;

- (id)initWithItem:(TZActivity *)i;

@end
