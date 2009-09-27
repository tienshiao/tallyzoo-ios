//
//  CountsViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZActivity.h"


@interface CountsViewController : UITableViewController {
	TZActivity *activity;
	
	NSNumberFormatter *formatter;
}

@property (nonatomic, retain) TZActivity *activity;

- (id)initWithActivity:(TZActivity *)a;

@end
