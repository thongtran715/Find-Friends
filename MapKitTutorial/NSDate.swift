//
//  NSDate.swift
//  Note
//
//  Created by Thong Tran on 6/22/16.
//  Copyright © 2016 ThongApp. All rights reserved.
//

import Foundation

extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
}