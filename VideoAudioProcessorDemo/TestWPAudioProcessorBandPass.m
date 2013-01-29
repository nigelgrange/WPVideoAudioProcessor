//
//  TestWPAudioProcessorBandPass.m
//  VideoAudioProcessorDemo
//
//  Created by Nigel Grange on 28/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import "TestWPAudioProcessorBandPass.h"

@implementation TestWPAudioProcessorBandPass

-(void)selectAudioUnit:(AudioComponentDescription*)audioComponentDescription
{
	audioComponentDescription->componentType = kAudioUnitType_Effect;
	audioComponentDescription->componentSubType = kAudioUnitSubType_BandPassFilter;
	audioComponentDescription->componentManufacturer = kAudioUnitManufacturer_Apple;
	audioComponentDescription->componentFlags = 0;
	audioComponentDescription->componentFlagsMask = 0;
}

- (void)setCenterFrequency:(float)centerFrequency
{
    // Implementation from Apple AudioTapProcessor example
	if (_centerFrequency != centerFrequency)
	{
		_centerFrequency = centerFrequency;
		
        AudioUnit audioUnit = self.audioUnit;
        if (audioUnit)
        {
            // Update center frequency of bandpass filter Audio Unit.
            Float32 frequency = (20.0f + (([self context]->sampleRate * 0.5f) - 20.0f) * centerFrequency); // Global, Hz, 20->(SampleRate/2), 5000
            OSStatus status = AudioUnitSetParameter(audioUnit, kBandpassParam_CenterFrequency, kAudioUnitScope_Global, 0, frequency, 0);
            if (noErr != status)
                NSLog(@"AudioUnitSetParameter(kBandpassParam_CenterFrequency): %d", (int)status);
        }
    }
}



@end
