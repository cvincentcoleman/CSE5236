//
//  TWJAppTests.swift
//  TWJAppTests
//
//  Created by Charles Vincent Coleman on 2/7/20.
//  Copyright © 2020 Charles Vincent Coleman. All rights reserved.
//

import XCTest
@testable import TWJApp

class TWJAppTests: XCTestCase {
    var sut: Userr!
    
    override func setUp() {
        super.setUp()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testUserInitialization(){
        
        //given
        let dictionary = ["email":"vince@thewonderjam.com","team":"TWJ","admin":true,"profileImageURL":"https://works.jpg"] as [String : Any]
        //when
        sut = Userr(data: dictionary)
        
        //then
        XCTAssertEqual(sut.email, "vince@thewonderjam.com")
        XCTAssertEqual(sut.team, "TWJ")
        XCTAssertEqual(sut.admin, true)
        XCTAssertEqual(sut.ProfileimageURL, "https://works.jpg")
    }
    
    func testUserInitializationOfl(){
        
        //given
        let dictionary = ["test":"test"] as [String : Any]
        //when
        sut = Userr(data: dictionary)
        
        //then
        XCTAssertEqual(sut.email, "no email")
        XCTAssertEqual(sut.team, "no team")
        XCTAssertEqual(sut.admin, false)
        XCTAssertEqual(sut.ProfileimageURL, "")
    }
    
    

}
