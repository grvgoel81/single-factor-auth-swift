//
//  AquaTest.swift
//  
//
//  Created by Gaurav Goel on 17/04/23.
//

import XCTest
import JWTKit
import BigInt

@testable import SingleFactorAuth

final class AquaTest: XCTestCase {
    
    var singleFactoreAuth: SingleFactorAuth!
    var singleFactorAuthArgs: SingleFactorAuthArgs!
    
    let TOURUS_TEST_EMAIL = "hello@tor.us"
    let TEST_VERIFIER = "torus-test-health"
    let TEST_AGGREGRATE_VERIFIER = "torus-test-health-aggregate"
    
    override func setUp() {
        singleFactorAuthArgs = SingleFactorAuthArgs(network: TorusNetwork.AQUA)
        singleFactoreAuth = SingleFactorAuth(singleFactorAuthArgs: singleFactorAuthArgs)
    }
    
    func testGetTorusKey() async throws {
        let idToken = try generateIdToken(email: TOURUS_TEST_EMAIL)
        let loginParams = LoginParams(verifier: TEST_VERIFIER, verifierId: TOURUS_TEST_EMAIL, idToken: idToken)
        let torusKey = try await singleFactoreAuth.getKey(loginParams: loginParams)
        
        let requiredPrivateKey = BigInt("d8204e9f8c270647294c54acd8d49ee208789f981a7503158e122527d38626d8", radix: 16)
        XCTAssertTrue(requiredPrivateKey == torusKey.getPrivateKey())
        XCTAssertEqual(torusKey.publicAddress, torusKey.getPublicAddress())
    }
    
    func testAggregrateGetTorusKey() async throws {
        let idToken = try generateIdToken(email: TOURUS_TEST_EMAIL)
        let loginParams = LoginParams(verifier: TEST_AGGREGRATE_VERIFIER, verifierId: TOURUS_TEST_EMAIL, idToken: idToken, subVerifierInfoArray: [TorusSubVerifierInfo(verifier: TEST_VERIFIER, idToken: idToken)])
        let torusKey = try await singleFactoreAuth.getKey(loginParams: loginParams)
        
        let requiredPrivateKey = BigInt("6f8b884f19975fb0d138ed21b22a6a7e1b79e37f611d0a29f1442b34efc6bacd", radix: 16)
        XCTAssertTrue(requiredPrivateKey == torusKey.getPrivateKey())
        XCTAssertEqual(torusKey.publicAddress, torusKey.getPublicAddress())
    }
}

