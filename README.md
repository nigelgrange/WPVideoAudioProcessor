WPVideoAudioProcessor
=====================

iOS sample code that makes it simple to process the audio sample data when playing video via AV Foundation

You can use these classes to directly manipulate the audio track of a playing video, either by direct sample manipulation or by using Core Audio.

Caveat: This code is intended as a guide / tutorial on how to implement an MTAudioProcessingTap. It may not be suitable for use in commercial projects, but feel free to do so.

#Usage

Copy the WPVideoAudioProcessor folder to your project.

Add the following libraries to your project:

* AudioToolbox
* MediaToolbox
* AVFoundation

Subclass either WPVideoAudioBasicProcessor (for manual sample manipulation) or WPViddeoAudioUnitProcessor (for Audio Unit based processing)

Create instance of WPVideoAudioProcessorController with the audio track to manipulate. This would typically be the first AVMediaTypeAudio track in the 'tracks' list of the media item.

Set the audioProcessingDelegate on the WPVideoAudioProcessorController instance to your custom audio processor class.

#Demo

The VideoAudioProcessorDemo project shows how to play a sample video and attach the audio processor to it.

The demo includes two example audio processors:

### TestWPAudioProcessorMono

This derives from WPVideoAudioBasicProcessor and manually averages the stereo audio track to produce a mono audio track.

You'll notice that the processor detects if the sample data is integer or float. When running under the iOS Simulator, the audio data tends to be delivered in integer format. When running on a device, the sample data is in float.

### TestWPAudioProcessorBandPass

This derives from WPViddeoAudioUnitProcessor and sets up a BandPass AudioUnit. It includes an accessor function so that the audio unit parameters can be updated while the video is being played.

Since Audio Units can only process audio data with samples in float, this audio processor will only function correctly when running on the device - it will not function in the iOS Simulator.

#License

This project is BSD licensed. It borrows heavily from the Apple WWDC 2012 Session Code demo AudioTapProcessor, but does not include any entire source files from that project.



