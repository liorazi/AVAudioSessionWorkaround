# AVAudioSessionWorkaround

This test project was made in order to test a workaround to an Apple's AVFoundation framework bug.

The bug was that you couldn't call AVAudioPlayer's call method in the AVAudioSession's <i>InterruptionTypeEnded</i> interruption.

The workaround that seemed to work is adding a small delay to that call using <b>dispatch_after</b>.




Today, 10/05/2016, I Submitted a radar to Apple about it, and here are its details: <b>(#26182163)</b>

<b>Summary:</b>
While implementing AVAudioSession interruptions, in order to resume playback of a sound file after finishing a phone call, there is a problem calling the play method of the AVAudioPlayer inside the AVAudioSession's "InterruptionTypeEnded" interruption. It seems like the interruption does get called, but the player's call method doesn't run properly, and therefore the playback of the sound file doesn't get resumed.

<b>Steps to Reproduce:</b>
1. Setup your app to use Background Mode - Audio
2. Initialise an AVAudioPlayer (Category -> AVAudioSessionCategoryPlayback)
3. Add Observer to handle AVAudioSession interruptions.
4. Implement method that will handle interruptions: in the "InterruptionTypeEnded" case call the play method of AVAudioPlayer in order to resume playback
5. On app load, play the soundfile you want.
6. Initiate or answer a phone call, and then hangup.

* I've created a test project for this issue written in Objective-C (Also did one in Swift which had the same problem) with a workaround of the problem - 
The solution was to add a delay to the player's play method using "dispatch_after"

It can be found here: https://github.com/liorazi/AVAudioSessionWorkaround

<b>Expected Results:</b>
Sound file playback resumes after phone call ends.

<b>Actual Results:</b>
Sound file playback stays paused after phone call ends.

<b>Version:</b>
iOS 9.3.1

<b>Configuration:</b>
iPhone 6S
