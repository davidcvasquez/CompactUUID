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
    let b64 = CompactUUIDGenerator(format: .base64)
    let u75 = CompactUUIDGenerator(format: .urlSafeBase75)
    let b90 = CompactUUIDGenerator(format: .cookieBase90)
    let bEm = CompactUUIDGenerator(format: .emojis)

    func test_idBase58() {
        let id: UUIDBase58 = .idBase58
        XCTAssertFalse(id.isEmpty)
    }

    func test_idBase64() {
        let id: UUIDBase64 = .idBase64
        XCTAssertFalse(id.isEmpty)
    }

    func test_idURLSafeBase75() {
        let id: UUIDURLSafeBase75 = .idUrlSafeBase75
        XCTAssertFalse(id.isEmpty)
    }

    func test_idBase90() {
        let id: UUIDCookieBase90 = .idCookieBase90
        XCTAssertFalse(id.isEmpty)
    }

    func test_idEmojis() {
        let id: UUIDEmojis = .idEmojis
        XCTAssertFalse(id.isEmpty)
    }

    func test_default_alpabet_is_b58() {
        XCTAssertEqual(b58.alphabet, CompactUUIDGenerator.base58)
    }

    func test_default_alpabet_is_b64() {
        XCTAssertEqual(b64.alphabet, CompactUUIDGenerator.base64)
    }

    func test_default_alpabet_is_u75() {
        XCTAssertEqual(u75.alphabet, CompactUUIDGenerator.urlSafeBase75)
    }

    func test_set_alphabet_to_b90() {
        XCTAssertEqual(b90.alphabet, CompactUUIDGenerator.cookieBase90)
    }

    func test_default_alpabet_is_bEm() {
        XCTAssertEqual(bEm.alphabet, CompactUUIDGenerator.emojis)
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

    func test_handle_uuid_with_all_zeros_b64() {
        let originalUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let compactId = b64.fromUUID(originalUUID)
        let uuid = b64.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }

    func test_handle_uuid_with_all_zeros_u75() {
        let originalUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let compactId = u75.fromUUID(originalUUID)
        let uuid = u75.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }

    func test_handle_uuid_with_all_zeros_b90() {
        let originalUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let compactId = b90.fromUUID(originalUUID)
        let uuid = b90.toUUID(compactId)
        XCTAssertEqual(uuid, originalUUID)
    }

    func test_not_in_alphabet_b58() {
        let compactID = "lllOOO000"
        let toUUID = b58.toUUID(compactID)
        XCTAssertNil(toUUID)
    }

    func test_invalid_full_uuid() {
        // Not 32 characters without hyphens
        let invalidFullUUID1 = "-a70c-4ebd-8f2b-540f7e70909"
        let withUUIDHyphens1 = invalidFullUUID1.withUUIDHyphens()
        XCTAssertEqual(invalidFullUUID1, withUUIDHyphens1)

        // 32 characters, but contains invalid characters
        let invalidFullUUID2 = "0000000 ZZZZ 0000000000000000000"
        let withUUIDHyphens2 = invalidFullUUID2.withUUIDHyphens()
        XCTAssertEqual(invalidFullUUID2, withUUIDHyphens2)
    }

    func test_case_insensitive_argument_format() {
        // Lowercase value does not match intercap.
        let format = CompactUUIDGenerator.Format(argument: "cookiebase90")
        XCTAssertEqual(format, .cookieBase90)
    }

    func test_invalid_argument_format() {
        // Invalid value does not match any format.
        let format = CompactUUIDGenerator.Format(argument: "invalidFormat")
        XCTAssertNotEqual(format, .base58)
        XCTAssertNotEqual(format, .base64)
        XCTAssertNotEqual(format, .urlSafeBase75)
        XCTAssertNotEqual(format, .cookieBase90)
        XCTAssertNotEqual(format, .emojis)
    }

    func test_change_format() {
        let gen = CompactUUIDGenerator(format: .base64)
        gen.format = .base58
        XCTAssertNotEqual(gen.format, .base64)
        XCTAssertEqual(gen.format, .base58)
        XCTAssertEqual(gen.alphabet, CompactUUIDGenerator.base58)
    }

    func test_fromUUID_invalid_alphabet() {
        let uuidString = "00000000-0000-0000-0000-000000000000"
        let originalUUID = UUID(uuidString: uuidString)!
        let gen = CompactUUIDGenerator(format: .base64)
        gen.clearAlphabet()
        XCTAssertEqual(gen.fromUUID(originalUUID), uuidString)
    }
}
