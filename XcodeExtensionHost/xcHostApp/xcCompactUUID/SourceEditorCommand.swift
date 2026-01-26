//
//  SourceEditorCommand.swift
//  xcCompactUUID
//
//  Created by David Vasquez on 1/26/26.
//

import Foundation
import XcodeKit
import CompactUUID

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

        let bundleName = Bundle.main.bundleIdentifier ?? ""
        var format: CompactUUIDGenerator.Format = .base58
        switch invocation.commandIdentifier {
        case "\(bundleName).InsertBase58":
            format = .base58

        case "\(bundleName).InsertBase64":
            format = .base64

        case "\(bundleName).InsertURLSafeBase75":
            format = .urlSafeBase75

        case "\(bundleName).InsertCookieBase90":
            format = .cookieBase90

        case "\(bundleName).InsertEmojis":
            format = .emojis

        default:
            break
        }
        let generator = CompactUUIDGenerator(format: format)

        // Xcode represents cursors/selections as ranges of (line, column).
        for case let range as XCSourceTextRange in invocation.buffer.selections {
            let newID = generator.generate()
            replace(range: range, in: invocation.buffer, with: newID)

            // Put cursor after the inserted text (nice for continuing typing)
            let delta = newID.utf16.count
            let pos = XCSourceTextPosition(line: range.start.line, column: range.start.column + delta)
            range.start = pos
            range.end = pos
        }

        completionHandler(nil)
    }

    private func replace(range: XCSourceTextRange,
                         in buffer: XCSourceTextBuffer,
                         with text: String) {
        let startLine = range.start.line
        let startCol  = range.start.column
        let endLine   = range.end.line
        let endCol    = range.end.column

        guard startLine >= 0, endLine >= 0,
              startLine < buffer.lines.count,
              endLine < buffer.lines.count,
              let startStr = buffer.lines[startLine] as? String,
              let endStr   = buffer.lines[endLine] as? String
        else { return }

        if startLine == endLine {
            // Insert/replace within one line (columns are UTF-16 indices)
            let ns = startStr as NSString
            let safeStart = max(0, min(startCol, ns.length))
            let safeEnd   = max(0, min(endCol, ns.length))

            let prefix = ns.substring(to: safeStart)
            let suffix = ns.substring(from: safeEnd)
            buffer.lines[startLine] = prefix + text + suffix
        } else {
            // Replace selection spanning multiple lines (columns are UTF-16 indices)
            let nsStart = startStr as NSString
            let nsEnd   = endStr as NSString

            let safeStartCol = max(0, min(startCol, nsStart.length))
            let safeEndCol   = max(0, min(endCol, nsEnd.length))

            let prefix = nsStart.substring(to: safeStartCol)
            let suffix = nsEnd.substring(from: safeEndCol)

            buffer.lines.removeObjects(in: NSRange(location: startLine,
                                                   length: endLine - startLine + 1))
            buffer.lines.insert(prefix + text + suffix, at: startLine)
        }
    }
}
