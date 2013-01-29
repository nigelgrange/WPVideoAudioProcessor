//
//  TestWPAudioProcessorMono.m
//  TestWPAudioUnit
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import "TestWPAudioProcessorMono.h"

@implementation TestWPAudioProcessorMono

-(void)processAudioBuffers:(AudioBufferList*)buffers numberOfFrames:(CMItemCount)numberOfFrames context:(AVAudioTapProcessorContext*)context
{
	for (CMItemCount i = 0; i < buffers->mNumberBuffers; i++)
	{
		AudioBuffer *pBuffer = &buffers->mBuffers[i];
        if (pBuffer->mNumberChannels != 2) {
            break;
        }
        
		UInt32 cSamples = numberOfFrames * (context->isNonInterleaved ? 1 : pBuffer->mNumberChannels);
        if (context->audioFormat & kAudioFormatFlagIsFloat) {
            float *pData = (float *)pBuffer->mData;
            
            for (UInt32 j = 0; j < cSamples; j+=2) {
                float left = pData[j];
                float right = pData[j+1];
                float mono = (left+right)/2;
                pData[j] = mono;
                pData[j+1] = mono;
            }            
        } else {
            int16_t *pData = (int16_t *)pBuffer->mData;
            
            for (UInt32 j = 0; j < cSamples; j+=2) {
                int16_t left = pData[j];
                int16_t right = pData[j+1];
                int16_t mono = (left+right)/2;
                pData[j] = mono;
                pData[j+1] = mono;
            }
        }

    }
    
}

@end
