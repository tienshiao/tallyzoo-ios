//
//  EditTextFieldViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditTextFieldViewController : UITableViewController {
	UITextField *textField;
	NSString *textValue;
	id editedObject;
	NSString *editedFieldKey;
	
	BOOL numberEditing;
}

@property (copy, nonatomic) NSString *textValue;
@property (assign, nonatomic) id editedObject;
@property (copy, nonatomic) NSString *editedFieldKey;
@property (assign, nonatomic) BOOL numberEditing;

@end
