//
//  ChooseBadgeViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChooseBadgeViewController : UITableViewController {
	NSInteger selection;
	NSInteger display_total;
	id editedObject;
	NSString *editedFieldKey;
}

@property (assign, nonatomic) NSInteger display_total;
@property (assign, nonatomic) id editedObject;
@property (copy, nonatomic) NSString *editedFieldKey;

@end
