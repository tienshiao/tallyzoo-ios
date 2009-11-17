//
//  PasswordAlert.h
//  iControl
//
//  Created by Tienshiao Ma on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldAlertDelegate <NSObject>
@optional
-(void)alertCancelled;
-(void)alertReturnedString:(NSString *)string;
@end

@interface TextFieldAlert : NSObject<UIAlertViewDelegate> {
	UIAlertView *alertView;
	UITextField *textField;
	UILabel *messageLabel;
	
	id delegate;
	NSString *title;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, copy) NSString* title;


- (void)show;

@end
