//
//  DemoAudioProcessorViewController.m
//  VideoAudioProcessorDemo
//
//  Created by Nigel Grange on 28/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "DemoAudioProcessorViewController.h"
#import "WPVideoAudioProcessorController.h"
#import "WPVideoAudioBasicProcessor.h"
#import "TestWPAudioProcessorMono.h"
#import "TestWPAudioProcessorBandPass.h"



@interface DemoAudioProcessorViewController ()

@end

@implementation DemoAudioProcessorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Example URL
    NSURL* url = [NSURL URLWithString:@"http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_640x360.m4v"];
    
    
    self.player = [AVPlayer playerWithURL:url];
    
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [playerLayer setFrame:CGRectMake(0, 0, 480, 320)];
    [self.view.layer addSublayer:playerLayer];
    
    [self.player addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    
    
    self.fxSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 280, 480-80, 40)];
    self.fxSlider.minimumValue = 0.0;
    self.fxSlider.maximumValue = 0.5;
    self.fxSlider.value = 0.25;
    [self.fxSlider addTarget:self action:@selector(fxSliderUpdated:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fxSlider];
    
}

-(void)fxSliderUpdated:(UISlider*)slider
{
    double val = slider.value;
    [self.processor setCenterFrequency:val];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WPVideoAudioProcessorController *)audioProcessor
{
	if (!_audioProcessor)
	{
		AVAssetTrack *firstAudioAssetTrack;
		for (AVAssetTrack *assetTrack in self.player.currentItem.asset.tracks)
		{
			if ([assetTrack.mediaType isEqualToString:AVMediaTypeAudio])
			{
				firstAudioAssetTrack = assetTrack;
				break;
			}
		}
		if (firstAudioAssetTrack)
		{
			_audioProcessor = [[WPVideoAudioProcessorController alloc] initWithAudioAssetTrack:firstAudioAssetTrack];
            
            // Select concrete audio processor
            
            
            // self.processor = [[TestWPAudioProcessorMono alloc] init];    // Example of processing samples manually
            self.processor = [[TestWPAudioProcessorBandPass alloc] init];   // Example using Audio Unit for processing
            
            _audioProcessor.audioProcessingDelegate = self.processor;
		}
	}
	return _audioProcessor;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id newValue = change[NSKeyValueChangeNewKey];
    if (newValue && [newValue isKindOfClass:[NSNumber class]])
    {
        if (AVPlayerStatusReadyToPlay == [newValue integerValue])
        {
            // Ready to play
            
            // Add audio mix with audio tap processor to current player item.
            AVAudioMix *audioMix = self.audioProcessor.audioMix;
            if (audioMix)
            {
                // Add audio mix with first audio track.
                self.player.currentItem.audioMix = audioMix;
            }
            
            self.player.rate = 1.0;
        }
    }
}



@end
