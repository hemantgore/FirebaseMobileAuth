//
//  UIFont+Extension.swift
//  FarmerMakert
//
//  Created by Hemant Gore on 24/07/20.
//  Copyright © 2020 Sci-Fi. All rights reserved.
//

import UIKit

extension UIFont {
    class func appRegularFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: Constants.App.regularFont, size: size)!
    }

    class func appBoldFontWith( size:CGFloat ) -> UIFont{
        return  UIFont(name: Constants.App.boldFont, size: size)!
    }
}
