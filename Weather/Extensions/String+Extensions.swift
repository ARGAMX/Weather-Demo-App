//
//  String+Extensions.swift
//

import UIKit
import CommonCrypto


extension String {
    func localized() -> String {
        // Not implemented yet
        return self
    }
}

extension String {
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: count))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
}

extension String {
    func replace(of originalString: String, with newString: String) -> String {
        return self.replacingOccurrences(of: originalString, with: newString)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    func htmlAttributedString() -> NSMutableAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType: NSMutableAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
}

extension String {
    func plainNoHTMLtext() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
}

extension String {
    
    func sizeWithFont(_ font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: [.usesFontLeading, .truncatesLastVisibleLine,.usesLineFragmentOrigin], context: nil)
        
        let size = rect.integral.size
        return size
    }
    
    func stringByRemovingNonNumericCharacters() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits
            .inverted)
            .joined(separator: "")
    }
    
    func telpromptURL() -> URL? {
        if self.isEmpty {
            return nil
        }
        return URL(string: "telprompt://+\(self.stringByRemovingNonNumericCharacters())")
    }
    
    func rangeOf(_ string: String) -> NSRange? {
        let range = NSString(string: self).range(of: string)
        return range.location != NSNotFound ? range : nil
    }
    
    func toDouble() -> Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0
    }
    
    var digitsOnly: String {
        let stringArray = self.components(
            separatedBy: CharacterSet.decimalDigits.inverted)
        return stringArray.joined(separator: "")
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func matchesRegex(_ regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = self as NSString
            let match = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func reverese() -> String {
        return String(reversed())
    }
    
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func leftAndRightPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return (([character] + self + [character]).leftAndRightPadding(toLength: toLength, withPad: character))
        } else {
            return self
        }
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension String {
    static func random(_ length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = Int(arc4random_uniform(UInt32(base.count)))
            randomString.append(base[base.index(base.startIndex, offsetBy: randomValue)])
        }
        
        return randomString
    }
}

extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }

        return hexString
    }

}
