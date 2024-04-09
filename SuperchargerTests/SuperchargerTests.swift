//
//  SuperchargerTests.swift
//  SuperchargerTests
//
//  Created by Park Seongheon on 4/9/24.
//

import XCTest
@testable import Supercharger

final class SuperchargerTests: XCTestCase {
    var chargingState: ChargingState!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        chargingState = ChargingState()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPowerState() {
        chargingState.getPowerStatus()
        
        print(chargingState.watts)
    }

}
