//
//  DemoAudioProcessorViewController.h
//  VideoAudioProcessorDemo
//
//  Created by Nigel Grange on 28/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
@class WPVideoAudioProcessorController;
@class TestWPAudioProcessorBandPass;
@class TestWPAudioProcessorMono;

@interface DemoAudioProcessorViewController : UIViewController

@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) WPVideoAudioProcessorController* audioProcessor;

@property (nonatomic, strong) TestWPAudioProcessorBandPass* processor;

@property (nonatomic, strong) UISlider* fxSlider;

@end
