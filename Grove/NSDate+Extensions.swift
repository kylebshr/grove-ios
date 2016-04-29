//
//  NSDate+Extensions.swift
//  Whereno
//
//  Created by Kyle Bashour on 4/25/16.
//  Copyright © 2016 Kyle Bashour. All rights reserved.
//

import Foundation
import Mapper

private let iso8601Formatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    let locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = locale
    return formatter
}()

extension NSDate: Convertible {

    public static func fromMap(value: AnyObject?) throws -> NSDate {
        guard let string = value as? String, date = iso8601Formatter.dateFromString(string) else {
            throw MapperError.CustomError(field: nil, message: "Improperly formatter date")
        }

        return date
    }
}
