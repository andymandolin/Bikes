//
//  BikesTests.swift
//  BikesTests
//
//  Created by Andy Geipel on 12/16/20.
//

import XCTest
@testable import Bikes
import CoreLocation

class BikesTests: XCTestCase {

    func testEntryCharacterCheck() {
        // Given
        let characters = CharacterCheck()
        // When
        let charactersCheck = characters.entryCharacterCheck(entryToCheck: "h3")
        // Then
        XCTAssertTrue(charactersCheck)
    }
    
}

