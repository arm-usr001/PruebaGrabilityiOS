//
//  CommonUtils.swift
//  PruebaGrabilityiOS_TheMovieDB
//
//  Created by Arm on 09/07/21.
//  Copyright © 2021 Arm. All rights reserved.
//

import Foundation

//For handle the custom releaseDate format, used by JSONDecoder.
extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date{
    func dateShort() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM y"
        return formatter.string(from: self)
    }
}
