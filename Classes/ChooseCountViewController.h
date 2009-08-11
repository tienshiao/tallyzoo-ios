//
//  ChooseCountViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChooseCountViewController : UITableViewController {
	NSInteger selection;
	id editedObject;
	NSString *editedFieldKey;
}

@property (assign, nonatomic) NSInteger selection;
@property (assign, nonatomic) id editedObject;
@property (copy, nonatomic) NSString *editedFieldKey;

@end
