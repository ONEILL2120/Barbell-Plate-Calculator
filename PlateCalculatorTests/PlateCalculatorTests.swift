//
//  PlateCalculatorTests.swift
//  PlateCalculatorTests
//
//  Created by Robert Oneill on 22/04/2018.
//  Copyright © 2018 oneilldvlpr. All rights reserved.
//

import XCTest
@testable import Barbell_Plate_Calculator

class PlateCalculatorTests: XCTestCase {
    
    private let calculator = PlateCalculator()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func test0kgReturnsNoPlates() {
        
        let result = calculator.calculate(weightInKg: 0)

        XCTAssertEqual([], result)
        
        
    }
    
    func test40kgReturnsTwo10kgPlates() {
        
        let result = calculator.calculate(weightInKg: 40)
        
        XCTAssertEqual([10,10], result)
        
        
    }
    
    func test105kgReturnsTwo25kgAndTwo15kgAndTwo2_5kg() {
    
        let result = calculator.calculate(weightInKg: 105)
        
        XCTAssertEqual([25,25,15,15,2.5,2.5], result)
    
    }
    
    
}
