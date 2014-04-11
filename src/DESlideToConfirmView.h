//
//  DESlideToConfirmView.h
//
//  Created by Jeremy Flores on 6/6/13.
//  Copyright (c) 2013 Dream Engine Interactive, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DESlideToConfirmDefaultThumb : UIView

/*
 
 Corner radius for the thumb.
 
 Default is 10.f.
 
 */
@property (nonatomic) float cornerRadius;

@property (readonly, strong, nonatomic) UILabel *textLabel;

@end



/*
 
 By default, the thumb will idle to the far left of the view, during which it is in an idle state. When the user is sliding the thumb in either direction, the thumb will be in an updating state.
 
 If the user cancels the gesture before moving the thumb to the completion location, then the view will automatically animate the thumb back to the idle location--during this animation, the thumb will continue to be in an updating state but will not call the updating block. Once the animation is complete, the idle block will be called.
 
 Finally, if the user completes the slide gesture and successfully moves the thumb to the far right of the view, the thumb will be in a completed state. If resetsWhenCompleted==YES, then there will be an animation moving the thumb back to the idle location. For this animation, the thumb will be in an updating state but will not call the updating block. Once this animation is complete, the idle block will be called.
 
 */
typedef enum DESlideToConfirmViewState {
    DESlideToConfirmViewStateIdle,  // thumb is idling at the beginning location.
    DESlideToConfirmViewStateUpdating,  // thumb is being controlled by the user
    DESlideToConfirmViewStateCompleted, // thumb is resting at the end location
} DESlideToConfirmViewState;

@class DESlideToConfirmView;

typedef void (^DESlideToConfirmViewDidIdleBlock)(DESlideToConfirmView *slideView);
typedef void (^DESlideToConfirmViewDidUpdateBlock)(DESlideToConfirmView *slideView, float percentage);
typedef void (^DESlideToConfirmViewDidCompleteBlock)(DESlideToConfirmView *slideView);


@interface DESlideToConfirmView : UIView


/*
 
 A custom thumb that will be used in place of the default thumb.
 
 */
@property (strong, nonatomic) UIView *customThumbView;


/*
 
 The default thumb. This will only be used if no custom thumb is provided.
 
 */
@property (readonly, strong, nonatomic) DESlideToConfirmDefaultThumb *defaultThumb;


/*
 
 The width of the default thumb. This will only be used if no custom thumb is provided.
 
 Default is 100.f.
 
 */
@property (nonatomic) float defaultThumbWidth;


/*
 
 A custom track that will be used in place of the default track view.
 
 */
@property (strong, nonatomic) UIView *customTrackView;


/*
 
 The default track view. It is an empty UIView with a height of 1, emulating a line.
 
 */
@property (readonly, strong, nonatomic) UIView *defaultTrackView;


/*
 
 The color of the default track along which the thumb will move.
 
 Default is [UIColor blackColor].
 
 */
@property (strong, nonatomic) UIColor *defaultTrackColor;


/*
 
 Whether or not the widget will automatically move the thumb back to the idle position once the user completed the gesture.
 
 Default is YES.
 
 */
@property (nonatomic) BOOL resetsWhenCompleted;

/*
 
 The amount of time, in seconds, before the animation to move the thumb back to the idle position takes place after the user completed the slide gesture. This will only be used if resetsWhenCompleted==YES.

 Default is 0.3f.
 
 */
@property (nonatomic) NSTimeInterval completionResetDelay;

/*
 
 The amount of time, in seconds, for the animation moving the thumb to the idle position. This will be used both for canceled slide gestures as well as when the user completes the gesture and resetsWhenCompleted==YES.

 Default is 0.2f;
 
 */
@property (nonatomic) NSTimeInterval resetAnimationDuration;


/*
 
 The current state of the view.
 
 Default is DESlideToConfirmViewStateIdle.
 
 Manually setting these values will also call the state's respective blocks.

 */
@property (nonatomic) DESlideToConfirmViewState currentState;


@property (copy, nonatomic) DESlideToConfirmViewDidIdleBlock idleBlock;

@property (copy, nonatomic) DESlideToConfirmViewDidUpdateBlock updateBlock;

@property (copy, nonatomic) DESlideToConfirmViewDidCompleteBlock completeBlock;

@end
