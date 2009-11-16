//
//  SyncViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZActivity.h"

@interface SyncViewController : UIViewController<UITextFieldDelegate> {
	NSString *original_username;
	UITextField *usernameField;
	UITextField *passwordField;
	
	UIProgressView *progressView;
	
	UIButton *syncButton;
	UIButton *signupButton;
	
	UILabel *lastLabel;
	NSString *lastSync;
	NSDate *now;
	int state;
	NSURLConnection *connection;
	NSMutableData *receivedData;
	NSMutableArray *syncQueue;
	int syncTotal;
	NSString *apiURL;
	
	NSXMLParser *xmlParser;
	TZActivity *currentActivity;
	BOOL activityNewer;
	NSMutableArray *counts;
}

#define STATE_RECEIVING 1
#define STATE_UPDATING 2

@end
