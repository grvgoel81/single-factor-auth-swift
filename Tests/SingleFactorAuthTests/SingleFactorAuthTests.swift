import XCTest
import JWTKit
import BigInt

@testable import SingleFactorAuth

final class SingleFactorAuthTests: XCTestCase {
    
    var singleFactoreAuth: SingleFactorAuth!
    var singleFactorAuthArgs: SingleFactorAuthArgs!
    
    let TOURUS_TEST_EMAIL = "hello@tor.us"
    let TEST_VERIFIER = "torus-test-health"
    let TEST_AGGREGRATE_VERIFIER = "torus-test-health-aggregate"
    
    override func setUp() {
        singleFactorAuthArgs = SingleFactorAuthArgs(network: TorusNetwork.TESTNET)
        singleFactoreAuth = SingleFactorAuth(singleFactorAuthArgs: singleFactorAuthArgs)
    }
    
    func testGetTorusKey() async throws {
        let idToken = try generateIdToken(email: TOURUS_TEST_EMAIL)
        let loginParams = LoginParams(verifier: TEST_VERIFIER, verifierId: TOURUS_TEST_EMAIL, idToken: idToken)
        let torusKey = try await singleFactoreAuth.getKey(loginParams: loginParams)
        
        let requiredPrivateKey = BigInt("296045a5599afefda7afbdd1bf236358baff580a0fe2db62ae5c1bbe817fbae4", radix: 16)
        XCTAssertTrue(requiredPrivateKey == torusKey.getPrivateKey())
        XCTAssertEqual(torusKey.publicAddress, torusKey.getPublicAddress())
    }
    
    func testAggregrateGetTorusKey() async throws {
        let idToken = try generateIdToken(email: TOURUS_TEST_EMAIL)
        let loginParams = LoginParams(verifier: TEST_AGGREGRATE_VERIFIER, verifierId: TOURUS_TEST_EMAIL, idToken: idToken, subVerifierInfoArray: [TorusSubVerifierInfo(verifier: TEST_VERIFIER, idToken: idToken)])
        let torusKey = try await singleFactoreAuth.getKey(loginParams: loginParams)
        
        let requiredPrivateKey = BigInt("ad47959db4cb2e63e641bac285df1b944f54d1a1cecdaeea40042b60d53c35d2", radix: 16)
        XCTAssertTrue(requiredPrivateKey == torusKey.getPrivateKey())
        XCTAssertEqual(torusKey.publicAddress, torusKey.getPublicAddress())
    }
}
