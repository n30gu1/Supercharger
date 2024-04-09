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
        let snapshot                    = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let acSnapshot: CFDictionary?   = {
            if let snapshot = IOPSCopyExternalPowerAdapterDetails() {
                return snapshot.takeRetainedValue()
            }
            
            return nil
        }()
        
        // Pull out a list of power sources
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        // For each power source...
        for ps in sources {
            // Fetch the information for a given power source out of our snapshot
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]
            
            if let cap  = info[kIOPSCurrentCapacityKey] as? Int,
               let cur  = info[kIOPSCurrentKey] as? Int,
               let volt = info[kIOPSVoltageKey] as? Int,
               let time = info[kIOPSTimeToFullChargeKey] as? Int {
//                print(cur)
//                print(volt)
                self.currentCapacity    = cap
                self.watts              = Double(cur) * 0.001 * Double(volt) * 0.001
                self.timeToFullCharge   = time
            }
            
            if let info = acSnapshot as? [String: AnyObject] {
//                print(info)
            }
        }
    }
    
    func calculateWattHours() {
        let hours       = seconds / 3600
        self.wattHours  = self.sumWatts * Double(hours)
    }
}
