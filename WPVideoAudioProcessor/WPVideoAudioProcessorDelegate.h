//
//  WPVideoAudioProcessorDelegate.h
//  WPVideoAudioProcessor
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// This struct is used to pass along data between the MTAudioProcessingTap callbacks.
typedef struct AVAudioTapProcessorContext {
	Boolean supportedTapProcessingFormat;
	Boolean isNonInterleaved;
	Float64 sampleRate;
    UInt32 audioFormat;
	AudioUnit audioUnit;
	Float64 sampleCount;
	float leftChannelVolume;
	float rightChannelVolume;
	void* controller;
} AVAudioTapProcessorContext;


@protocol WPVideoAudioProcessorDelegate <NSObject>

-(void)audioPrepare:(MTAudioProcessingTapRef)audioTap maxFrames:(CMItemCount)maxFrames processingFormat:(const AudioStreamBasicDescription*)processingFormat context:(AVAudioTapProcessorContext*)context;

-(void)audioUnprepare:(MTAudioProcessingTapRef)audioTap context:(AVAudioTapProcessorContext*)context;

-(void)audioProcess:(MTAudioProcessingTapRef)audioTap numberOfFrames:(CMItemCount)numberOfFrames flags:(MTAudioProcessingTapFlags)flags buffers:(AudioBufferList*)buffers numberFramesOut:(CMItemCount*)numberFramesOut flagsOut:(MTAudioProcessingTapFlags*)flagsOut context:(AVAudioTapProcessorContext*)context;


@end
