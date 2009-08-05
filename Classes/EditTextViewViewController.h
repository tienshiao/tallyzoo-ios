//
//  EditTextViewViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditTextViewViewController : UITableViewController {
	UITextView *textView;
	NSString *textValue;
	id editedObject;
	NSString *editedFieldKey;
}

@property (copy, nonatomic) NSString *textValue;
@property (assign, nonatomic) id editedObject;
@property (copy, nonatomic) NSString *editedFieldKey;

@end
