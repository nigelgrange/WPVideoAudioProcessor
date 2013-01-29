//
//  WPVideoAudioProcessorController.h
//  WPVideoAudioProcessor
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPVideoAudioProcessorDelegate.h"

@class AVAudioMix;
@class AVAssetTrack;

@interface WPVideoAudioProcessorController : NSObject

-(id)initWithAudioAssetTrack:(AVAssetTrack *)audioAssetTrack;

@property (readonly, nonatomic) AVAssetTrack *audioAssetTrack;
@property (readonly, nonatomic) AVAudioMix *audioMix;
@property (nonatomic, weak) id<WPVideoAudioProcessorDelegate> audioProcessingDelegate;

@end
