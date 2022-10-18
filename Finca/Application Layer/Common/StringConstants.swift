//
//  StringConstants.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
import PayUMoneyCoreSDK
public struct GatewayTransactionMode {
    public static let GATEWAY_MODE = PUMEnvironment.production
    public static let TEST_MODE = PUMEnvironment.test
}

struct ImageNameConstanst {
    static let img_ppt = UIImage(named: "ppt")
    static let img_doc = UIImage(named: "doc")
    static let img_pdf = UIImage(named: "pdf")
    static let img_png = UIImage(named: "png")
    static let img_jpg = UIImage(named: "jpg")
    static let img_mp3 = UIImage(named: "mp3")
    static let img_mp4 = UIImage(named: "mp4")
}

struct colorNames {
    public static let colorNoti = "colorNoti"
    public static let Placeholder = "gray_40"
    public static let grey40 = "colorNoti"
//    public static let colorNoti = "colorNoti"
}

struct storyboardConstants {
    public static let main = UIStoryboard(name: "Main", bundle: nil)
    public static let sub  = UIStoryboard(name: "sub", bundle: nil)
    public static let temporary = UIStoryboard(name: "Temporary", bundle: nil)
    public static let discussion = UIStoryboard(name: "Discussion", bundle: nil)
    public static let childsecurity = UIStoryboard(name: "childsecurity", bundle: nil)
    public static let chat = UIStoryboard(name: "Chat", bundle: nil)
    public static let kbg = UIStoryboard(name: "KBG", bundle: nil)
    public static let serviceprovider = UIStoryboard(name: "ServiceProvider", bundle: nil)
    public static let complain = UIStoryboard(name: "Complain", bundle: nil)
}

struct ConditionConstants {
    public static let NORMAL_VISITOR="0";
    public static let EXPECTED_VISITOR="1";
    public static let DELIVERY_BOY="2";
    public static let TAXI_DRIVER="3";
    public static let OTHER="5";
    public static let parkingList = 4
}

struct StringConstants {
    static let HOME_BANNER_LOCALLY_VIEWED = "BANNER VIEW STATUS"
    static let VISITOR_ARRIVED = "visitor arrived" 
    static let SLIDER_DATA = "home slider response"
    static let TIMELINE_VIDEO_ID = "TIMELINE VIDEO ID"
    static let SETTING_VIDEO_ID = "TIMELINE VIDEO ID"
    static let CHAT_VIDEO_ID = "CHAT VIDEO ID"
    static let VISITOR_APPROVAL_FLAG = "visitorApproved"
    static let KEY_LOGIN_DATA = "keyDataLogin"
    static let SAVE_NOTIFICATION_TIME = "SaveNotificationtime"
    static let MULTI_SOCIETY_DETAIL = "societyArray"
    static let KEY_MEMBER_DATA = "KeyMember"
    static let KEY_DATE_WITHOUT_FORMAT = "keyMemJoinDateWithoutFormat"
    static let KEY_LOGIN = "KEY_LOGIN"
    static let MENU_DASHBOARD = "Dashboard"
    static let MENU_FUNDBILL = "Fund & Bill"
    static let MENU_MEMBERS = "Members"
    static let MENU_VEHICALS = "Vehicals"
    static let MENU_VISITORS = "Visitors"
    static let MENU_STAFF = "Resource"
    static let MENU_EVENT = "Event"
    static let MENU_NOTICE_BOARD = "Notice Board"
    static let MENU_FACILITY = "Facility"
    static let MENU_COMPLAINTS = "Complaints"
    static let MENU_POLL = "Poll"
    static let MENU_ELECTION = "Elections"
    static let MENU_BUILDING_DETAILS = "Building Details"
    static let MENU_PROFILE = "Profile"
    static let MENU_NOTIFICATION = "Notification"
    static let MENU_BALANCE_SHEET = "Balance Sheet"
    static let MENU_EMERGENCY = "Emergency Number"
    static let MENU_SOS = "SOS to Guard"
    static let MENU_GALLRY = "Gallery"
    static let MENU_DOCUMENT = "Document"
    static let MENU_CHANGE_PASSWORD = "Change Password"
    static let MENU_LOGUT = "Logout"
    static let VISITOR_ONOFF = "visitor_on_off"
    static let MENU_CONTACT_US = "Contact Us"
    static let NOTI_UPDATE_CONTENT = "updateContent"
    static let UPDATE_PASS_LIST = "updatepassList"
    static let KEY_NOTIFIATION = "keyNotificatio"
    static let KEY_DEVICE_TOKEN = "deiveToken"
    static let RUPEE_SYMBOL = "\u{20B9}"
    static let HOME_NAV_CONTROLLER = "idHomeNavController"
    static let KEY_NOTIFICATION_VISITOR = "notification_visitor"
    static let CHAT_STATUS = "chat_status"
    static let READ_STATUS = "read_status"
    static let HIDE_MEMBER_PARKING = "hide_member_parking"
    static let NOTIFICATION_KEY_EXPEC_MEMBER = "addedExpectedMember"
    static let KEY_PASSWORD = "keyPaasword"
    
