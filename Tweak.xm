//Created by Lucas Jackson
//Tinder+-
//October 2016
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

%hook TNDRRecommendationViewController

MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectZero];
UISlider *volumeViewSlider = nil;
bool isChanging = false;

//override existing function by writing them here
//all other functions still exist even though they aren't written
- (void)viewDidLoad {
	%orig;
	
	//show an alert cause we can
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tinder+-"
    	message:@"Use up volume to like, down volume to pass... or keep holding one down to have some fun ;)"
        delegate:self
        cancelButtonTitle:@"Dismiss"
        otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	//disable HUD displaying using custom view (preset frame to CGRectZero ^)
	UIView *hudview = [(UIViewController *)self view];
	[hudview addSubview:volumeView];

	//get volume slider so we can change system volume
	for (UIView *view in [volumeView subviews]){
		NSString *className = NSStringFromClass([view class]);
	    if ([className isEqualToString:@"MPVolumeSlider"]){
	        volumeViewSlider = (UISlider*)view;
	        volumeViewSlider.value = 0.5;
	        //listen for volume changes
	        [volumeViewSlider addTarget:(UIViewController *)self action:@selector(didchangevolume) forControlEvents:UIControlEventValueChanged];
	        break;
	    }
	}
}

//we can use %new to create new functions in this class

%new
-(void)didchangevolume {
	//prevent loop of death
	if (isChanging) {
		return;
	}
	
	//based on the difference from 0.5 we can decide weather it was a down volume press, or an up volume press	

	isChanging = true;
	if (volumeViewSlider.value > 0.5) {
		//swipe right function
		[self performSelector:@selector(notifyInteractionHandlerOfTapRight)];
		volumeViewSlider.value = 0.5;
	}
	else if (volumeViewSlider.value < 0.5){
		//swipe left function
		[self performSelector:@selector(notifyInteractionHandlerOfTapLeft)];
		volumeViewSlider.value = 0.5;
	}
	isChanging = false;		
}

%end
