//
//  InterfaceController.swift
//  watchOS Example WatchKit Extension
//
//  Created by László Tuss on 2020. 01. 01..
//  Copyright © 2020. tbaranes. All rights reserved.
//

import WatchKit
import Foundation
import AudioPlayerSwift

class InterfaceController: WKInterfaceController {

    // MARK: Properties

    var sound1: AudioPlayer?
    var sound2: AudioPlayer?

    // MARK: Life cycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        do {
            sound1 = try AudioPlayer(fileName: "sound1.caf")
            sound2 = try AudioPlayer(fileName: "sound2.caf")
        } catch let error {
            print("Sound initialization failed. \(error.localizedDescription)")
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCompletion(_:)),
                                               name: AudioPlayer.SoundDidFinishPlayingNotification,
                                               object: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func handleCompletion(_ notification: Notification) {
        if let audioPlayer = notification.object as? AudioPlayer,
           let name = audioPlayer.name,
           let success = notification.userInfo?[AudioPlayer.SoundDidFinishPlayingSuccessfully] {
            print("AudioPlayer with name '\(name)' did finish playing with success: \(success)")
        }
    }

    // MARK: IBAction

    @IBAction func playSound1Pressed(sender: AnyObject) {
        sound1?.play()
    }

    @IBAction func playSound2Pressed(sender: AnyObject) {
        sound2?.play()
    }

    @IBAction func stopSound1Pressed(sender: AnyObject) {
        sound1?.stop()
    }

    @IBAction func stopSound2Pressed(sender: AnyObject) {
        sound2?.stop()
    }
}
