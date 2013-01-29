//
//  WPVideoAudioBasicProcessor.m
//  WPVideoAudioProcessor
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import "WPVideoAudioBasicProcessor.h"

@implementation WPVideoAudioBasicProcessor

-(void)audioPrepare:(MTAudioProcessingTapRef)audioTap maxFrames:(CMItemCount)maxFrames processingFormat:(const AudioStreamBasicDescription*)processingFormat context:(AVAudioTapProcessorContext*)context
{
    
}


-(void)audioUnprepare:(MTAudioProcessingTapRef)audioTap context:(AVAudioTapProcessorContext*)context
{
    
}

-(void)audioProcess:(MTAudioProcessingTapRef)audioTap numberOfFrames:(CMItemCount)numberOfFrames flags:(MTAudioProcessingTapFlags)flags buffers:(AudioBufferList*)buffers numberFramesOut:(CMItemCount*)numberFramesOut flagsOut:(MTAudioProcessingTapFlags*)flagsOut context:(AVAudioTapProcessorContext*)context
{
    CMTimeRange timeRange;
	MTAudioProcessingTapGetSourceAudio(audioTap, numberOfFrames, buffers, flagsOut, &timeRange, numberFramesOut);
    [self processAudioBuffers:buffers numberOfFrames:numberOfFrames context:context];

}

-(void)processAudioBuffers:(AudioBufferList*)buffers numberOfFrames:(CMItemCount)numberOfFrames context:(AVAudioTapProcessorContext*)context
{
    
}

@end
