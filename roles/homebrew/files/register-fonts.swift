// Registers every font in ~/Library/Fonts with CoreText so apps like iTerm2
// can see them. Homebrew casks copy font files there, but macOS does not
// always pick them up until they are explicitly registered.
import CoreText
import Foundation

let dir = NSHomeDirectory() + "/Library/Fonts"
let exts: Set<String> = ["ttf", "otf", "ttc"]
let urls = ((try? FileManager.default.contentsOfDirectory(atPath: dir)) ?? [])
  .map { URL(fileURLWithPath: dir).appendingPathComponent($0) }
  .filter { exts.contains($0.pathExtension.lowercased()) }

var registered = 0
var failed = 0
for url in urls {
  var error: Unmanaged<CFError>?
  if CTFontManagerRegisterFontsForURL(url as CFURL, .persistent, &error) {
    registered += 1
  } else if let e = error?.takeRetainedValue(),
            CFErrorGetCode(e) != CTFontManagerError.alreadyRegistered.rawValue {
    failed += 1
    FileHandle.standardError.write("\(url.lastPathComponent): \(e)\n".data(using: .utf8)!)
  }
}
print("registered=\(registered) failed=\(failed)")
exit(failed > 0 ? 1 : 0)
