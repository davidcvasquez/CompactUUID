//===----------------------------------------------------------------------===//
//
// This source file is part of the CompactUUID open source project
//
// Copyright (c) 2026 David C. Vasquez and the CompactUUID project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See the project's LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

// Acknowledgments
// https://github.com/jrikhof/short-uuid-swift

import XCTest
@testable import CompactUUID

final class CompactUUIDTests: XCTestCase {
    
    let b58 = CompactUUIDGenerator()
    let b90 = CompactUUIDGenerator(format: .cookieBase90)

    func test_default_alpabet_is_b58() {
        XCTAssertEqual(b58.alphabet, CompactUUIDGenerator.base58)
    }
    
    func test_set_alphabet_to_b90() {
        XCTAssertEqual(b90.alphabet, CompactUUIDGenerator.cookieBase90)
    }
    
    func test_create_compactId_is_not_nil() {
        let compactId = b58.generate()
        XCTAssertNotNil(compactId)
    }
    
    func test_create_compactId_is_not_empty() {
        let compactId = b58.generate()
        XCTAssertFalse(compactId.isEmpty)
    }
    
    func test_create_uuid_from_compactId() {
        let uuid = b58.toUUID("mhvXdrZT4jP5T8vBxuvm75")
        XCTAssertEqual(uuid?.description, "A44521D0-0FB8-4ADE-8002-3385545C3318")
    }
    
    func test_create_compactId_from_uuid() {
        let compactId = b58.fromUUID(UUID(uuidString: "a44521d0-0fb8-4ade-8002-3385545c3318")!)
        XCTAssertEqual(compactId, "mhvXdrZT4jP5T8vBxuvm75")
    }
    
    func test_translate_back_b58() {
        let originalUUID = UUID()
        let compactId = b58.fromUUID(originalUUID)
        let uuid = b58.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }
    
    func test_translate_back_b90() {
        let originalUUID = UUID()
        let compactId = b90.fromUUID(originalUUID)
        let uuid = b90.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }
    
    func test_handle_uuid_with_leading_zeros_b58() {
        let originalUUID = UUID(uuidString: "00000000-a70c-4ebd-8f2b-540f7e709092")!
        let compactId = b58.fromUUID(originalUUID)
        let uuid = b58.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }
    
    func test_handle_uuid_with_leading_zeros_b90() {
        let originalUUID = UUID(uuidString: "00000000-a70c-4ebd-8f2b-540f7e709092")!
        let compactId = b90.fromUUID(originalUUID)
        let uuid = b90.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }
    
    func test_handle_uuid_with_all_zeros_b58() {
        let originalUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let compactId = b58.fromUUID(originalUUID)
        let uuid = b58.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }
    
    func test_handle_uuid_with_all_zeros_b90() {
        let originalUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let compactId = b90.fromUUID(originalUUID)
        let uuid = b90.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }
    
    static var allTests = [
        ("test_default_alpabet_is_b58", test_default_alpabet_is_b58),
        ("test_set_alphabet_to_b90", test_set_alphabet_to_b90),
        ("test_create_compactId_is_not_nil", test_create_compactId_is_not_nil),
        ("test_create_compactId_is_not_empty", test_create_compactId_is_not_empty),
        ("test_create_uuid_from_compactId", test_create_uuid_from_compactId),
        ("test_create_compactId_from_uuid", test_create_compactId_from_uuid),
        ("test_translate_back_b58", test_translate_back_b58),
        ("test_translate_back_b90", test_translate_back_b90),
        ("test_handle_uuid_with_leading_zeros_b58", test_handle_uuid_with_leading_zeros_b58),
        ("test_handle_uuid_with_leading_zeros_b90", test_handle_uuid_with_leading_zeros_b90),
        ("test_handle_uuid_with_all_zeros_b58", test_handle_uuid_with_all_zeros_b58),
        ("test_handle_uuid_with_all_zeros_b90", test_handle_uuid_with_all_zeros_b90)
    ]
}
