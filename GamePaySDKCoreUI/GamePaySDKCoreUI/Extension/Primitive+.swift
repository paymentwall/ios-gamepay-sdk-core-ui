//
//  Primitive+.swift
//  GamePaySDKCoreUI
//
//  Created by Luke Nguyen on 24/7/25.
//

extension String {
    func chunked(into size: Int) -> [String] {
        var result: [String] = []
        var start = startIndex
        while start < endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            result.append(String(self[start..<end]))
            start = end
        }
        return result
    }
    
    func isStringContainsOnlyNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    /// String extension for Date
    public func toDate(format: String,
                locale: Locale = .current,
                timeZone: TimeZone? = .current,
                calendar: Calendar = Calendar(identifier: .gregorian)) -> Date? {
        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.locale = locale
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from:self)
        return date
    }
    
    func extractBase64Data() -> Data? {
        guard let base64Range = self.range(of: "base64,") else { return nil }
        let base64String = String(self[base64Range.upperBound...])
        return Data(base64Encoded: base64String)
    }
    
    func getFlagScalar() -> String? {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        var flag = ""
        
        for scalar in self.uppercased().unicodeScalars {
            guard let flagScalar = UnicodeScalar(flagBase + scalar.value) else {
                return nil
            }
            flag.append(String(flagScalar))
        }
        
        return flag.count != 1 ? nil : flag
    }
}

extension Date {
    public func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    public func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