    static let KEY_BASE_URL = "baseURl"
    static let KEY_API_KEY = "apikey"
    static let KEY_BACKGROUND_IMAGE = "backimage"
    static let MEMBER_DETAILS_KEY = "memberDetails"
    static let KEY_USER_NAME = "userName"
    static let MENU_TIMELINE = "Timeline"
    static let CITYID = "CITY"
    static let STATEID = "STATE"
    static let COUNTRYID = "COUNTRY"
    static let KEY_ACCOUNT_DEACTIVATE = "AccountDeactivate"
    
    static let KEY_PROFILE_PIC = "profilePic"
    static let KEY_IS_FIREBASE = "is_firebase"
    static let KEY_SOCIATY_NAME = "sociatyName"
    static let KEY_SOCIATY_LOGO = "sociatyLogo"
    
    static let BuildingImage = "building details"
    
    static let BANNER_ADV_URL = "BANNER_IMAGE"
    static let BANNER_VIEW_STATUS = "VIEW_STATUS"
    static let BANNER_ACTIVE_STATUS = "ACTIVE_STATUS"
    static let BANNER_VIEWED_ONCE = "banner_displayed"
    
    static let KEY_RELEATION_ARRAY = BaseVC().doGetLocalDataUser().isSociety ?  ["Dad","Mom","Wife","Husband","Brother","Sister","Grandfather","Grandmother","Son","Daughter","Other"] : ["Owner","Employee","Other"]
    static let SECURITY_MPIN_VALUE = "SECURITY_MPIN_VALUE"
    static let SECURITY_MPIN_FLAG = "SECURITY_MPIN_FLAG"
    static let SECURITY_BIOMETRICS_FLAG = "SECURITY_BIOMETRICS_FLAG"
    static let ADD_TENANT_FLAG = "tenant_registration"
    
    
     static let MSG_TYPE_TEXT = "0"
     static let MSG_TYPE_IMAGE = "1"
     static let MSG_TYPE_FILE = "2"
     static let MSG_TYPE_AUDIO = "3"
     static let MSG_TYPE_LOCATION = "4"
     static let MSG_TYPE_CONTACT = "5"
    
    static let MAP_KEY = "AIzaSyAd7RC-UpveDACC-Iu9R_i0eWerkoqH0I4"
    static let KEY_USER_PLACE_HOLDER = "user_default"
    static let KEY_EMOJI = "keyEmoji"
    static let KEY_FEED_ID = "feedId"
    static let KEY_DYANAMIC_PLACEHOLDE = "dynamicPlaceHolde"
    static let KEY_LOGO_PLACE_HOLDER = "finca_logo"
    static let KEY_SERVICE_PROVIDER_PLACE_HOLDER = "service_provider_place_holder"
    static let KEY_BENNER_PLACE_HOLDER = "banner_placeholder"
    
