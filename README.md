# DESlideToConfirmView
[https://github.com/dreamengine/DESlideToConfirmView](https://github.com/dreamengine/DESlideToConfirmView)

## What It Does

`DESlideToConfirmView` is a block-based widget that allows the user to slide to confirm. Perfect for situations where you really want to make sure the user knows what they're getting into, e.g. permanently deleting data.

![Example gif](DESlideToConfirmView.gif?raw=true)

Caveat emptor: Dream Engine has had apps approved with this widget, but we make no claim as to whether or not it is generally safe for the App Store.

## How It Works

You can instantiate `DESlideToConfirmView` either programmatically or in nibs.


### Subview Components

`DESlideToConfirmView` has two view components: a thumb view, and a track view. By default, the widget has a default thumb and track. The default thumb is a `DESlideToConfirmDefaultThumb` class (included in the .h/.m files) which has a centered label if you just want to get things running. You can also change the default thumb's width using `DESlideToConfirmView`'s `defaultThumbWidth` property.

You can set a custom thumb view using the `customThumbView` property, and you can set a custom track view using the `customTrackView` property. Note that, after setting either one, `DESlideToConfirmView`'s layout will be updated so that the track view's width is equal to the width of the widget minus the width of the thumb view. This will ensure that, at 0%, the center of the thumb view will sit at the left end of the track and, at 100%, the center of the thumb will sit at the right end of the track. Also note that this will be true for any combination of default or custom thumb and track view.

### State Updates

`DESlideToConfirmView` has three possible states: `DESlideToConfirmViewStateIdle`, `DESlideToConfirmViewStateUpdating`, and `DESlideToConfirmViewStateCompleted`. To be notified whenever the state changes, you can set three blocks: the `idleBlock`, `updateBlock` (which send you a percentage complete value), and `completeBlock` properties.

By default, the thumb will idle to the far left of the view, during which it is in an idle state. When the user is sliding the thumb in either direction, the thumb will be in an updating state.
 
If the user cancels the gesture before moving the thumb to the completion location, then the view will automatically animate the thumb back to the idle location--during this animation, the thumb will continue to be in an updating state but will not call the updating block. Once the animation is complete, the idle block will be called.
 
Finally, if the user completes the slide gesture and successfully moves the thumb to the far right of the view, the thumb will be in a completed state. If `resetsWhenCompleted == YES`, then there will be an animation moving the thumb back to the idle location. For this animation, the thumb will be in an updating state but will not call the updating block. Once this animation is complete, the idle block will be called.

#### Example

	-(void)someMethod {
		self.slideToConfirmView.idleBlock = ^(DESlideToConfirmView *slideView) {
			// do something when the widget is idled
		};
		
		self.slideToConfirmView.updateBlock = ^(DESlideToConfirmView *slideView, float percentage) {
			// do something when the widget is updating, e.g. updating the color or opacity of an item as the user approaches the confirmation region
		};
		
		self.slideToConfirmView.completeBlock = ^(DESlideToConfirmView *slideView) {
			// do something when the user has triggered a confirmation
		};
	}



### Animations

`DESlideToConfirmView` also comes with some tweakable animation properties.

If the user fails to drag the thumb to completion, the thumb will be automatically animated back to its idle state. You can set how long that animation will take using the `resetAnimationDuration` property.

You can also choose whether or not the widget should reset to its idling state when the user has achieved a confirmation. To set that, use the `resetsWhenCompleted` property. If set to `YES`, then `resetAnimationDuration` will dictate how long the reset animation takes.

If you do want the widget to reset on gesture completion, you can set a delay so that the thumb will first linger on the far right side before snapping back to the idle position. Use the `completionResetDelay` property to modify this value.