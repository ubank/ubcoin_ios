//
//  UBCTimerLabel.swift
//  Ubcoin
//
//  Created by Alex Ostroushko on 11.09.2018.
//  Copyright © 2018 UBANK. All rights reserved.
//

import UIKit

class UBCTimerLabel: UILabel {

    private var timer: Timer?
    private var totalSeconds: Int64 = 0
    
    @objc func setup(seconds: Int64) {
        totalSeconds = seconds
        
        stopTimer()
        updateTime()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(self.updateTime),
                                          userInfo: nil,
                                          repeats: true)
    }

    @objc func stopTimer() {
        timer?.invalidate()
        self.timer = nil
    }
    
    @objc private func updateTime() {
        totalSeconds -= 1
        
        if totalSeconds == 0 {
            stopTimer()
        }
        
    }
    
    private func timeString() -> String {
        var hours = 0
        var minutes = 0
        var seconds = totalSeconds
        
        if (seconds > SECONDS_IN_HOUR)
        {
            hours = Int(floor(Double(seconds) / Double(SECONDS_IN_HOUR)));
            seconds -= Int64(hours * SECONDS_IN_HOUR);
        }
        
        if (seconds > SECONDS_IN_MINUTE)
        {
            minutes = Int(floor(Double(seconds) / Double(SECONDS_IN_MINUTE)));
            seconds -= Int64(minutes * SECONDS_IN_MINUTE);
        }
        
        return "%02\(hours)d:%02\(minutes)d:%02\(seconds)d"
    }
}
