
import Foundation

public extension JSON {

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
