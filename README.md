# AVAudioSessionWorkaround
AVAudioSession Interruptions test project

This test project was made in order to test a workaround to an Apple's AVFoundation framework bug.

The bug was that you couldn't call AVPlayer's call method in the AVAudioSession's <i>InterruptionTypeEnded</i> interruption.

The workaround is to add a small delay to that call using <b>dispatch_after</b>.
