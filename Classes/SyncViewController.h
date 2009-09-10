//
//  SyncViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SyncViewController : UIViewController<UITextFieldDelegate> {
	UITextField *usernameField;
	UITextField *passwordField;
	
	UIButton *syncButton;
}

@end