    //payment type
    static let PAYMENTFORTYPE_MAINTENANCE = "0"
    static let PAYMENTFORTYPE_BILL = "1"
    static let PAYMENTFORTYPE_FACILITY = "2"
    static let PAYMENTFORTYPE_EVENT = "3"
    static let PAYMENTFORTYPE_PENALTY = "4"
    static let PAYMENTFORTYPE_PACAKGE_PLAN = "5"
    static let PAYMENTFORTYPE_PACAKGE_PLAN_REGISTER = "6"
    //for select location key
    static let STATE = "state"
    static let CITY = "city"
    
    
    static let KEY_ASSOS_TYPE = "associationType"
    static let KEY_MEM_EXPIRY_DATE = "membershipExpiryDate"
    static let KEY_MEM_JOINING_DATE = "membershipJoiningDate"
    static let VEHICLE_PHOTO_REQUIRED = "vehiclephotorequired"
    static let RC_BOOK_PHOTO_REQUIRED = "rcbookphotorequired"
    static let show_service_provider_timeline_seprate = "showserviceprovidertimelineseprate"


    static let KEY_CHAT_ACCESS = "userchataccess"
    static let KEY_HIDE_CHAT = "hideChat"
    static let KEY_HIDE_TIMELINE = "hideTimeLine"
    static let KEY_TIMELINE_USER_ACCESS = "Timelineuseraccess"
    static let KEY_SLIDER_DATA = "slideDataNew"
    static let KEY_HIDE_PROFESSIONAL = "hideProfessional"
    static let KEY_VIRTUAL_WALLET = "virtualWallet"
    static let APINEW = "residentApiNew/"
    
    static let VISITOR_APPROVED = "1"
    static let VISITOR_REJECTED = "4"
    static let VISITOR_ENTERED = "2"
    static let VISITOR_EXITED = "3"
    static let VISITOR_HOLD = "6"
    
    static let PRIMARY_ACCOUNT = "0"
    static let SUB_ACCOUNT = "1"
    
    static let KET_FESTIVAL_DATE = "1"
    static let RESIDENT = "resident"
    
    static let CHAT_WITH_RESIDENT = "0"
    static let CHAT_WITH_GATEKEEPER = "1"
    static let  CHAT_WITH_SERVICE_PROVIDER = "2"
    static let  USER_CHAT_DATA = "userDataSingleForChat"
    static let MSG_SENDED = "0"
    static let MSG_READED = "1"
    static let  GROUP_CHAT_STATUS = "group_chat_status"
    static let  CREATE_GROUP = "create_group"
    static let GATEKEEPER = "GateKeeper"
    
    static let SERVER_KEY = "AAAAwT-3mVg:APA91bE9L6dgsk6XdM4OePC1uCaH_NVY065u0LOG7NgxjydFlI55MBifYICC5yggG1eCgKPngVwHZLG_-P7q2cqliS2haNDcMIVwD1L4sLmxh251h-9S6SXdD5u163aoZQd5dINtIHv1"
    static let LANGUAGE_DATA = "languageData"
    static let LANGUAGE_ID = "languageId"
    static let COUNTRY_CODE = "countryCode"
    static let LANGUAGE_DATA_ADD_MORE = "languageDataAddmore"
    static let LANGUAGE_ID_ADD_MORE = "languageIdAddmore"
    static let GOOGLE_MAP_KEY = "AIzaSyDuyPFmbbw5hzRqV4ZI0mbbBO7IlJKiogY"
    static let HOMEPAGE_VIDEO = "homevideo"
    static let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    static let KEY_MENU_DATA = "menuData"
    
    static let KEY_MENU_CLICK_FOR  = "menuclickaction"
    static let KEY_MENU_CLICK_FOR_FCM  = "menuclickactionfcm"
    static let KEY_TURN_ON  = "Turn on your location setting"
    static let KEY_STEP_NEXT  = "1.Select Location > 2.Tap Always or While Using"
    static let KEY_MOBILE_PRIVATE  = "1"
    static let KEY_IS_OLD_SERVICE_UI  = true
    static let KEY_CLICK_ACTION  = "clickAction"
    static var CheckRenew = false
  
}
