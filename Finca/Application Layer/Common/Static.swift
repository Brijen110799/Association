//
//  Static.swift
//  Finca
//
//  Created by Fincasys Macmini on 22/06/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import Foundation
import UIKit

class Static: NSObject {
    
    static let sharedInstance : Static = {
           let instance = Static()
           return instance
       }()
    
    static let INFORMATION_IMG = "check"
    
     let YYYYMMDD = "yyyy-MM-dd"
     let LLLL = "LLLL"
     let MMM = "MMM"

    
    //    static let SCREEN_SIZE: CGRect = UIScreen.main.bounds
    //    static let kNoInternetConnection = "Not connected to Internet."
    //    static let SERVER_ERROR = "Server Error"
    //    static var SOMETHING_WENT_WRONG_PLEASE_TRY_LATER = "Something went wrong , please try again later!"
    //    static var REQUEST_TIMED_OUT = "Request timed out"
    //    static let PARSING_ERROR = "PARSING_ERROR"
    //    static let PLEASE_WAIT = "Please wait..."
    //    static let NO_DATA_FOUND = "No Data Found"

    
    let zoobiz_font_name = "poppins"
    let zoobiz_font_light = "poppins-Light"
    let zoobiz_font_regular = "poppins-Regular"
    let zoobiz_font_medium = "poppins-Medium"
    let zoobiz_font_semibold = "poppins-Semibold"
    let zoobiz_font_bold = "poppins-Bold"
    let zoobiz_font_extrabold = "poppins-Extrabold"
    
//    Great-Vibes.ttf
    
//    Gotham-Book.ttf
//    Gotham-Bold.ttf
//    Gotham-Black.ttf
    
//    Montserrat-Semibold.ttf
//    Montserrat-Regular.ttf
    
    let font_great_vibes = "Great Vibes"
    let font_gotham_book = "Gotham Book"
    let font_gotham_bold = "Gotham Bold"
    let font_gotham_black = "Gotham Black"
    
    let font_montserrat_semibold = "Montserrat-Semibold"
    let font_montserrat_regular = "Montserrat-Regular"
     let font_montserrat_bold = "Montserrat-Bold"
    
    let font_Modern = "Modern"
//    let font_Modern = "Modern-Regular"
    let font_Courier_Bold = "courier-Bold"
//    courier_bold
    let font_Roboto_Black = "Roboto-Black"
    let font_SF_Bold = "SanFranciscoDisplay-Bold"
//    let font_SF_Bold = "SF-Bold"
    let font_Great_Vibes = "Great Vibes"
    let font_Bubble = "BubbleBobble"
    let font_Comic = "SFArchRival-Bold"
    let font_Stencil = "BigShouldersStencilDisplay-Bold"
        
    
    
  
    
    let shareText = ""
    
//    let shareText = "Hey, I'm using Zoobiz App for growing my business ! Download it here:\n\nAndroid Link :\n \(sharedInstance.zoobiz_Android_AppLink)\n\niOS Link :\n\(sharedInstance.zoobiz_iOS_AppLink)"


}
