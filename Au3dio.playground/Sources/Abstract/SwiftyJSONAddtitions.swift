
import Foundation

public extension JSON {

    public init(contentsOfFile: String, options: NSDataReadingOptions = NSDataReadingOptions(rawValue: 0)) throws {
        let data = try NSData(contentsOfFile: contentsOfFile, options: options)
        self.init(data)
    }

    public init(contentsOfURL: NSURL, options: NSDataReadingOptions = NSDataReadingOptions(rawValue: 0)) throws {
        let data = try NSData(contentsOfURL: contentsOfURL, options: options)
        self.init(data)
    }

}
