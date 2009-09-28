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

@property (retain, nonatomic) NSString *textValue;
@property (assign, nonatomic) id editedObject;
@property (retain, nonatomic) NSString *editedFieldKey;

@end
