//
//  EditCountViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZCount.h"

@interface EditCountViewController : UITableViewController {
	TZCount *count;
}

@property (nonatomic, retain) TZCount *count;

- (id)initWithCount:(TZCount *)c;

@end
