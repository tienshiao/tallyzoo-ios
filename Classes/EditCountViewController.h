//
//  EditCountViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZCount.h"

@interface EditCountViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	TZCount *count;
	
	UITableView *tableView;
	UIDatePicker *datePicker;
	UIButton *deleteButton;
	
	NSDate *created;
	NSDateFormatter *dateFormatter;
	BOOL datePickerShown;
	
	BOOL nonmodal;
}

@property (nonatomic, retain) TZCount *count;
@property (nonatomic, retain) NSDate *created;

- (id)initWithCount:(TZCount *)c;
- (id)initNonModalWithCount:(TZCount *)c;

@end
