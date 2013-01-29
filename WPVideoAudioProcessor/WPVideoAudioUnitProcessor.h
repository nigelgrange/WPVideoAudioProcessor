//
//  WPVideoAudioUnitProcessor.h
//  WPVideoAudioProcessor
//
//  Created by Nigel Grange on 03/01/2013.
//  Copyright (c) 2013 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPVideoAudioProcessorDelegate.h"

@interface WPVideoAudioUnitProcessor : NSObject <WPVideoAudioProcessorDelegate> {
    AVAudioTapProcessorContext* processorContext;
}

-(AudioUnit)audioUnit;
-(AVAudioTapProcessorContext*)context;

@end
