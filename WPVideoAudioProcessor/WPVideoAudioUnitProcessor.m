//
//  WPVideoAudiUnitProcessor.m
//  WPVideoAudioProcessor
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

// Implementation inspired by Apple AudioTapProcessor example

#import "WPVideoAudioUnitProcessor.h"

static OSStatus AU_RenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);


@implementation WPVideoAudioUnitProcessor

-(void)selectAudioUnit:(AudioComponentDescription*)audioComponentDescription
{
}

-(AudioUnit)audioUnit
{
    AVAudioTapProcessorContext *context = processorContext;
    AudioUnit audioUnit = context->audioUnit;
    return audioUnit;
}

-(AVAudioTapProcessorContext*)context
{
    return processorContext;
}


-(void)audioPrepare:(MTAudioProcessingTapRef)audioTap maxFrames:(CMItemCount)maxFrames processingFormat:(const AudioStreamBasicDescription*)processingFormat context:(AVAudioTapProcessorContext*)context
{
    processorContext = context;
	AudioUnit audioUnit;
	
	AudioComponentDescription audioComponentDescription;
    [self selectAudioUnit:&audioComponentDescription];
	
	AudioComponent audioComponent = AudioComponentFindNext(NULL, &audioComponentDescription);
	if (audioComponent)
	{
		if (noErr == AudioComponentInstanceNew(audioComponent, &audioUnit))
		{
			OSStatus status = noErr;
			
			// Set audio unit render callback.
			if (noErr == status)
			{
				AURenderCallbackStruct renderCallbackStruct;
				renderCallbackStruct.inputProc = AU_RenderCallback;
				renderCallbackStruct.inputProcRefCon = (void *)audioTap;
				status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &renderCallbackStruct, sizeof(AURenderCallbackStruct));
			}
			
			// Set audio unit maximum frames per slice to max frames.
			if (noErr == status)
			{
				UInt32 maximumFramesPerSlice = maxFrames;
				status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &maximumFramesPerSlice, (UInt32)sizeof(UInt32));
			}
			
			// Initialize audio unit.
			if (noErr == status)
			{
				status = AudioUnitInitialize(audioUnit);
			}
            
			if (noErr != status)
			{
				AudioComponentInstanceDispose(audioUnit);
				audioUnit = NULL;
			}
			
			context->audioUnit = audioUnit;
		}
	}
    
}


-(void)audioUnprepare:(MTAudioProcessingTapRef)audioTap context:(AVAudioTapProcessorContext*)context
{
	/* Release  Audio Unit */
	
	if (context->audioUnit)
	{
		AudioUnitUninitialize(context->audioUnit);
		AudioComponentInstanceDispose(context->audioUnit);
		context->audioUnit = NULL;
	}
    
}

-(void)audioProcess:(MTAudioProcessingTapRef)audioTap numberOfFrames:(CMItemCount)numberOfFrames flags:(MTAudioProcessingTapFlags)flags buffers:(AudioBufferList*)buffers numberFramesOut:(CMItemCount*)numberFramesOut flagsOut:(MTAudioProcessingTapFlags*)flagsOut context:(AVAudioTapProcessorContext*)context
{
    // Apply  Audio Unit.
    AudioUnit audioUnit = context->audioUnit;
    if (audioUnit)
    {
        AudioTimeStamp audioTimeStamp;
        audioTimeStamp.mSampleTime = context->sampleCount;
        audioTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
        
        OSStatus status = AudioUnitRender(audioUnit, 0, &audioTimeStamp, 0, (UInt32)numberOfFrames, buffers);
        if (noErr != status)
        {
            NSLog(@"AudioUnitRender(): %d", (int)status);
            return;
        }
        
        // Increment sample count for audio unit.
        context->sampleCount += numberOfFrames;
        
        // Set number of frames out.
        *numberFramesOut = numberOfFrames;
    }
    
}

@end

#pragma mark - Audio Unit Callbacks

OSStatus AU_RenderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
{
	// Just return audio buffers from MTAudioProcessingTap.
	return MTAudioProcessingTapGetSourceAudio(inRefCon, inNumberFrames, ioData, NULL, NULL, NULL);
}

