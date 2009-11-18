//
//  TextFieldAlert.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextFieldAlert.h"


@implementation TextFieldAlert
@synthesize title;

- (id)init {
	if (self = [super init]) {
		NSString *blank = @"Only data on this iPhone will be cleared. The data synced to the website will not be affected.\n          ";
		alertView = [[UIAlertView alloc] initWithTitle:@"Clear Data?" 
											   message:blank
											  delegate:self 
									 cancelButtonTitle:@"Cancel" 
									 otherButtonTitles:@"Clear", nil];
		
		for (id v in [alertView subviews]) {
			if ([v isKindOfClass:[UILabel class]]) {
				NSString *t = [v text];
				if (t) {
					if ([t compare:blank] == NSOrderedSame)	{
						messageLabel = v;
						break;
					}
				}
			}
		}
		
		textField = [[UITextField alloc] initWithFrame:CGRectZero];
		[textField setBackgroundColor:[UIColor whiteColor]];
		textField.borderStyle = UITextBorderStyleBezel;
		UIImage *image = [UIImage imageNamed:@"textfield.png"];
		UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
		textField.background = newImage;
		textField.placeholder = @"Enter \"CLEAR\" to confirm";
		//textField.secureTextEntry = YES;
		
		[alertView addSubview:textField];
		
		delegate = nil;
		title = @"Clear Data?";
	}
	return self;
}

- (void)show {
	textField.text = @"";
	alertView.title = title;
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 100.0);
	[alertView setTransform:myTransform];
	[alertView show];
	CGRect frame = messageLabel.frame;
	frame.origin.y = frame.origin.y + frame.size.height - 19;
	frame.size.height = 30.0;
	textField.frame = frame;	
	[textField becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex) {
		if ([delegate respondsToSelector:@selector(alertReturnedString:)]) {
			[delegate alertReturnedString:textField.text];
		}
	} else {
		if ([delegate respondsToSelector:@selector(alertCancelled)]) {
			[delegate alertCancelled];
		}		
	}
}

- (id)delegate {
	return delegate;
}

- (void)setDelegate:(id)del {
	if (delegate != del) {
		if (del) { 
			delegate = del;
		}
	}
}

- (void)dealloc {
	[textField release];
	[alertView release];
	[title release];
	[super dealloc];
}

@end
