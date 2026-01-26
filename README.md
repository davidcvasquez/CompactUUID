# CompactUUID

[![Swift](https://github.com/davidcvasquez/CompactUUID/actions/workflows/swift.yml/badge.svg)](https://github.com/davidcvasquez/CompactUUID/actions/workflows/swift.yml) [![codecov](https://codecov.io/github/davidcvasquez/CompactUUID/graph/badge.svg?token=1GBPU6S4L6)](https://codecov.io/github/davidcvasquez/CompactUUID)

An expanded version of Jeroen Rikhof's [ShortUUID](https://github.com/jrikhof/short-uuid-swift/tree/master) library package for Swift, with these additions\:

- `String` extensions enable using compact dot notation to select which format to use.
- Additional formats that trade off readability for increased compactness.
- A command line interface (CLI) tool with numerous format and conversion options.

## Details

CompactUUID starts with RFC4122 v4-compliant UUIDs and translates them into more compact formats. It also provides translators to convert back and forth between RFC complaint UUIDs and the compact formats.

The CLI tool provides full access to every feature in CompactUUID.

Comprehensive unit tests provide 100% code coverage as of the 1.1.0 release.

## Usage

Add CompactUUID to your package dependencies and then import the `CompactUUID` module into your Swift code\:
```Swift
import CompactUUID
```

Select a format for your IDs and initialize them with compact dot notation as follows\:
```Swift
struct MyType: Identifiable {
    let id: UUIDBase58 = .idBase58
}
```

You can also access a generator directly and translate between full and compact UUIDs\:
```Swift
let translator = CompactUUIDGenerator()
let compactID = translator.generate()  // eGQRS1nM2t3E8xxcc2BhjA

// Translate UUIDs to and from the shortened format
translator.toUUID(compactID) // a44521d0-0fb8-4ade-8002-3385545c3318
translator.fromUUID(UUID(uuidString: "a44521d0-0fb8-4ade-8002-3385545c3318")!) // mhvXdrZT4jP5T8vBxuvm75

// See the alphabet used by a translator
translator.alphabet

// View the constants
CompactUUIDGenerator.base58 // Omits characters prone to typos; lowercase "l", zero, and uppercase "O".
CompactUUIDGenerator.base64 // Compact standard format that includes all letters and numeric digits.
CompactUUIDGenerator.urlSafeBase75 // URL-safe characters.
CompactUUIDGenerator.cookieBase90 // Maximize ASCII compactness for use as cookies.
CompactUUIDGenerator.emojis // A curated set of renderable emoji characters.
```

## Command Line Interface (CLI)

CompactUUID can be used as a command line tool, with a "format" option that can be used to generate UUIDs in various compact formats.

### Build and install the CLI tool

```bash
git clone https://github.com/davidcvasquez/CompactUUID.git
cd CompactUUID
./install.sh
```

If you see “permission denied” when running install.sh, make it executable\:

```bash
chmod +x install.sh
```

This installs the CLI executable and a man page\:
- `/usr/local/bin/compactuuid`
- `/usr/local/share/man/man1/compactuuid.1`

Verify the CLI tool is working, with and without the `format` parameter, which defaults to base58\:
```bash
compactuuid
fBLNpfEWWaHJ3GKGH3P9xs

compactuuid --format base64
BW07Okov5OrYLQPqHMD+j3

compactuuid --format urlSafeBase75
EVJpM-y*yfN5'p)99*Ox(

compactuuid --format cookieBase90
8UGp?BsRvMeKJ6/p':zi

compactuuid --format emojis
🌎🎺🤩🧷🦎🐔🚝💞🥿💄🐛🕋📧
```

Access the CLI tool's built-in help or the man page as follows\:
```bash
compactuuid --help
man compactuuid
```

The CLI tool also has `allFormats`, `toUUID`, `fromUUID` and `alphabet` options, with built-in help for more details.

## Supported Versions

The minimum Swift version supported by CompactUUID is 5.9.
