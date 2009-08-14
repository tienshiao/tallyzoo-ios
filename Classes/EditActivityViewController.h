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

@class EditActivityViewController;

@interface EditActivityViewController : UITableViewController {
	TZActivity *activity;
	
	ColorView *colorView;
	
	UISwitch *showPublicSwitch;
	UISwitch *showCountSwitch;
	
	// TODO support a dirty flag for save button
}

@property(nonatomic, retain) TZActivity *activity;

- (id)initWithActivity:(TZActivity *)a;

@end
