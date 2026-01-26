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

import Foundation
import AnyBase
import ArgumentParser

/// A human-friendly format that omits characters prone to typos.
public typealias UUIDBase58 = String

nonisolated public extension UUIDBase58 {
    /// Usage:
    /// ```
    /// struct MyType: Identifiable {
    ///     let id: UUIDBase58 = .idBase58
    /// }
    /// ```
    static var idBase58: UUIDBase58 {
        CompactUUIDGenerator(format: .base58).generate()
    }
}

/// Other shortened formats that trade off readability for increased compactness.

/// A more compact standard format that includes all letters and numeric digits.
public typealias UUIDBase64 = String

nonisolated public extension UUIDBase64 {
    /// ```
    /// struct MyType: Identifiable {
    ///     let id: UUIDBase64 = .idBase64
    /// }
    /// ```
    static var idBase64: UUIDBase64 {
        CompactUUIDGenerator(format: .base64).generate()
    }
}

/// A format with URL-safe characters.
public typealias UUIDURLSafeBase75 = String

nonisolated public extension UUIDURLSafeBase75 {
    /// ```
    /// struct MyType: Identifiable {
    ///     let id: UUIDURLSafeBase75 = .idUrlSafeBase75
    /// }
    /// ```
    static var idUrlSafeBase75: UUIDURLSafeBase75 {
        CompactUUIDGenerator(format: .urlSafeBase75).generate()
    }
}

/// A format that maximizes ASCII compactness for use as cookies.
public typealias UUIDCookieBase90 = String

nonisolated public extension UUIDCookieBase90 {
    /// ```
    /// struct MyType: Identifiable {
    ///     let id: UUIDCookieBase90 = .idCookieBase90
    /// }
    /// ```
    static var idCookieBase90: UUIDCookieBase90 {
        CompactUUIDGenerator(format: .cookieBase90).generate()
    }
}

/// A curated set of renderable emoji characters.
/// This format is fun to use during Development, but not recommended for use in Production.
public typealias UUIDEmojis = String

nonisolated public extension UUIDEmojis {
    /// ```
    /// struct MyType: Identifiable {
    ///     let id: UUIDEmojis = .idEmojis
    /// }
    /// ```
    static var idEmojis: UUIDEmojis {
        CompactUUIDGenerator(format: .emojis).generate()
    }
}

nonisolated public final class CompactUUIDGenerator {
    /// Determines which alphabet to use for encoding the compact UUID representation.
    public enum Format: String, CaseIterable {
	    /// Omits characters prone to typos; lowercase "l", zero, and uppercase "O".
        case base58

    	/// A more compact standard format that includes all letters and numeric digits.
        case base64

    	/// A format with URL-safe characters.
        /// https://stackoverflow.com/questions/695438/what-are-the-safe-characters-for-making-urls
        case urlSafeBase75

    	/// A format that maximizes ASCII compactness for use as cookies.
        case cookieBase90

    	/// A curated set of renderable emoji characters.
        case emojis
    }

    /// The alphabet used to encode the compact UUID representation.
    public private(set) var alphabet: String = ""

    /// - Returns: A compact representation of a new, random UUID, which uses a smaller number of characters.
    public func generate() -> String {
        self.fromUUID(UUID())
    }

    public var format: Format {
        didSet {
            updateAlphabet()
        }
    }

    /// - Parameter format: The format to use for encoding the compact UUID representation
    public init(format: Format = .base58) {
        self.format = format
        updateAlphabet()
    }

    private func updateAlphabet() {
        switch self.format {
        case .base58:
            self.alphabet = Self.base58

        case .base64:
            self.alphabet = Self.base64

        case .cookieBase90:
            self.alphabet = Self.cookieBase90

        case .urlSafeBase75:
            self.alphabet = Self.urlSafeBase75

        case .emojis:
            self.alphabet = Self.emojis
        }
    }

    /// - Returns: The original UUID, decoded from its compact representation.
    public func toUUID(_ compactID: String) -> UUID? {
        let uu1: String
        do {
            let toHex = try AnyBase(self.alphabet, AnyBase.HEX)
            uu1 = try toHex.convert(compactID)
        } catch {
            return nil
        }

        var leftPad = ""
        let len = uu1.count
        // Pad out UUIDs beginning with zeros (any number shorter than 32 characters of hex)
        if len < 32 {
            (0..<32-len).forEach { _ in leftPad += "0" }
        }

        let uuidString = (leftPad + uu1).withUUIDHyphens()
        return UUID(uuidString: uuidString)
    }

    /// - Returns: A compact representation of a specific ID.
    public func fromUUID(_ uuid: UUID) -> String {
        guard let fromHex = try? AnyBase(AnyBase.HEX, self.alphabet),
            let shortId = try? fromHex.convert(
                uuid.uuidString.lowercased().replacingOccurrences(of: "-", with: "")) else {
            return uuid.uuidString
        }
        return shortId
    }
    
    /// Omits characters that can be easily confused; lowercase "l", zero, and uppercase "O".
    static let base58 =
        "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"

    /// A more compact standard format that includes all letters and numeric digits.
    /// A-Z a-z 0-9 + /
    static let base64 =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    
    /// A format with URL-safe characters.
    /// A-Z  a-z  0-9  - . _ ~ ( ) ' ! * : @ , ;
    static let urlSafeBase75 =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~()'!*:@,;"

    /// A format that maximizes ASCII compactness for use as cookies.
    /// A-Z  a-z  0-9  ! # $ % & ' ( ) * + - . / : < = > ? @ [ ] ^ _ ` { | } ~
    static let cookieBase90 =
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&'()*+-./:<=>?@[]^_`{|}~"

    /// A curated set of renderable emoji characters.
    static let emojis: String = {
        let ranges: [ClosedRange<UInt32>] = [
            0x1F300...0x1F5FF,
            0x1F600...0x1F64F,
            0x1F680...0x1F6FF,
            0x1F900...0x1F9FF,
            0x1FA70...0x1FAFF,
            0x2600...0x26FF,
            0x2700...0x27BF
        ]

        var s = String()

        for range in ranges {
            for v in range {
                if let scalar = UnicodeScalar(v), scalar.properties.isEmojiPresentation {
                    s.unicodeScalars.append(scalar)
                }
            }
        }

        return s
    }()
}

extension String {
    /// - Returns: A hypenated version of a full UUID string. Must be exactly 32 characters or the result is nil.
    nonisolated func withUUIDHyphens() -> String {
        guard !contains("-"), count == 32 else {
            return self
        }

        let pattern = #"(\w{8})(\w{4})(\w{4})(\w{4})(\w{12})"#
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)

        guard let match = matches.first else {
            return self
        }

        var parts: [String] = []
        for i in 1..<match.numberOfRanges {
            if let range = Range(match.range(at: i), in: self) {
                parts.append(self[range].description)
            }
        }
        return parts.joined(separator: "-")
    }
}

// Teach ArgumentParser how to parse CompactUUIDGenerator.Format cases, such as ".base58".
extension CompactUUIDGenerator.Format: ExpressibleByArgument {
    public init?(argument: String) {
        let needle = argument.lowercased()

        guard let match = Self.allCases.first(where: { $0.rawValue.lowercased() == needle }) else {
            return nil
        }

        self = match
    }
}
