import XCTest
@testable import EconoPanier

final class MoneyTests: XCTestCase {
    func testFrenchDecimal() { XCTAssertEqual(Money.parse("1,15"),115) }
    func testInvalid() { XCTAssertNil(Money.parse("-1")); XCTAssertNil(Money.parse("1,234")); XCTAssertNil(Money.parse("")) }
    func testPartialBasket() {
        let result = Money.basket([.init(quantity: 2,unitCents: 105),.init(quantity: 1,unitCents: nil)])
        XCTAssertEqual(result, BasketTotal(knownCents: 210,unresolvedLines: 1)); XCTAssertTrue(result.isPartial)
    }
    func testCompleteBasket() { XCTAssertEqual(Money.basket([.init(quantity: 2,unitCents: 105),.init(quantity: 2,unitCents: 275),.init(quantity: 1,unitCents: 530)]),BasketTotal(knownCents: 1290,unresolvedLines: 0)) }
    func testPriceDifference() { XCTAssertEqual(Money.priceDifference(paid: 115,expected: 110),5) }
    func testHalfKilo() { XCTAssertEqual(Money.basket([.init(quantity: Decimal(string: "0.5")!,unitCents: 399)]).knownCents,200) }
}
