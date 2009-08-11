//
//  AddItemViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZItem.h"

@class EditItemViewController;

@interface EditItemViewController : UITableViewController {
	TZItem *item;
	
	UISwitch *showPublicSwitch;
	UISwitch *showCountSwitch;
}

@property(nonatomic, retain) TZItem *item;

- (id)initWithItem:(TZItem *)i;

@end
