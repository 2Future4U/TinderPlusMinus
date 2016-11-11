//Created by Lucas Jackson
//Tinder+-
//October 2016
#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>

%hook TNDRRecommendationViewController

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

MPMusicPlayerController *iPod = [MPMusicPlayerController iPodMusicPlayer];

- (void)viewDidLoad {
	%orig;
	//set original volume to 0.5
	iPod.volume = 0.5;
	
	//show an alert cause we can
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tinder+-"
                        						    message:@"Use up volume to like, down volume to pass... or keep holding one down to have some fun ;)"
                         						   delegate:self
                         				  cancelButtonTitle:@"Dismiss"
                         				  otherButtonTitles:nil];
	[alert show];
	[alert release];

	//activate our listener
	[self performSelector:@selector(activatelistener)];

	//disable HUD displaying by setting custom volume view frame to 0
	MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectZero];
	UIView *hudview = [(UIViewController *)self view];
	[hudview addSubview:volumeView];
}

//we can use %new to create new functions in this class
//we will create listeners using nsnotificationcenter to detect system volume changes

%new
-(void)activatelistener {
	//when volume change listener is triggered, we will call volume did change volume
	//next compare the volume with the original volume that was set when we enter the app (0.5) with the new volume
	[NSNotificationCenter.defaultCenter
	    addObserver:self
	       selector:@selector(didchangevolume)
	           name:@"AVSystemController_SystemVolumeDidChangeNotification"
	         object:nil];
}

%new
-(void)deactivatelistener {
	[[NSNotificationCenter defaultCenter] removeObserver:self 
        											name:@"AVSystemController_SystemVolumeDidChangeNotification" 
       											  object:nil];
}
%new
-(void)didchangevolume {
	//based on the difference from 0.5 we can decide weather it was a down volume press, or an up volume press
	//temporarily deactivate the volume listener to avoid getting stuck in a never ending volume changed loop
	if (iPod.volume > 0.5) {
		[self performSelector:@selector(notifyInteractionHandlerOfTapRight)];
		[self performSelector:@selector(deactivatelistener)];
		iPod.volume = 0.5;
		[self performSelector:@selector(activatelistener)];

	}
	else if (iPod.volume < 0.5){
		[self performSelector:@selector(notifyInteractionHandlerOfTapLeft)];
		[self performSelector:@selector(deactivatelistener)];
		iPod.volume = 0.5;
		[self performSelector:@selector(activatelistener)];
	}
}
#pragma GCC diagnostic pop
%end

