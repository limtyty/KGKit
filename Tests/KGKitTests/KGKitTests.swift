import XCTest
@testable import KGKit

final class KGKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(KGKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
