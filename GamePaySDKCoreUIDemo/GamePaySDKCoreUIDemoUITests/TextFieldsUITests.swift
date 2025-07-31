//
//  TextFieldsUITests.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 31/7/25.
//


import XCTest

final class TextFieldsUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        app.buttons["TextField demo"].tap()
    }

    private func textField(in identifier: String, index: Int = 0) -> XCUIElement {
        return app.otherElements[identifier].textFields.element(boundBy: index)
    }

    @MainActor
    func testAllTextFieldsCanReceiveInput() throws {
        let search = textField(in: "searchTextField")
        XCTAssertTrue(search.waitForExistence(timeout: 1))
        search.tap()
        search.typeText("Hello")

        let phone = textField(in: "phoneTextField", index: 1)
        XCTAssertTrue(phone.waitForExistence(timeout: 1))
        phone.tap()
        phone.typeText("123456789")

        let email = textField(in: "emailField")
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("test@example.com")

        let pan = textField(in: "panField")
        XCTAssertTrue(pan.exists)
        pan.tap()
        pan.typeText("4111111111111111")

        let exp = textField(in: "expDateField")
        XCTAssertTrue(exp.exists)
        exp.tap()
        exp.typeText("1229")

        let cvv = textField(in: "cvvField")
        XCTAssertTrue(cvv.exists)
        cvv.tap()
        cvv.typeText("123")

//        let dropdown = textField(in: "dropdownTextField")
//        XCTAssertTrue(dropdown.exists)
//        dropdown.tap()
//        let table = app.tables.firstMatch
//        if table.waitForExistence(timeout: 1) {
//            table.cells.element(boundBy: 0).tap()
//        }
    }
}
