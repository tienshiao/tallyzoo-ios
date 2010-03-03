//
//  SyncViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Syncer.h"
#import "TZActivity.h"

@interface SyncViewController : UIViewController<UITextFieldDelegate, SyncerDelegate> {
	NSString *original_username;
	UITextField *usernameField;
	UITextField *passwordField;
	
	UIProgressView *progressView;
	
	UIButton *syncButton;
	UIButton *signupButton;
	
	UILabel *lastLabel;
}
@end
