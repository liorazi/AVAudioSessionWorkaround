//
//  ViewController.m
//  AVAudioSessionWorkaround
//
//  Created by Lior on 08/05/2016.
//  Copyright © 2016 Azi Software. All rights reserved.
//

#import "AVPlayerViewController.h"
@import AVFoundation;

@interface AVPlayerViewController () {
    
}

@property (nonatomic, strong) AVAudioPlayer *player;

@end


@implementation AVPlayerViewController


- (void)playAudio {
    NSString *mySoundFile = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"];
    NSURL *alertSound = [NSURL fileURLWithPath:mySoundFile];
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryPlayback" error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if (error) {
        NSLog(@"Error %@", [error description]);
    }
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:alertSound error:&error];

    [_player setNumberOfLoops:-1];
    [_player prepareToPlay];
    [_player play];
    
}

- (void)addInterruptionNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:@"AVAudioSessionInterruptionNotification" object:nil];
}

- (void)handleInterruption:(NSNotification *) notification{
    if (notification.name != AVAudioSessionInterruptionNotification || notification.userInfo == nil) {
        return;
    }
    
    NSDictionary *info = notification.userInfo;
    
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification");
        
        if ([[info valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"InterruptionTypeBegan");
        } else {
            NSLog(@"InterruptionTypeEnded");
            
            //The Actual Workaround - Add delay to the play call.
            [self performSelector:@selector(play) withObject:nil afterDelay:0.1];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                NSLog(@"playing");
//                [_player play];
//            });
        }
    }
}

- (void)play {
    [_player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addInterruptionNotification];
    [self playAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnWasPressed:(id)sender {
    if (_player.isPlaying) {
        [_player pause];
    }
    else {
        [_player play];
    }
}

/*
 import UIKit
 import AVFoundation
 
 class AVPlayerViewController: UIViewController {
 
 var audioPlayer = AVAudioPlayer()
 var interruptedOnPlayback = false
 func playAudio() {
 // Set the sound file name & extension
 let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound", ofType: "mp3")!)
 
 // Preperation
 try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
 try! AVAudioSession.sharedInstance().setActive(true, withOptions: [])
 
 // Play the sound
 do {
 try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
 audioPlayer.prepareToPlay()
 audioPlayer.numberOfLoops = -1
 audioPlayer.play()
 } catch {
 print("there is \(error)")
 }
 }
 
 func addInterruptionNotification() {
 // add audio session interruption notification
 NSNotificationCenter.defaultCenter().addObserver(self,
 selector: #selector(AVPlayerViewController.handleInterruption(_:)),
 name: AVAudioSessionInterruptionNotification,
 object: nil)
 }
 
 func handleInterruption(notification: NSNotification) {
 if notification.name != AVAudioSessionInterruptionNotification
 || notification.userInfo == nil{
 return
 }
 var info = notification.userInfo!
 var intValue: UInt = 0
 (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
 if let type = AVAudioSessionInterruptionType(rawValue: intValue) {
 switch type {
 case .Began:
 // interruption began
 print("began")
 
 case .Ended:
 // interruption ended
 print("ended")
 
 let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
 dispatch_after(delayTime, dispatch_get_main_queue()) {
 self.audioPlayer.play()
 }
 
 }
 }
 }
 
 override func viewDidLoad() {
 addInterruptionNotification()
 playAudio()
 }
 
 @IBAction func btnWasClicked(sender: AnyObject) {
 if self.audioPlayer.playing {
 self.audioPlayer.pause()
 }
 else {
 self.audioPlayer.play()
 }
 }
 */

@end
