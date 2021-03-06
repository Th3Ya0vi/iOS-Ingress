//
//  RecruitViewController.m
//  Ingress
//
//  Created by Alex Studnicka on 12.01.13.
//  Copyright (c) 2013 A&A Code. All rights reserved.
//

#import "RecruitViewController.h"
#import "DAKeyboardControl.h"


@implementation RecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	inviteTextField.font = [UIFont fontWithName:@"Coda-Regular" size:15];
	inviteButton.titleLabel.font = [UIFont fontWithName:@"Coda-Regular" size:15];
	inviteLabel.font = [UIFont fontWithName:@"Coda-Regular" size:12];
	
	__weak typeof(self) weakSelf = self;
	__weak typeof(inviteContainerView) weakInviteContainerView = inviteContainerView;
	
	[self.view setKeyboardTriggerOffset:32];
	[self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
		CGRect inviteContainerViewFrame = weakInviteContainerView.frame;
		if (keyboardFrameInView.origin.y > weakSelf.view.frame.size.height) {
			inviteContainerViewFrame.origin.y = weakSelf.view.frame.size.height - inviteContainerViewFrame.size.height;
		} else {
			inviteContainerViewFrame.origin.y = keyboardFrameInView.origin.y - inviteContainerViewFrame.size.height;
		}
		weakInviteContainerView.frame = inviteContainerViewFrame;
	}];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadNumberOfInvites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNumberOfInvites {
	
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.userInteractionEnabled = NO;
	//HUD.labelText = @"Loading...";
	//HUD.labelFont = [UIFont fontWithName:@"Coda-Regular" size:16];
	[self.view addSubview:HUD];
	[HUD show:YES];
	
	[[API sharedInstance] loadNumberOfInvitesWithCompletionHandler:^(int numberOfInvites) {
		
		[HUD hide:YES];
		
		[inviteLabel setText:[NSString stringWithFormat:@"%d invites remaining", numberOfInvites]];
		
	}];
	
}

- (IBAction)invite {
	
	NSString *email = inviteTextField.text;
	inviteTextField.text = @"";
	[inviteTextField resignFirstResponder];

	if (!email || email.length < 1) {
		[[SoundManager sharedManager] playSound:@"Sound/sfx_ui_fail.aif"];
		return;
	}
	
	[[SoundManager sharedManager] playSound:@"Sound/sfx_ui_success.aif"];
	
	
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
	HUD.userInteractionEnabled = NO;
	HUD.labelText = @"No invites remaining!";
	HUD.labelFont = [UIFont fontWithName:@"Coda-Regular" size:16];
	[self.view addSubview:HUD];
	[HUD show:YES];
	[HUD hide:YES afterDelay:3];
	
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[[SoundManager sharedManager] playSound:@"Sound/sfx_ui_success.aif"];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self invite];
	return NO;
}

@end
