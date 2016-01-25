
import Foundation
import SwiftyJSON

public extension JSON {
    /// Creates a JSON instance by reading contents of a file.
    /// :throws: NSError(NSPOSIXErrorDomain, ENOENT, [NSFilePathErrorKey: String])
    public init(contentsOfFile: String) throws {
        if let data = NSData(contentsOfFile: contentsOfFile) {
            self.init(data: data)
            if let error = self.error {
                throw error
            }
        } else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(ENOENT), userInfo: [NSFilePathErrorKey: contentsOfFile])
        }
    }
    /// Creates a JSON instance by reading contents of an URL.
    /// :throws: NSError(NSPOSIXErrorDomain, ENOENT, [NSFilePathErrorKey: String])
    public init(contentsOfURL: NSURL) throws {
        if let data = NSData(contentsOfURL: contentsOfURL) {
            self.init(data: data)
            if let error = self.error {
                throw error
            }
        } else {
            throw NSError(domain: NSPOSIXErrorDomain, code: Int(ENOENT), userInfo: [NSURLErrorFailingURLStringErrorKey: contentsOfURL])
        }
    }

}
