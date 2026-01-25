# ``CompactUUID``

Generate compact, human-friendly string representations of `UUID`, with multiple alphabets for readability, URL safety, cookies, or even emojis.

## Overview

`CompactUUID` is built around ``CompactUUIDGenerator``:

- Generate new compact IDs with ``CompactUUIDGenerator/generate()``
- Convert compact IDs back into `UUID` with ``CompactUUIDGenerator/toUUID(_:)``
- Encode a known `UUID` with ``CompactUUIDGenerator/fromUUID(_:)``
- Choose an alphabet using ``CompactUUIDGenerator/Format``

For convenience, the package also includes `String` factory properties for common formats (for example ``Swift/String/idBase58``).

## Choosing a format

- Use ``CompactUUIDGenerator/Format/base58`` when humans might read or type the ID.
- Use ``CompactUUIDGenerator/Format/urlSafeBase75`` for URLs and filenames.
- Use ``CompactUUIDGenerator/Format/cookieBase90`` when ASCII compactness matters (cookies, headers).
- Use ``CompactUUIDGenerator/Format/base64`` when you want a standard alphabet.
- Use ``CompactUUIDGenerator/Format/emojis`` for fun during development (not recommended for production).

## Topics

### Essentials

- ``CompactUUIDGenerator``
- ``CompactUUIDGenerator/Format``

### String convenience IDs

- ``Swift/String/idBase58``
- ``Swift/String/idBase64``
- ``Swift/String/idUrlSafeBase75``
- ``Swift/String/idCookieBase90``
- ``Swift/String/idEmojis``

### Type aliases

- ``UUIDBase58``
- ``UUIDBase64``
- ``UUIDURLSafeBase75``
- ``UUIDCookieBase90``
- ``UUIDEmojis``
  
