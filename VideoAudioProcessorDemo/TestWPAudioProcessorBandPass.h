//
//  TestWPAudioProcessorBandPass.h
//  VideoAudioProcessorDemo
//
//  Created by Nigel Grange on 28/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import "WPVideoAudioUnitProcessor.h"

@interface TestWPAudioProcessorBandPass : WPVideoAudioUnitProcessor {
    float _centerFrequency;
}

- (void)setCenterFrequency:(float)centerFrequency;


@end
