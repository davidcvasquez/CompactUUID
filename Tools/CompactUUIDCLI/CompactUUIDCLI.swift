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
import Foundation     // UUID
import ArgumentParser
import CompactUUID

@main
struct CompactUUIDCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "compactuuid",
        abstract: "Generate a random compact UUID string in one of several formats, or convert to and from full UUID strings."
    )

    @Flag(
        name: [
            .customLong("allFormats"),
            .customLong("allformats"),
            .short
        ],
        help: "Generate a compact UUID for every format. Can be combined with the fromUUID option."
    )
    var allFormats: Bool = false

    @Option(
        name: .shortAndLong,
        help: "Set the compact UUID string format."
    )
    var format: CompactUUIDGenerator.Format = .base58

    @Option(
        name: [
            .customLong("fromUUID"),
            .customLong("fromuuid")
        ],
        help: ArgumentHelp(
            "Convert a full UUID string (with hyphens) into a compact UUID string.",
            valueName: "fullUUID")
    )
    var fromUUID: String?

    @Option(
        name: [
            .customLong("toUUID"),
            .customLong("touuid"),
            .short
        ],
        help: ArgumentHelp(
            "Convert a compact UUID string into a full UUID string (with hyphens).",
            valueName: "compactUUID"))
    var toUUID: String?

    @Flag(
        name: [
            .customLong("alphabet"),
            .customLong("alpha"),
        ],
        help: "Print the alphabet for the selected format."
    )
    var alphabet: Bool = false

    // Evaluate options and print the output.
    mutating func run() throws {
        if !printAllFormatsIfOptioned() {
            let generator = CompactUUIDGenerator(format: format)

            if !printToUUIDIfOptioned(generator: generator) {
                if !printFromUUIDIfOptioned(generator: generator) {
                    // Generate new compact UUID
                    print(generator.generate())
                }
            }

            printAlphabetIfOptioned(generator: generator, format: format)
        }
    }

    // Prints all formats, optionally for a given full UUID, and optionally with the alphabet.
    func printAllFormatsIfOptioned() -> Bool {
        if allFormats {
            var uuid: UUID?
            if let fromUUID {
                // Protect a later forced optional on uuid by exiting early if the guard fails.
                guard let _uuid = UUID(uuidString: fromUUID) else {
                    print("Invalid UUID string: \(fromUUID)")
                    return true
                }
                uuid = _uuid
            }

            for format in CompactUUIDGenerator.Format.allCases {
                let generator = CompactUUIDGenerator(format: format)
                if let fromUUID {
                    // This forced optional is protected by the guard on the UUID result.
                    print(generator.fromUUID(uuid!))
                }
                else {
                    print("\(format.rawValue): \(generator.generate())")
                }
                printAlphabetIfOptioned(generator: generator, format: format)
            }
        }
        return allFormats
    }

    // Compact → full UUID
    func printToUUIDIfOptioned(generator: CompactUUIDGenerator) -> Bool {
        if let toUUID {
            if let uuid = generator.toUUID(toUUID) {
                print(uuid.uuidString)
            } else {
                print("Invalid format.")
            }
        }
        return toUUID != nil
    }

    // Full UUID → compact
    func printFromUUIDIfOptioned(generator: CompactUUIDGenerator) -> Bool {
        if let fromUUID {
            if let uuid = UUID(uuidString: fromUUID) {
                print(generator.fromUUID(uuid))
            }
            else {
                print("Invalid UUID string: \(fromUUID)")
            }
        }
        return fromUUID != nil
    }

    // Print the alphabet for the selected format.
    func printAlphabetIfOptioned(
        generator: CompactUUIDGenerator,
        format: CompactUUIDGenerator.Format
    ) {
        if alphabet {                               // Optional alphabet
            print("alphabet for \(format.rawValue): \(generator.alphabet)")
        }
    }
}
