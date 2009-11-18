//
//  MoreTableViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldAlert.h"


@interface MoreTableViewController : UITableViewController<TextFieldAlertDelegate> {
	UIButton *clearButton;
	TextFieldAlert *tfAlert;
}

@end
