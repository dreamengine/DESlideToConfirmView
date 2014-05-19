//
//  DESlideToConfirmView.m
//
//  Created by Jeremy Flores on 6/6/13.
//  Copyright (c) 2013 Dream Engine Interactive, Inc. All rights reserved.
//

#import "DESlideToConfirmView.h"

#import <QuartzCore/QuartzCore.h>


@implementation DESlideToConfirmDefaultThumb

-(id) initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.cornerRadius = 10.f;
        self.backgroundColor = [UIColor whiteColor];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               0,
                                                               frame.size.width-10,
                                                               frame.size.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.center = self.center;
        _textLabel.text = @"Confirm →";
        [self addSubview:_textLabel];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _textLabel.frame = CGRectMake(5,
                                  0,
                                  self.frame.size.width-10,
                                  self.frame.size.height);
}

-(void)setCornerRadius:(float)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
    }
}

@end



@interface DESlideToConfirmView ()

@property (strong, nonatomic) DESlideToConfirmDefaultThumb *defaultThumb;
@property (strong, nonatomic) UIView *defaultTrackView;

@property (readonly, nonatomic) UIView *thumb;
@property (readonly, nonatomic) UIView *trackView;

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;

-(void)setup;

@end


@implementation DESlideToConfirmView

@dynamic thumb;
@dynamic trackView;

-(id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.resetsWhenCompleted = YES;
    self.completionResetDelay = 0.3f;
    self.resetAnimationDuration = 0.2f;
    self.defaultThumbWidth = 100.f;
    _currentState = DESlideToConfirmViewStateIdle;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                 action: @selector(panUpdated:)];
    [self addGestureRecognizer:self.panRecognizer];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.defaultThumb removeFromSuperview];
    [self.customThumbView removeFromSuperview];
    [self.defaultTrackView removeFromSuperview];
    [self.customTrackView removeFromSuperview];
    
    CGRect frame;
    frame = self.trackView.frame;
    frame.origin.x = self.thumb.frame.size.width/2;
    frame.origin.y = self.frame.size.height/2 - frame.size.height/2;
    frame.size.width = self.frame.size.width - self.thumb.frame.size.width;
    self.trackView.frame = frame;
    
    [self addSubview:self.trackView];
    
    frame = self.thumb.frame;
    frame.origin.x = 0.f;
    frame.origin.y = 0.f;
    if ([self.thumb isEqual:self.defaultThumb]) {
        frame.size.width = self.defaultThumbWidth;
    }
    self.thumb.frame = frame;
    
    [self addSubview:self.thumb];
    
}


#pragma mark - Gesture Recognizer

-(void)panUpdated:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    
    __block UIView *thumb = self.thumb;
    
    float xLocation = location.x;
    
    if (xLocation < thumb.frame.size.width/2) {
        xLocation = thumb.frame.size.width/2;
    }
    
    if (xLocation > self.frame.size.width-thumb.frame.size.width/2) {
        xLocation = self.frame.size.width-thumb.frame.size.width/2;
    }
    
    CGPoint center = thumb.center;
    center.x = xLocation;
    thumb.center = center;
    
    self.currentState = DESlideToConfirmViewStateUpdating;
    if (self.updateBlock) {
        float percentage = (thumb.center.x - thumb.frame.size.width / 2) / self.trackView.frame.size.width;
        self.updateBlock(self, percentage);
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        float difference = fabsf(thumb.center.x-(self.frame.size.width-thumb.frame.size.width/2));
        
        float tolerance = 1.f;
        if (difference < tolerance) {
            self.currentState = DESlideToConfirmViewStateCompleted;
        }
        else {
            [self performResetAnimation:NO];
        }
    }
}


#pragma mark - Getters/Setters

-(void)setCurrentState:(DESlideToConfirmViewState)currentState {
    if (_currentState != currentState) {
        _currentState = currentState;
        
        switch (_currentState) {
            case DESlideToConfirmViewStateIdle:
                if (self.idleBlock) {
                    self.idleBlock(self);
                }
                break;
            case DESlideToConfirmViewStateCompleted:
                if (self.completeBlock) {
                    self.completeBlock(self);
                }
                
                if (self.resetsWhenCompleted) {
                    [self performResetAnimation:YES];
                }
                break;
            default:
                break;
        }
    }
}

-(void)performResetAnimation:(BOOL)isCompletionAnimation {
    __weak DESlideToConfirmView *weakSelf = self;
    
    float delay;
    if (isCompletionAnimation) {
        delay = self.completionResetDelay;
    }
    else {
        delay = 0.f;
    }
    
    [UIView animateWithDuration: self.resetAnimationDuration
                          delay: delay
                        options: 0
                     animations:
     ^{
         weakSelf.panRecognizer.enabled = NO;
         CGRect frame = self.thumb.frame;
         frame.origin.x = 0.f;
         weakSelf.thumb.frame = frame;
     }
                     completion:
     ^(BOOL finished) {
         weakSelf.panRecognizer.enabled = YES;
         weakSelf.currentState = DESlideToConfirmViewStateIdle;
     }];
}

-(UIView *)thumb {
    UIView *thumb;
    if (self.customThumbView) {
        thumb = self.customThumbView;
    }
    else {
        thumb = self.defaultThumb;
    }
    
    return thumb;
}

-(UIView *)trackView {
    UIView *trackView;
    if (self.customTrackView) {
        trackView = self.customTrackView;
    }
    else {
        trackView = self.defaultTrackView;
    }
    
    return trackView;
}

-(DESlideToConfirmDefaultThumb *)defaultThumb {
    if (!_defaultThumb) {
        _defaultThumb = [[DESlideToConfirmDefaultThumb alloc] initWithFrame:CGRectMake(0,
                                                                                       0,
                                                                                       self.defaultThumbWidth,
                                                                                       self.frame.size.height)];
    }
    
    return _defaultThumb;
}

-(UIView *)defaultTrackView {
    if (!_defaultTrackView) {
        _defaultTrackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,1)];
        _defaultTrackView.backgroundColor = self.defaultTrackColor;
    }
    
    return _defaultTrackView;
}

-(UIColor *)defaultTrackColor {
    if (!_defaultTrackColor) {
        _defaultTrackColor = [UIColor blackColor];
    }
    
    return _defaultTrackColor;
}

-(void)setCustomThumbView:(UIView *)customThumbView {
    if (![_customThumbView isEqual:customThumbView]) {
        _customThumbView = customThumbView;
        [self setNeedsLayout];
    }
}

-(void)setCustomTrackView:(UIView *)customTrackView {
    if (![_customTrackView isEqual:customTrackView]) {
        _customTrackView = customTrackView;
        [self setNeedsLayout];
    }
}

-(void)setDefaultThumbWidth:(float)defaultThumbWidth {
    if (_defaultThumbWidth != defaultThumbWidth) {
        _defaultThumbWidth = defaultThumbWidth;
        [self setNeedsLayout];
    }
}


@end
