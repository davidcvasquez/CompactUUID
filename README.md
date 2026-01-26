# CompactUUID

An expanded version of Jeroen Rikhof's ShortUUID library package for Swift\:

https://github.com/jrikhof/short-uuid-swift/tree/master

Provides `String` extensions that enable using compact dot notation to select which format to use.

Additional formats are also provided, which trade off readability for increased compactness.

A command line interface tool is also available, with a "--format" option.

## Details


CompactUUID starts with RFC4122 v4-compliant UUIDs and translates them into more compact formats. It also provides translators to convert back and forth from RFC complaint UUIDs to the compact formats.

## Usage

Import CompactUUID into your Swift code using its module name\:
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

## Supported Versions

The minimum Swift version supported by CompactUUID is 5.9.
