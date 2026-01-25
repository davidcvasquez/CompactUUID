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
import ArgumentParser
import CompactUUID

@main
struct CompactUUIDCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "compactuuid",
        abstract: "Generate a compact UUID string in one of several formats."
    )

    @Option(
        name: .shortAndLong,
        help: "Output format. One of: \(CompactUUIDGenerator.Format.allCases.map(\.rawValue).joined(separator: ", "))."
    )
    var format: CompactUUIDGenerator.Format = .base58

    mutating func run() throws {
        let s = CompactUUIDGenerator(format: format).generate()
        print(s)
    }
}
