//
//  ChargingState.swift
//  Supercharger
//
//  Created by Park Seongheon on 4/5/24.
//

import Foundation
import Cocoa
import IOKit.ps
import IOKit.pwr_mgt
import Observation

@Observable
final class ChargingState {
    private(set)    var currentCapacity:    Int     = 0
    private(set)    var watts:              Double  = 0
    private(set)    var timeToFullCharge:   Int     = 0
    
    private         var sumWatts:           Double  = 0
    private         var seconds:            Int     = 0
    private(set)    var wattHours:          Double  = 0
    
    func getPowerStatus() {
        // Take a snapshot of all the power source info
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        
        // Pull out a list of power sources
        let sources  = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        // For each power source...
        for ps in sources {
            // Fetch the information for a given power source out of our snapshot
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]
            
            if let cap  = info[kIOPSCurrentCapacityKey] as? Int,
               let time = info[kIOPSTimeToFullChargeKey] as? Int {
//                print(cur)
//                print(volt)
                self.currentCapacity    = cap
                self.timeToFullCharge   = time
            }
        }
        
        let voltage     = shell("ioreg -rw0 -c AppleSmartBattery | grep -o -e '\"Voltage\" = [0-9]*'")
            .components(separatedBy: " = ")
            .last!
            .replacingOccurrences(of: "\n", with: "")
        
        let current     = shell("ioreg -rw0 -c AppleSmartBattery | grep -o -e '\"ChargingCurrent\"=[0-9]*'")
            .components(separatedBy: "=")
            .last!
            .replacingOccurrences(of: "\n", with: "")
        
        self.watts      = Double(voltage)! * Double(current)! / 1000000
        self.sumWatts   += self.watts
        self.seconds    += 1
        
        #if DEBUG
        print("Cap: \(self.currentCapacity), Time: \(self.timeToFullCharge), Watts: \(self.watts), Sum Watts: \(self.sumWatts)")
        #endif
    }
    
    func calculateWattHours() {
        self.wattHours  = self.sumWatts / 3600
        
        #if DEBUG
        print("Seconds: \(self.seconds), Watt Hours: \(self.wattHours)")
        #endif
    }
}
