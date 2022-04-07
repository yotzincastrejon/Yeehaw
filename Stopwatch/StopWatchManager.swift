//
//  StopWatchManager.swift
//  Yeehaw
//
//  Created by Yotzin Castrejon on 4/5/21.
//

import Foundation


enum stopWatchMode {
    case running
    case stopped
    case paused
}

class StopWatchManager: ObservableObject {
    
    @Published var mode: stopWatchMode = .stopped
    @Published var secondsElapsed = 0.0
    @Published var timeShown = "00:00:00"
    @Published var time = ""
    @Published var elapsedSeconds: Int = 0
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsElapsed = self.secondsElapsed + 1
            self.timeShown = self.showDate()
        }
    }

    func pause() {
        timer.invalidate()
        mode = .paused
    }

    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
        timeShown = "00:00:00"
    }
    
    func showDate() -> String {
//        let elapsed = Int(Date().timeIntervalSince(date))
        let elapsed = Int(secondsElapsed)
        let hours = elapsed / 3600
        let minutes = (elapsed / 60) % 60
        let seconds = elapsed % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func format(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }
    
}


