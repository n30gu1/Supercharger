//
//  ChargingState.swift
//  Supercharger
//
//  Created by Park Seongheon on 4/5/24.
//

import Foundation
import Cocoa
import IOKit.ps
import Observation

@Observable
final class ChargingState {
    var currentCapacity: Int = 0
    var current: Int = 0
    var timeToFullCharge: Int = 0
    
    func getPowerStatus() {
        // Take a snapshot of all the power source info
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        
        // Pull out a list of power sources
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        // For each power source...
        for ps in sources {
            // Fetch the information for a given power source out of our snapshot
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]
            
            if let cap = info[kIOPSCurrentCapacityKey] as? Int,
               let cur = info[kIOPSCurrentKey] as? Int,
               let time = info[kIOPSTimeToFullChargeKey] as? Int {
                self.currentCapacity = cap
                self.current = cur
                self.timeToFullCharge = time
            }
            
            print(info)
        }
    }
}
