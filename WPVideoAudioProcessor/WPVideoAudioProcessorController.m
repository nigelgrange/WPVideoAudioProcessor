//
//  WPVideoAudioProcessorController.m
//  WPVideoAudioProcessor
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import "WPVideoAudioProcessorController.h"
#import <AVFoundation/AVFoundation.h>


// MTAudioProcessingTap callbacks.
static void tap_InitCallback(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut);
static void tap_FinalizeCallback(MTAudioProcessingTapRef tap);
static void tap_PrepareCallback(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat);
static void tap_UnprepareCallback(MTAudioProcessingTapRef tap);
static void tap_ProcessCallback(MTAudioProcessingTapRef tap, CMItemCount numberFrames, MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut, CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut);


@interface WPVideoAudioProcessorController ()
{
	AVAudioMix *_audioMix;
}
@end


@implementation WPVideoAudioProcessorController

-(id)initWithAudioAssetTrack:(AVAssetTrack *)audioAssetTrack
{
	NSParameterAssert(audioAssetTrack && [audioAssetTrack.mediaType isEqualToString:AVMediaTypeAudio]);
	
	self = [super init];
	
	if (self)
	{
		_audioAssetTrack = audioAssetTrack;
	}
	
	return self;
    
}

- (AVAudioMix *)audioMix
{
	if (!_audioMix)
	{
		AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
		if (audioMix)
		{
			AVMutableAudioMixInputParameters *audioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.audioAssetTrack];
			if (audioMixInputParameters)
			{
				MTAudioProcessingTapCallbacks callbacks;
				
				callbacks.version = kMTAudioProcessingTapCallbacksVersion_0;
				callbacks.clientInfo = (__bridge void *)self,
				callbacks.init = tap_InitCallback;
				callbacks.finalize = tap_FinalizeCallback;
				callbacks.prepare = tap_PrepareCallback;
				callbacks.unprepare = tap_UnprepareCallback;
				callbacks.process = tap_ProcessCallback;
				
				MTAudioProcessingTapRef audioProcessingTap;
				if (noErr == MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PreEffects, &audioProcessingTap))
				{
					audioMixInputParameters.audioTapProcessor = audioProcessingTap;
					
					CFRelease(audioProcessingTap);
					
					audioMix.inputParameters = @[audioMixInputParameters];
					
					_audioMix = audioMix;
				}
			}
		}
	}
	
	return _audioMix;
}


@end


#pragma mark - MTAudioProcessingTap Callbacks

static void tap_InitCallback(MTAudioProcessingTapRef tap, void *clientInfo, void **tapStorageOut)
{
	AVAudioTapProcessorContext *context = calloc(1, sizeof(AVAudioTapProcessorContext));
	
	// Initialize MTAudioProcessingTap context.
	context->supportedTapProcessingFormat = false;
	context->isNonInterleaved = false;
	context->sampleRate = NAN;
	context->audioUnit = NULL;
	context->sampleCount = 0.0f;
	context->leftChannelVolume = 0.0f;
	context->rightChannelVolume = 0.0f;
	context->controller = clientInfo;
	
	*tapStorageOut = context;
}

static void tap_FinalizeCallback(MTAudioProcessingTapRef tap)
{
	AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
	
	// Clear MTAudioProcessingTap context.
	context->controller = NULL;
	
	free(context);
}

static void tap_PrepareCallback(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat)
{
	AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
	
	// Store sample rate for -setCenterFrequency:.
	context->sampleRate = processingFormat->mSampleRate;
	
	/* Verify processing format (this is not needed for Audio Unit, but for RMS calculation). */
	
	context->supportedTapProcessingFormat = true;
	
	if (processingFormat->mFormatID != kAudioFormatLinearPCM)
	{
		NSLog(@"Unsupported audio format ID for audioProcessingTap. LinearPCM only.");
		context->supportedTapProcessingFormat = false;
	}

	context->audioFormat = processingFormat->mFormatFlags;

	
	if (processingFormat->mFormatFlags & kAudioFormatFlagIsNonInterleaved)
	{
		context->isNonInterleaved = true;
	}
    
    WPVideoAudioProcessorController* controller = (__bridge WPVideoAudioProcessorController *)(context->controller);
    [controller.audioProcessingDelegate audioPrepare:tap maxFrames:maxFrames processingFormat:processingFormat context:context];
    
}

static void tap_UnprepareCallback(MTAudioProcessingTapRef tap)
{
	AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
    WPVideoAudioProcessorController* controller = (__bridge WPVideoAudioProcessorController *)(context->controller);
    
    [controller.audioProcessingDelegate audioUnprepare:tap context:context];	
}

static void tap_ProcessCallback(MTAudioProcessingTapRef tap, CMItemCount numberFrames, MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut, CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut)
{
	AVAudioTapProcessorContext *context = (AVAudioTapProcessorContext *)MTAudioProcessingTapGetStorage(tap);
    
	if (!context->supportedTapProcessingFormat)
	{
		NSLog(@"Unsupported tap processing format.");
		return;
	}
    
    WPVideoAudioProcessorController* controller = (__bridge WPVideoAudioProcessorController *)(context->controller);
    [controller.audioProcessingDelegate audioProcess:tap numberOfFrames:numberFrames flags:flags buffers:bufferListInOut numberFramesOut:numberFramesOut flagsOut:flagsOut context:context];
    
}


