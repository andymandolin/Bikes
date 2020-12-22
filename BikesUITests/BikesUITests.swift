//
//  BikesUITests.swift
//  BikesUITests
//
//  Created by Andy Geipel on 12/16/20.
//

import XCTest

class BikesUITests: XCTestCase {


    func testSearchScreen() throws {

        let app = XCUIApplication()
        app.launch()
        
        let textField = app.textFields["entryField"]

        // Check correct demo values
        XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["demo stolen"]/*[[".buttons[\"demo stolen\"].staticTexts[\"demo stolen\"]",".staticTexts[\"demo stolen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        if let text = textField.value {
            XCTAssertEqual("\(text)", "f1206k1236")
        }

        app/*@START_MENU_TOKEN@*/.staticTexts["demo non-stolen"]/*[[".buttons[\"demo non-stolen\"].staticTexts[\"demo non-stolen\"]",".staticTexts[\"demo non-stolen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        if let text = textField.value {
            XCTAssertEqual("\(text)", "196h4k375m")
        }

    }

}
