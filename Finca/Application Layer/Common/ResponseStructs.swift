//
//  ResponseStructs.swift
//  Finca
//
//  Created by harsh panchal on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
import SwiftUI

struct SliderResponse: Codable {
    let status: String!
    let message: String!
    let slider: [Slider]!
    let notice : [ModelNoticeBoard]?
    let local_service_provider : [LocalServiceProviderListModel]?
    let member : [HomeMemberModel]?
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case slider = "slider"
        case notice
        case local_service_provider
        case member
    }
}
// MARK: - Slider
struct Slider: Codable {
    let sliderImageName: String!
    let sliderStatus: String!
    let pageMobile: String!
    let societyID: String!
    let aboutOffer: String!
    let pageURL: String!
    let youtubeURL: String!
    let appSliderID: String!
    let date_view : String!
    enum CodingKeys: String, CodingKey {
        case sliderImageName = "slider_image_name"
        case sliderStatus = "slider_status"
        case pageMobile = "page_mobile"
        case societyID = "society_id"
        case aboutOffer = "about_offer"
        case pageURL = "page_url"
        case youtubeURL = "youtube_url"
        case appSliderID = "app_slider_id"
        case date_view
    }
}
struct BillResponse: Codable {
    let bill: [Bill_Model]!
    let message: String!
    let status: String!
    let paid_bill: String!
    let remaining_bill: String!
    
    enum CodingKeys: String, CodingKey {
        case bill = "bill"
        case message = "message"
        case status = "status"
        case paid_bill = "paid_bill"
        case remaining_bill = "remaining_bill"
    }
}

// MARK: - Bill

struct Bill_Model: Codable {
    let amount_without_gst_view:String!
    let sgst_lbl_view:String!
    let cgst_lbl_view:String!
    let igst_lbl_view:String!
    let minimum_charge_view:String!
    let sub_amount_view:String!
    let fixed_charge_view:String!
    let bill_amount_view:String!
    let tax_slab:String!
    let taxble_type:String!
    let is_taxble:String!
    let gst: String!
    let gstSlab: String!
    let billCategoryId: String!
    let billName: String!
    let billAmount: String!
    let sgstAmount: String!
    let cgstAmount: String!
    let previousUnitRead: String!
    let currentUnitRead: String!
    let igstAmount: String!
    let billGenrateDate: String!
    let amountWithoutGst: String!
    let receiveBillStatus: String!
    let gstType: String!
    let billLateFees: String!
    let autoBillNumber: String!
    let unitPhoto: String!
    let receiveBillId: String!
    let billNo: String!
    let previousUnit: String!
    let receiveBillReceiptPhoto: String!
    let billDescription: String!
    let leteFeeApplyed: Bool!
    let balancesheetId: String!
    let billPaymentType: String!
    let noOfUnit: String!
    let billType: String!
    let billEndDate: String!
    let billMasterId: String!
    let billCategoryImage: String!
    let billCategoryName: String!
    let minimum_paid_request_amount: String!
    let billPaymentDate: String!
    let unitPrice: String!
    let unitReadingDate: String!
    let previousReadingDate: String!
    let userLateFee: String!
    let fixedCharge: String!
    let minimumChargeMessage: String!
    let adjustmentNote: String!
    let lastBill:[LastBill]!
    let discountPer: String!
    let discountAmount: String!
    let subAmount: String!
    let paybaleAmount: String!
    let paybale_amount_view:String!
    let invoiceUrl: String!
    let offerMessage : String!
    let already_request :Bool!
    let payment_request_id : String!
    let isPay : Bool!
    let minimumCharge : String!
    let minimum_pay_amount : String!
     enum CodingKeys: String, CodingKey {
        case amount_without_gst_view = "amount_without_gst_view"
        case sgst_lbl_view = "sgst_lbl_view"
        case cgst_lbl_view = "cgst_lbl_view"
        case igst_lbl_view = "igst_lbl_view"
        case paybale_amount_view = "paybale_amount_view"
        case minimum_charge_view = "minimum_charge_view"
        case sub_amount_view = "sub_amount_view"
        case fixed_charge_view = "fixed_charge_view"
        case bill_amount_view = "bill_amount_view"
        case tax_slab = "tax_slab"
        case taxble_type = "taxble_type"
        case is_taxble = "is_taxble"
        case minimum_paid_request_amount = "minimum_paid_request_amount"
        case gst = "gst"
        case minimum_pay_amount = "minimum_pay_amount"
        case payment_request_id = "payment_request_id"
        case already_request = "already_request"
        case gstSlab = "gst_slab"
        case billCategoryId = "bill_category_id"
        case billName = "bill_name"
        case billAmount = "bill_amount"
        case sgstAmount = "sgst_amount"
        case cgstAmount = "cgst_amount"
        case previousUnitRead = "previous_unit_read"
        case currentUnitRead = "current_unit_read"
        case igstAmount = "igst_amount"
        case billGenrateDate = "bill_genrate_date"
        case amountWithoutGst = "amount_without_gst"
        case receiveBillStatus = "receive_bill_status"
        case gstType = "gst_type"
        case billLateFees = "bill_late_fees"
        case autoBillNumber = "auto_bill_number"
        case unitPhoto = "unit_photo"
        case receiveBillId = "receive_bill_id"
        case billNo = "bill_no"
        case previousUnit = "previous_unit"
        case receiveBillReceiptPhoto = "receive_bill_receipt_photo"
        case billDescription = "bill_description"
        case leteFeeApplyed = "lete_fee_applyed"
        case balancesheetId = "balancesheet_id"
        case billPaymentType = "bill_payment_type"
        case noOfUnit = "no_of_unit"
        case billType = "bill_type"
        case billEndDate = "bill_end_date"
        case billMasterId = "bill_master_id"
        case billCategoryImage = "bill_category_image"
        case billCategoryName = "bill_category_name"
        case billPaymentDate = "bill_payment_date"
        case unitPrice = "unit_price"
        case previousReadingDate = "previousReadingDate"
        case unitReadingDate = "unit_reading_date"
        case userLateFee = "user_late_fee"
        case fixedCharge =  "fixed_charge"
        case minimumChargeMessage =  "minimum_charge_message"
        case adjustmentNote =  "adjustment_note"
        case lastBill =  "last_bill"
        case discountPer = "discount_per"
        case discountAmount = "discount_amount"
        case subAmount = "sub_amount"
        case paybaleAmount = "paybale_amount"
        case invoiceUrl = "invoice_url"
        case offerMessage = "offer_message"
        case isPay = "isPay"
        case minimumCharge = "minimum_charge"
    }
}

struct LastBill: Codable {
    let pay_status : String! //" : "Unpaid",
    let bill_master_id : String! //" : "14",
    let no_of_unit : String! //" : "25.00",
    let bill_amount : String! //" : "560.00",
    let auto_created_date : String! //" : "January-2020",
    let receive_bill_id : String! //" : "2752"
}
struct MaintainanceResponse: Codable {
    let message: String!
    let maintenance: [Maintenance_Model]!
    let status: String!
    let remaining_maintenance : String!
    let paid_maintenance : String!
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case maintenance = "maintenance"
        case status = "status"
        case remaining_maintenance = "remaining_maintenance"
        case paid_maintenance = "paid_maintenance"
    }
}
// MARK: - Maintenance
struct Maintenance_Model: Codable {
    let is_taxble:String!
    let taxble_type:String!
    let igst_amount_view:String!
    let sgst_amount_view:String!
    let cgst_amount_view:String!
    
    let sgstAmount: String!
    let maintenanceDescription: String!
    let gstType: String!
    let cgstAmount: String!
    let igstAmount: String!
    let lateFees: String!
    let billNo: String!
    let maintenanceName: String!
    let createdDate: String!
    let gstSlab: String!
    let endDate: String!
    let balancesheetID: String!
    let amountWithoutGst: String!
    let receiveMaintenanceID: String!
    let paymentType: String!
    let maintenceAmount: String!
    let receiveMaintenanceStatus: String!
    let gst: String!
    let billType: String!
    let receiveMaintenanceDate: String!
    let leteFeeApplyed: Bool!
    let offerMessage: String!
    let maintenaceVersion: String!
    let maintenceSubAmount: String!
    let partialAmount: String!
    let maintenanceId: String!
    let receiveMaintenanceStatusView: String!
    let isPay: Bool!
    enum CodingKeys: String, CodingKey {
        case cgst_amount_view = "cgst_amount_view"
        case sgst_amount_view = "sgst_amount_view"
        case igst_amount_view = "igst_amount_view"
        case taxble_type = "taxble_type"
        case is_taxble = "is_taxble"
        case sgstAmount = "sgst_amount"
        case maintenanceDescription = "maintenance_description"
        case gstType = "gst_type"
        case cgstAmount = "cgst_amount"
        case igstAmount = "igst_amount"
        case lateFees = "late_fees"
        case billNo = "bill_no"
        case maintenanceName = "maintenance_name"
        case createdDate = "created_date"
        case gstSlab = "gst_slab"
        case endDate = "end_date"
        case balancesheetID = "balancesheet_id"
        case amountWithoutGst = "amount_without_gst"
        case receiveMaintenanceID = "receive_maintenance_id"
        case paymentType = "payment_type"
        case maintenceAmount = "maintence_amount"
        case receiveMaintenanceStatus = "receive_maintenance_status"
        case gst = "gst"
        case billType = "bill_type"
        case receiveMaintenanceDate = "receive_maintenance_date"
        case leteFeeApplyed = "lete_fee_applyed"
        case offerMessage = "offer_message"
        case maintenaceVersion = "maintenace_version"
        case maintenceSubAmount = "maintence_sub_amount"
        case partialAmount = "partial_amount"
        case maintenanceId = "maintenance_id"
        case receiveMaintenanceStatusView = "receive_maintenance_status_view"
        case isPay = "isPay"
    }
}
struct VisitorResponse: Codable {
    let status: String!
    let visitor: [Visitor_Model]!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case visitor = "visitor"
        case message = "message"
    }
}
struct Visitor_Model: Codable {
    var leaveParcelAtGate: String!
    var visitLogo: String!
    var userId: String!
    var visitTime: String!
    var vistorNumber: String!
    var visitingReason: String!
    var visitorStatus: String!
    var temperature: String!
    var visitorType: String!
    var visitorMobile: String!
    var billModelVisitDate: String!
    var exitDate: String!
    var visitorProfile: String!
    var visitorApproved: String!
    var withMask: String!
    var visitFrom: String!
    var parentVisitorId: String!
    var visitorId: String!
    var exitTime: String!
    var billModelExitDate: String!
    var expectedType: String!
    var visitDate: String!
    var deliveryCabApproval: String!
    var societyId: String!
    var unitId: String!
    var visitorSubTypeId: String!
    var visitorName: String!
    enum CodingKeys: String, CodingKey {
        case leaveParcelAtGate = "leave_parcel_at_gate"
        case visitLogo = "visit_logo"
        case userId = "user_id"
        case visitTime = "visit_time"
        case vistorNumber = "vistor_number"
        case visitingReason = "visiting_reason"
        case visitorStatus = "visitor_status"
        case temperature = "temperature"
        case visitorType = "visitor_type"
        case visitorMobile = "visitor_mobile"
        case billModelVisitDate = "visit_date"
        case exitDate = "exitDate"
        case visitorProfile = "visitor_profile"
        case visitorApproved = "visitor_approved"
        case withMask = "with_mask"
        case visitFrom = "visit_from"
        case parentVisitorId = "parent_visitor_id"
        case visitorId = "visitor_id"
        case exitTime = "exit_time"
        case billModelExitDate = "exit_date"
        case expectedType = "expected_type"
        case visitDate = "visitDate"
        case deliveryCabApproval = "delivery_cab_approval"
        case societyId = "society_id"
        case unitId = "unit_id"
        case visitorSubTypeId = "visitor_sub_type_id"
        case visitorName = "visitor_name"
    }
}

struct ExpectedVisitorResponse: Codable {
    let status: String!
    let visitor: [Exp_Visitor_Model]!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case visitor = "visitor"
        case message = "message"
    }
}
struct addAlreadyPaidPayment: Codable {
    let status: String!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
}
struct CommonResponse: Codable {
    let status: String!
    let message: String!
    let otp_popup : Bool!
    let availableBalance: String!
    let is_voice_otp: Bool!
    let middle_name_action: String!
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case otp_popup = "otp_popup"
        case availableBalance = "availableBalance"
        case is_voice_otp
        case middle_name_action = "middle_name_action"
    }
}





struct ReferListResponse: Codable {
    
  
    
    let refer : [refer_list]!
    
    let message : String!
    let status: String!

enum CodingKeys: String, CodingKey {
    case status = "status"
    case message = "message"
    case refer = "refer_list"
}
    
}
// refer
struct refer_list : Codable {
    var refer_id : String!
    var added_date : String!
    var remarks : String!
    var refer_vendor_name : String!
    var refer_vendor_company : String!
    var refer_vendor_contact_number : String!
    var added_by : String!
    var refer_vendor_alernate_contact_number : String!
    var refer_status : String!
    var refer_vendor_email : String!
    var society_id : String!
    var business_category : String!

    enum CodingKeys: String, CodingKey {

        case refer_id = "refer_id"
        case added_date = "added_date"
        case remarks = "remarks"
        case refer_vendor_name = "refer_vendor_name"
        case refer_vendor_company = "refer_vendor_company"
        case refer_vendor_contact_number = "refer_vendor_contact_number"
        case added_by = "added_by"
        case refer_vendor_alernate_contact_number = "refer_vendor_alernate_contact_number"
        case refer_status = "refer_status"
        case refer_vendor_email = "refer_vendor_email"
        case society_id = "society_id"
        case business_category = "business_category"






    }
}
struct Exp_Visitor_Model: Codable {
    let leaveParcelAtGate : String!
    let visitTimeView: String!
    let visitDate: String!
    let visitorMobile: String! // visitor_mobile
    let visitorProfile: String!
    let visitTime: String!
    let onlyOtp: String!
    let visitorVisitDate: String!
    let visitorID: String!
    let vehicleNo: String!
    let exitDate: String!
    let expectedType: String!
    let visitorStatus: String!
    let visitLogo: String!
    let visitorExitDate: String!
    let vistorNumber: String!
    let otp: String!
    let unitID: String!
    let visitFrom: String!
    let userID: String!
    let validTillDate: String!
    let societyID: String!
    let visitingReason: String!
    let visitorName: String!
    let qrCode: String!
    let qrCodeIos: String!
    let visitorType: String!
    let visitDateView: String!
    let exitTime: String!
    let visitorSubTypeId : String!
    let noOfParcel : String!
    let temperature:String!
    let country_code:String?
    var withMask: String!
    enum CodingKeys: String, CodingKey {
        case country_code = "country_code"
        case noOfParcel = "no_of_parcel"
        case leaveParcelAtGate = "leave_parcel_at_gate"
        case visitorSubTypeId = "visitor_sub_type_id"
        case visitTimeView = "visit_time_view"
        case visitDate = "visitDate"
        case visitorMobile = "visitor_mobile" // visitor_mobile
        case visitorProfile = "visitor_profile"
        case visitTime = "visit_time"
        case onlyOtp = "only_otp"
        case visitorVisitDate = "visit_date"
        case visitorID = "visitor_id"
        case vehicleNo = "vehicle_no"
        case exitDate = "exitDate"
        case expectedType = "expected_type"
        case visitorStatus = "visitor_status"
        case visitLogo = "visit_logo"
        case visitorExitDate = "exit_date"
        case vistorNumber = "vistor_number"
        case otp = "otp"
        case unitID = "unit_id"
        case visitFrom = "visit_from"
        case userID = "user_id"
        case validTillDate = "valid_till_date"
        case societyID = "society_id"
        case visitingReason = "visiting_reason"
        case visitorName = "visitor_name"
        case qrCode = "qr_code"
        case qrCodeIos = "qr_code_ios"
        case visitorType = "visitor_type"
        case visitDateView = "visit_date_view"
        case exitTime = "exit_time"
        case temperature = "temperature"
        case withMask = "with_mask"
    }
}
// MARK: - Visitor
//struct Exp_Visitor_Model: Codable {
//    let visitorType: String!
//    let exitTime: String!
//    let visitorStatus: String!
//    let societyID: String!
//    let vistorNumber: String!
//    let visitorID: String!
//    let visitorProfile: String!
//    let userID: String!
//    let visitorName: String!
//    let unitID: String!
//    let visitingReason: String!
//    let otp : String!
//    let visitorMobile: String!
//    let visitTime: String!
//    let visitDate : String!
//    let exitDate : String!
//    let onlyOtp : String!
//    enum CodingKeys: String, CodingKey {
//        case visitorType = "visitor_type"
//        case exitTime = "exit_time"
//        case otp = "otp"
//        case visitorStatus = "visitor_status"
//        case societyID = "society_id"
//        case vistorNumber = "vistor_number"
//        case visitorID = "visitor_id"
//        case visitorProfile = "visitor_profile"
//        case userID = "user_id"
//        case visitorName = "visitor_name"
//        case unitID = "unit_id"
//        case visitingReason = "visiting_reason"
//        case visitorMobile = "visitor_mobile"
//        case visitTime = "visit_time"
//        case visitDate = "visitDate"
//        case exitDate = "exitDate"
//        case onlyOtp = "only_otp"
//    }
//}
struct GalleryResponse: Codable {
    var status: String!
    var event: [EventModel]!
    var message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case event = "event"
        case message = "message"
    }
}

// MARK: - Event
struct EventModel: Codable {
    var eventTitle: String!
    var  uploadDate: String! //" : "07 Mar 2020"
    var isOpen : Bool!
    var gallery: [GalleryModel]!
    
    enum CodingKeys: String, CodingKey {
        case eventTitle = "event_title"
        case gallery = "gallery"
        case uploadDate = "upload_date"
        case isOpen = "isOpen"
    }
}

// MARK: - Gallery
struct GalleryModel: Codable {
    var galleryID: String!
    var galleryPhoto: String!
    var galleryTitle: String!
    var uploadDateTime: String!
    var societyID: String!
    var eventID: String!
    
    enum CodingKeys: String, CodingKey {
        case galleryID = "gallery_id"
        case galleryPhoto = "gallery_photo"
        case galleryTitle = "gallery_title"
        case uploadDateTime = "upload_date_time"
        case societyID = "society_id"
        case eventID = "event_id"
    }
}
struct DocumentResponse: Codable {
    let list: [document_type_list]!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case list = "document_type_list"
        case status = "status"
    }
}

// MARK: - List
struct document_type_list: Codable {
    
    let documentTypeID: String!
    let documentTypeName:String!
    let documentIcon:String!
//    let shareWith: String!
//    let documentID: String!
//    let ducumentName: String!
//    let userId:String!
//    let ducumentDescription: String!
//    let uploadeDate: String!
//    let documentFile: String!
    enum CodingKeys: String, CodingKey {
        case documentTypeName = "document_type_name"
        case documentTypeID = "document_type_id"
        case documentIcon = "document_icon"
//        case userId = "user_id"
//        case shareWith = "share_with"
//        case documentID = "document_id"
//        case ducumentName = "ducument_name"
//        case ducumentDescription = "ducument_description"
//        case uploadeDate = "uploade_date"
//        case documentFile = "document_file"
    }
}
struct DocumentResponses: Codable {
    let list: [DocumentModel]!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
        case status = "status"
    }
}
struct DocumentModel: Codable {
    let shareWith: String!
    let documentTypeID: String!
    let documentID: String!
    let ducumentName: String!
    let userId:String!
    let ducumentDescription: String!
    let uploadeDate: String!
    let documentFile: String!
    let type:String!

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case documentTypeID = "document_type_id"
        case shareWith = "share_with"
        case documentID = "document_id"
        case ducumentName = "ducument_name"
        case ducumentDescription = "ducument_description"
        case uploadeDate = "uploade_date"
        case documentFile = "document_file"
        case type = "type"
    }
}
struct ElectionResponse: Codable {
    let election: [ElectionModel]!
    let status: String!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case election = "election"
        case status = "status"
        case message = "message"
    }
}

// MARK: - Election
struct ElectionModel: Codable {
    let electionDate: String!
    let electionName: String!
    let electionID: String!
    let electionStatus: String!
    let electionDescription: String!
    
    enum CodingKeys: String, CodingKey {
        case electionDate = "election_date"
        case electionName = "election_name"
        case electionID = "election_id"
        case electionStatus = "election_status"
        case electionDescription = "election_description"
    }
}
struct ElectionResultResponse: Codable {
    let totalVoting: String!
    let electionTie: Bool!
    let status: String!
    let message: String!
    let result: [ResultModel]!

    enum CodingKeys: String, CodingKey {
        case totalVoting = "totalVoting"
        case electionTie = "election_tie"
        case status = "status"
        case message = "message"
        case result = "result"
    }
}
struct ResultModel: Codable {
    let votingPer: String!
    let givenVote: String!
    let optionName: String!

    enum CodingKeys: String, CodingKey {
        case votingPer = "votingPer"
        case givenVote = "given_vote"
        case optionName = "option_name"
    }
}
// MARK: - RenewPlan
struct RenewPlanResponse : Codable {
  
    let message : String?
    let status : String?
    let package: [RenewModel]!
    let sanad_date : String!
    let membership_expire_date : String!
    let membership_joining_date : String!
    let expire_title_main : String!
    let expire_title_sub : String!
    let is_package_expire : Bool!
    let is_force_dailog : Bool!
    let building_name : String!
    let unit_name : String!
    let pacakage_name : String!
    let package_amount : String!
    let transaction_date : String!
    let invoice_link : String!
  
    enum CodingKeys: String, CodingKey {
       
        case pacakage_name = "pacakage_name"
        case package_amount = "package_amount"
        case transaction_date = "transaction_date"
        case invoice_link = "invoice_link"
        case sanad_date = "sanad_date"
        case membership_expire_date = "membership_expire_date"
        case membership_joining_date = "membership_joining_date"
        case expire_title_main = "expire_title_main"
        case expire_title_sub = "expire_title_sub"
        case is_package_expire = "is_package_expire"
        case is_force_dailog = "is_force_dailog"
        case building_name = "building_name"
        case unit_name = "unit_name"
        case package = "package"
        case message = "message"
        case status = "status"
    }
}

struct RenewModel : Codable {
    
    let package_desc : String?
    let balancesheet_id : String?
    let package_name : String?
    let package_amount : String?
    let package_id : String?
    let slab : [RenewSlabModel]?
    let no_of_years : String?
    let no_of_months : String?

    enum CodingKeys: String, CodingKey {

        case package_desc = "package_desc"
        case balancesheet_id = "balancesheet_id"
        case package_name = "package_name"
        case package_amount = "package_amount"
        case package_id = "package_id"
        case slab = "slab"
        case no_of_years = "no_of_years"
        case no_of_months = "no_of_months"
    }
}

struct RenewSlabModel : Codable {
    
    let year_price : String?
    let year : String?
    let slab_year : String?

        enum CodingKeys: String, CodingKey {
         
            case year_price = "year_price"
            case year = "year"
            case slab_year = "slab_year"
            
            
        }
}
// MARK: - VotingOptionResponse
struct VotingOptionResponse: Codable {
    let message: String!
    let votingSubmitted: String!
    let status: String!
    let option: [OptionModel]!
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case votingSubmitted = "voting_submitted"
        case status = "status"
        case option = "option"
    }
}

// MARK: - Option
struct OptionModel: Codable {
    let votingID: String!
    let optionName: String!
    let votingOptionID: String!
    let societyID: String!
    
    enum CodingKeys: String, CodingKey {
        case votingID = "voting_id"
        case optionName = "option_name"
        case votingOptionID = "voting_option_id"
        case societyID = "society_id"
    }
}
struct ComplainResponse: Codable {
    let message: String!
    let status: String!
    let complain: [ComplainModel]!
    let blockStatus : String! //" : "true",
    let blockMessage : String! //" : "fdfdf"
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case complain = "complain"
        case blockStatus = "block_status"
        case blockMessage = "block_message"
    }
}
// MARK: - Complain
struct ComplainModel: Codable {
    let complainDescription: String!
    let complainAssingTo: String!
    let complaintVoice: String!
    let complainReviewMsg: String!
    let complaintCategory : String!
    let complainID: String!
    let complainDate: String!
    let complaintcategoryview: String!
    let compalainTitle: String!
    let complainPhoto: String!
    let complainStatus: String!
    let societyID: String!
    let feedbackMsg:String!
    let complain_no:String!
    let ratingStar: String!
    enum CodingKeys: String, CodingKey {
        case complaintCategory = "complaint_category"
        case feedbackMsg = "feedback_msg"
        case complainDescription = "complain_description"
        case complainAssingTo = "complain_assing_to"
        case complaintVoice = "complaint_voice"
        case complainReviewMsg = "complain_review_msg"
        case complainID = "complain_id"
        case complainDate = "complain_date"
        case complaintcategoryview = "complaint_category_view"
        case compalainTitle = "compalain_title"
        case complainPhoto = "complain_photo"
        case complainStatus = "complain_status"
        case societyID = "society_id"
        case complain_no = "complain_no"
        case ratingStar = "rating_star"
        
    }
}
struct PollingResponse: Codable {
    let message: String!
    let voting: [PollingModel]!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case voting = "voting"
        case status = "status"
    }
}

// MARK: - Voting
struct PollingModel: Codable {
    let votingStatus: String!
    let votingQuestion: String!
    let votingStartDate: String!
    let votingEndDate: String!
    let societyID: String!
    let votingDescription: String!
    let votingID: String!
    
    enum CodingKeys: String, CodingKey {
        case votingStatus = "voting_status"
        case votingQuestion = "voting_question"
        case votingStartDate = "voting_start_date"
        case votingEndDate = "voting_end_date"
        case societyID = "society_id"
        case votingDescription = "voting_description"
        case votingID = "voting_id"
    }
}
struct PollingOptionResponse: Codable {
    let option: [PollingOptionModel]!
    let status: String!
    let votingSubmitted: String!
    let message: String!
    let totalVoting: String!
    let votingStatusView : String!
    let votingStatus : String!
    enum CodingKeys: String, CodingKey {
        case votingStatus = "voting_status"
        case votingStatusView = "voting_status_view"
        case option = "option"
        case status = "status"
        case votingSubmitted = "voting_submitted"
        case message = "message"
        case totalVoting = "totalVoting"
    }
}
struct PollingOptionModel: Codable {
    let votingOptionID: String!
    let societyID: String!
    let optionName: String!
    let votingPer: String!
    let votingID: String!
    
    enum CodingKeys: String, CodingKey {
        case votingOptionID = "voting_option_id"
        case societyID = "society_id"
        case optionName = "option_name"
        case votingPer = "votingPer"
        case votingID = "voting_id"
    }
}
struct PollingResultResponse: Codable {
    let status: String!
    let message: String!
    let votingSubmitted: String!
    let totalVoting: String!

    let result: [PollingResultModel]!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case votingSubmitted = "voting_submitted"
        case result = "result"
        case totalVoting = "totalVoting"
    }
}
struct PollingResultModel: Codable {
    let optionName: String!
    let givenVote: String!
    let votingPer: String!
    enum CodingKeys: String, CodingKey {
        case optionName = "option_name"
        case givenVote = "given_vote"
        case votingPer = "votingPer"
    }
}
struct BuildingDetailResponse: Codable {
    let secretaryEmail: String!
    let status: String!
    let societyAddress: String!
    let societyName: String!
    let builderName: String!
    let noOfStaff: Int!
    let socieatyLogo: String!
    let noOfUnits: Int!
    let builderAddress: String!
    let message: String!
    let noOfBlocks: Int!
    let builderMobile: String!
    let carAllocate: String!
    let secretaryMobile: String!
    let carCapcity: String!
    let trialDays: String!
    let commitie: [CommitteeModel]!
    let bikeAllocate: String!
    let noOfPopulation: String!
    let bikeCapcity: String!
    let societyBased: String!
    let society_cover: String!
    let association_website: String!
    let association_email: String!
    let association_phone_number: String!
    let cover_photo: String!
    
    enum CodingKeys: String, CodingKey {
        case society_cover = "society_cover"
        case secretaryEmail = "secretary_email"
        case status = "status"
        case societyAddress = "society_address"
        case societyName = "society_name"
        case builderName = "builder_name"
        case noOfStaff = "no_of_staff"
        case socieatyLogo = "socieaty_logo"
        case noOfUnits = "no_of_units"
        case builderAddress = "builder_address"
        case message = "message"
        case noOfBlocks = "no_of_blocks"
        case builderMobile = "builder_mobile"
        case carAllocate = "car_allocate"
        case secretaryMobile = "secretary_mobile"
        case carCapcity = "car_capcity"
        case trialDays = "trial_days"
        case commitie = "commitie"
        case bikeAllocate = "bike_allocate"
        case noOfPopulation = "no_of_population"
        case bikeCapcity = "bike_capcity"
        case societyBased = "society_based"
        case association_website = "association_website"
        case association_email = "association_email"
        case association_phone_number = "association_phone_number"
        case cover_photo = "cover_photo"
        
        
    }
}

// MARK: - Commitie
struct CommitteeModel: Codable {
    let adminAddress: String!
    let roleID: String!
    let adminID: String!
    let adminMobile: String!
    let adminEmail: String!
    let adminName: String!
    let societyID: String!
    let roleName: String!
    let adminProfile: String!
    let mobile_private :  String?
    enum CodingKeys: String, CodingKey {
        case adminAddress = "admin_address"
        case roleID = "role_id"
        case adminID = "admin_id"
        case adminMobile = "admin_mobile"
        case adminEmail = "admin_email"
        case adminName = "admin_name"
        case societyID = "society_id"
        case roleName = "role_name"
        case adminProfile = "admin_profile"
        case mobile_private
    }
}
// MARK: - EmergencyResponse
struct EmergencyResponse: Codable {
    let message: String!
    let status: String!
    let emergencyNumber: [EmergencyNumberModel]!
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case emergencyNumber = "emergencyNumber"
    }
}

// MARK: - EmergencyNumber
struct EmergencyNumberModel: Codable {
    let name: String!
    let designation: String!
    let mobile: String!
    let image: String!
    let emergencyContactId : String!
    let userId : String!
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case designation = "designation"
        case mobile = "mobile"
        case image = "image"
        case emergencyContactId = "emergencyContact_id"
        case userId = "user_id"
    }
}
struct BalanceSheetResponse: Codable {
    let status: String!
    let balancesheet: [BalancesheetModel]!
    let cashOnHand: String!
    let message: String!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case balancesheet = "balancesheet"
        case cashOnHand = "cash_on_hand"
        case message = "BalanceSheet Not Available...!"
    }
}

// MARK: - Balancesheet
struct BalancesheetModel: Codable {
    let balancesheet_file_id : String! //" : "135",
    let balancesheet_name : String! //" : "Year 2019 Final Balancesheet",
    let created_date : String! //" : "28 Aug 2019",
    let balancesheet_pdf : String! //" : alancesheet\/Year 2019 Final Balancesheet1566973128.pdf",
    let file_name : String! //" : "Year 2019 Final Balancesheet1566973128.pdf"
    let created_by : String!
}

// MARK: - Member
struct MemberDetailResponse: Codable {
    let cityName:String!
    let society_address:String!
    let unitName: String!
    let icardQrcode:String!
    let visitorApproved: String!
    let societyId: String!
    let userLastName: String!
    let userMobile: String!
    let unitStatus: String!
    let altMobile: String!
    let commonUserId: String!
    let commonPublicMobile: String!
    let other_remark: String!
    let commonLastName: String!
    let employmentStatus: String!
    let businessCategories: String!
    let employmentDescription: String!
    let tenantView: String!
    let companyContactNumber: String!
    let floorName: String!
    let userID: String!
    let ownerName: String!
    let companyAddress: String!
    let userIdProof: String!
    let userStatus: String!
    let instagram: String!
    let userType: String!
    let userPhone: String!
    let blockId: String!
    let dobView: String!
    let public_mobile_action: String!
    let middle_name_action: String!
    let mobileForGatekeeper : String!
    let ownerMobile: String!
    let blockName: String!
    let commonUserProfile: String!
    let userEmail: String!
    let userProfilePic: String!
    let commonMobile: String!
    let userFirstName: String!
    let user_middle_name: String!
    let sosAlert: String!
    let member: [MemberDetailModal]!
    let companyName  : String!
    let publicMobile: String!
    let designation: String!
    let dob: String!
    let floorId: String!
    let linkedin: String!
    let employmentType: String!
    let commonFirstName: String!
    let facebook: String!
    let userFullName: String!
    let commonFullName: String!
    let emergency: [MemberEmergencyModal]!
    let employmentId: String!
    let unitId: String!
    let businessCategoriesSub: String!
    let myParking: [MyParkingModal]!
    let status: String!
    let memberDateOfBirth: String!
    let memberDateOfBirthSet : String!
    let message: String!
    let gender : String!
    let childGateApproval : String!
    let groupVisitorApproval : String!
    let tenantAgreementStartDate : String!
    let tenantAgreementEndDate : String!
    let tenantAgreementStartDateView : String!
    let tenantAgreementEndDateView : String!
    let tenantDoc : String!
    let prvDoc : String!
    let userMobileView : String!
    let altMobileView : String!
    let unitCloseForGatekeeper : String!
    let isSociety : Bool!
     let memberStatus : String!
    let blood_group : String!
    let company_logo:String!
    let label_member_type:String!
    let society_name:String!
    let countryCodeAlt : String!
    let countryCode : String!
    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case society_address = "society_address"
        case icardQrcode = "icard_qr_code"
        case society_name = "society_name"
        case middle_name_action = "middle_name_action"
        case memberDateOfBirthSet = "member_date_of_birth_set"
        case altMobileView = "alt_mobile_view"
        case public_mobile_action = "public_mobile_action"
        case userMobileView = "user_mobile_view"
        case groupVisitorApproval = "group_visitor_approval"
        case childGateApproval = "child_gate_approval"
        case gender = "gender"
        case mobileForGatekeeper = "mobile_for_gatekeeper"
        case unitName = "unit_name"
        case visitorApproved = "visitor_approved"
        case societyId = "society_id"
        case userLastName = "user_last_name"
        case user_middle_name = "user_middle_name"
        case userMobile = "user_mobile"
        case unitStatus = "unit_status"
        case altMobile = "alt_mobile"
        case commonUserId = "common_user_id"
        case commonPublicMobile = "common_public_mobile"
        case other_remark = "other_remark"
        case commonLastName = "common_last_name"
        case employmentStatus = "employment_status"
        case businessCategories = "business_categories"
        case employmentDescription = "employment_description"
        case tenantView = "tenant_view"
        case companyContactNumber = "company_contact_number"
        case floorName = "floor_name"
        case userID = "user_id"
        case ownerName = "owner_name"
        case companyAddress = "company_address"
        case userIdProof = "user_id_proof"
        case userStatus = "user_status"
        case instagram = "instagram"
        case userType = "user_type"
        case userPhone = "user_phone"
        case blockId = "block_id"
        case dobView = "dob_view"
        case ownerMobile = "owner_mobile"
        case blockName = "block_name"
        case commonUserProfile = "common_user_profile"
        case userEmail = "user_email"
        case userProfilePic = "user_profile_pic"
        case commonMobile = "common_mobile"
        case userFirstName = "user_first_name"
        case sosAlert = "sos_alert"
        case member = "member"
        case companyName = "company_name"
        case publicMobile = "public_mobile"
        case designation = "designation"
        case dob = "dob"
        case floorId = "floor_id"
        case linkedin = "linkedin"
        case employmentType = "employment_type"
        case commonFirstName = "common_first_name"
        case facebook = "facebook"
        case userFullName = "user_full_name"
        case commonFullName = "common_full_name"
        case emergency = "emergency"
        case employmentId = "employment_id"
        case unitId = "unit_id"
        case businessCategoriesSub = "business_categories_sub"
        case myParking = "myParking"
        case status = "status"
        case memberDateOfBirth = "member_date_of_birth"
        case message = "message"
        case tenantAgreementStartDate = "tenant_agreement_start_date"
        case tenantAgreementEndDate = "tenant_agreement_end_date"
        case tenantAgreementStartDateView = "tenant_agreement_start_date_view"
        case tenantAgreementEndDateView = "tenant_agreement_end_date_view"
        case prvDoc = "prv_doc"
        case tenantDoc = "tenant_doc"
        case unitCloseForGatekeeper = "unit_close_for_gatekeeper"
        case isSociety = "is_society"
        case memberStatus = "member_status"
        case blood_group = "blood_group"
        case company_logo =  "company_logo"
        case label_member_type = "label_member_type"
        case countryCodeAlt = "country_code_alt"
        case countryCode = "country_code"
    }
}
struct MemberEmergencyModal: Codable {
    let emergencyContactId: String!
    let personName: String!
    let personMobile: String!
    let relationId: String!
    let relation: String!
    
    enum CodingKeys: String, CodingKey {
        case emergencyContactId = "emergencyContact_id"
        case personName = "person_name"
        case personMobile = "person_mobile"
        case relationId = "relation_id"
        case relation = "relation"
    }
}
// MARK: - Member model
struct MemberDetailModal: Codable {
    let company_logo:String!
    let icard_qr_code:String!
    let designation :String!
    let company_address:String!
    let company_name:String!
    let publicMobile: String!
    let userFirstName: String!
    let user_middle_name: String!
    let tenantView: String!
    let userMobile: String!
    let userID: String!
    let you_can_appove:String!
    let society_name: String!
    let memberDateOfBirth: String!
    let sosAlert: String!
    let memberRelationName: String!
    let userProfilePic: String!
    let memberStatus: String!
    let memberChat: String!
    let userLastName: String!
    let userStatus: String!
    let user_status_msg : String!
    let memberAge: String!
    let memberRelationSet: String!
    let memberRelationView : String!
    let gender : String!
    let countryCode : String!
    let countryCodeAlt : String!
    enum CodingKeys: String, CodingKey {
        case you_can_appove = "you_can_appove"
        case user_status_msg = "user_status_msg"
        case society_name = "society_name"
        case company_logo = "company_logo"
        case icard_qr_code = "icard_qr_code"
        case user_middle_name = "user_middle_name"
        case designation = "designation"
        case company_address = "company_address"
        case company_name = "company_name"
        case memberRelationView = "member_relation_view"
        case memberRelationSet = "member_relation_set"
        case publicMobile = "public_mobile"
        case userFirstName = "user_first_name"
        case tenantView = "tenant_view"
        case userMobile = "user_mobile"
        case userID = "user_id"
        case memberDateOfBirth = "member_date_of_birth"
        case sosAlert = "sos_alert"
        case memberRelationName = "member_relation_name"
        case userProfilePic = "user_profile_pic"
        case memberStatus = "member_status"
        case userLastName = "user_last_name"
        case userStatus = "user_status"
        case memberAge = "member_age"
        case memberChat = "member_chat"
        case gender = "gender"
        case countryCode = "country_code"
        case countryCodeAlt = "country_code_alt"
    }
}

// MARK: - MyParking
struct MyParkingModal: Codable {
    let unitID: String!
    let vehicleNo: String!
    let parkingType: String!
    let societyParkingID: String!
    let blockID: String!
    let parkingName: String!
    let parkingStatus: String!
    let floorID: String!
    let parkingID: String!
    
    enum CodingKeys: String, CodingKey {
        case unitID = "unit_id"
        case vehicleNo = "vehicle_no"
        case parkingType = "parking_type"
        case societyParkingID = "society_parking_id"
        case blockID = "block_id"
        case parkingName = "parking_name"
        case parkingStatus = "parking_status"
        case floorID = "floor_id"
        case parkingID = "parking_id"
    }
}
struct FeedResponse: Codable {
    let feed: [FeedModel]!
    let message: String!
    let status: String!
    let totalFeed: String!
    let pos1 : Int!
    let totalSocietyFeedLimit : String!
    let unreadNotification : Int!
    enum CodingKeys: String, CodingKey {
        case feed = "feed"
        case message = "message"
        case status = "status"
        case totalFeed = "totalFeed"
        case pos1 = "pos1"
        case totalSocietyFeedLimit = "totalSocietyFeedLimit"
        case unreadNotification = "unread_notification"
    }
}

// MARK: - Feed
struct FeedModel: Codable {
    let feedId: String!
    let societyId: String!
    let feedMsg: String!
    let userName: String!
    let video_thumb: String!
    let blockName: String!
    let userId: String!
    let userProfilePic: String!
    let feedImg: [FeedImgModel]!
    let feedType: String!
    let feed_video: String!
    let modifyDate: String!
    var totalLikes : String!
    var like: [LikeModel]!
    var likeStatus: String!
    var is_saved: String!
    var comment: [CommentModel]!
    var commentStatus: String!
    var isReadMore : Bool!
    var isShowReadMore : Bool!
    var minHeight : CGFloat!
    var maxHeight : CGFloat!
    var user_mobile: String?
    var imageHeight : CGFloat?
    var total_comments : String!
    var card_colour : String!
    var text_colour : String!
    var upload_by_type : String!
    var admin_post : String!

    
    
    enum CodingKeys: String, CodingKey {
        case feed_video = "feed_video"
        case video_thumb = "video_thumb"
        case feedId = "feed_id"
        case societyId = "society_id"
        case feedMsg = "feed_msg"
        case userName = "user_name"
        case blockName = "block_name"
        case userId = "user_id"
        case userProfilePic = "user_profile_pic"
        case feedImg = "feed_img"
        case feedType = "feed_type"
        case modifyDate = "modify_date"
        case like = "like"
        case likeStatus = "like_status"
        case is_saved = "is_saved"
        case comment = "comment"
        case commentStatus = "comment_status"
        case totalLikes = "totalLikes"
        case isReadMore = "isReadMore"
        case isShowReadMore = "isShowReadMore"
        case minHeight = "minHeight"
        case maxHeight = "maxHeight"
        case total_comments = "total_comments"
        case user_mobile
        case imageHeight
        case card_colour
        case text_colour
        case upload_by_type
        case admin_post
    }
}
// MARK: - Comment
struct CommentModel: Codable {
    let commentsId: String!
    let feedId: String!
    let msg: String!
    let userName: String!
    let blockName: String!
    let userId: String!
    let modifyDate: String!
    let userProfilePic : String!
    var sub_comment: [CommentModel]!
    enum CodingKeys: String, CodingKey {
        case commentsId = "comments_id"
        case feedId = "feed_id"
        case msg = "msg"
        case userName = "user_name"
        case blockName = "block_name"
        case userId = "user_id"
        case modifyDate = "modify_date"
        case userProfilePic = "user_profile_pic"
        case sub_comment = "sub_comment"
    }
}
// MARK: - FeedImg
struct FeedImgModel: Codable {
    let feedImg: String!
    let feedWidth : String! //" : "1251",
    let feedHeight : String! //" : "600",
    enum CodingKeys: String, CodingKey {
        case feedImg = "feed_img"
        case feedWidth = "feed_width"
        case feedHeight = "feed_height"
    }
}
// MARK: - Like
struct LikeModel: Codable {
    let likeId: String!
    let feedId: String!
    let userId: String!
    let userName: String!
    let blockName: String!
    let modifyDate: String!
    let userProfilePic : String!
    
    enum CodingKeys: String, CodingKey {
        case likeId = "like_id"
        case feedId = "feed_id"
        case userId = "user_id"
        case userName = "user_name"
        case blockName = "block_name"
        case modifyDate = "modify_date"
        case userProfilePic = "user_profile_pic"
    }
}
struct CommentResponse: Codable {
    let comment: [CommentModel]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case comment = "comment"
        case message = "message"
        case status = "status"
    }
}
// location api response
struct ResponseLocation: Codable {
    let subDomain: String!
    let userPassword: String!
    let status: String!
    let message: String!
    let demoStatus: String!
    let apiKey: String!
    let userMobile: String!
    let societyName : String!
    let societyLogo : String!
    let countries: [CountryModel]!
    enum CodingKeys: String, CodingKey {
        case subDomain = "sub_domain"
        case userPassword = "user_password"
        case status = "status"
        case message = "message"
        case demoStatus = "demo_status"
        case apiKey = "api_key"
        case userMobile = "user_mobile"
        case countries = "countries"
        case societyName = "society_name"
        case societyLogo = "society_logo"
    }
}
// MARK: - Country
struct CountryModel: Codable {
    let iso3: String!
    let iso2: String!
    let phonecode: String!
    let capital: String!
    let currency: String!
    let countryID: String!
    let name: String!
    let country_code: String!
    
    enum CodingKeys: String, CodingKey {
        case iso3 = "iso3"
        case iso2 = "iso2"
        case phonecode = "phonecode"
        case capital = "capital"
        case currency = "currency"
        case countryID = "country_id"
        case name = "name"
        case country_code = "country_code"
    }
}
struct StateResponse: Codable {
    let status: String!
    let message: String!
    let states: [StateModel]!
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case states = "states"
    }
}
// MARK: - State
struct StateModel: Codable {
    let name: String!
    let stateID: String!
    let countryID: String!
    let nameSearch : String!
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case stateID = "state_id"
        case countryID = "country_id"
        case  nameSearch = "name_search"
    }
}
// MARK: - CityResponse
struct CityResponse: Codable {
    let message: String!
    let cities: [CityModel]!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case cities = "cities"
        case status = "status"
    }
}
// MARK: - City
struct CityModel: Codable {
    let name: String!
    let countryID: String!
    let stateID: String!
    let cityID: String!
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case countryID = "country_id"
        case stateID = "state_id"
        case cityID = "city_id"
    }
}
struct LocalServiceProviderResponse: Codable {
    let localServiceProvider: [LocalServiceProviderModel]!
    let message: String!
    let status: String!
    
    enum CodingKeys: String, CodingKey {
        case localServiceProvider = "local_service_provider"
        case message = "message"
        case status = "status"
    }
}
// MARK: - LocalServiceProvider
struct LocalServiceProviderModel: Codable {
    let localServiceProviderID: String!
    let serviceProviderCategoryName: String!
    let serviceProviderCategoryImage: String!
    let service_provider_category_name_search: String!
    let localServiceSubProvider: [LocalServiceSubProviderModel]!
    enum CodingKeys: String, CodingKey {
        case localServiceProviderID = "local_service_provider_id"
        case serviceProviderCategoryName = "service_provider_category_name"
        case serviceProviderCategoryImage = "service_provider_category_image"
        case localServiceSubProvider = "local_service_sub_provider"
        case service_provider_category_name_search = "service_provider_category_name_search"
    }
}
struct LocalServiceSubProviderModel: Codable {
    let serviceProviderSubCategoryName: String!
    let localServiceProviderSubId: String!
    let serviceProviderSubCategoryImage: String!

    enum CodingKeys: String, CodingKey {
        case serviceProviderSubCategoryName = "service_provider_sub_category_name"
        case localServiceProviderSubId = "local_service_provider_sub_id"
        case serviceProviderSubCategoryImage = "service_provider_sub_category_image"
    }
}
struct LocalServiceProviderListResponse: Codable {
    let localServiceProvider: [LocalServiceProviderListModel]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case localServiceProvider = "local_service_provider"
        case message = "message"
        case status = "status"
    }
}
// MARK: - LocalServiceProvider
struct LocalServiceProviderListModel: Codable {
    var work_description:String!
    var sp_webiste:String!
    var isCheck: Bool!
    let serviceProviderUsersID: String!
    let serviceProviderName: String!
    let serviceProviderAddress: String!
    let serviceProviderLatitude: String!
    let serviceProviderLogitude: String!
    let serviceProviderPhone: String!
    let serviceProviderEmail: String!
    let isKyc: String!
    let openStatus: String!
    let timing: String!
    let serviceProviderUserImage: String!
    let totalRatings: String!
    let averageRating: String!
    let userPreviousRating: String!
    let userPreviousComment: String!
    let distance: String!
    let token: String!
    let service_provider_phone_view:String!
    let brochure_profile : String!
    let distance_in_km : String!
    let service_provider_category_name : String!
    
    enum CodingKeys: String, CodingKey {
        case work_description = "work_description"
        case sp_webiste = "sp_webiste"
        case service_provider_phone_view = "service_provider_phone_view"
        case isCheck = "isCheck"
        case serviceProviderUsersID = "service_provider_users_id"
        case serviceProviderName = "service_provider_name"
        case serviceProviderAddress = "service_provider_address"
        case serviceProviderLatitude = "service_provider_latitude"
        case serviceProviderLogitude = "service_provider_logitude"
        case serviceProviderPhone = "service_provider_phone"
        case serviceProviderEmail = "service_provider_email"
        case isKyc = "is_kyc"
        case openStatus = "openStatus"
        case timing = "timing"
        case serviceProviderUserImage = "service_provider_user_image"
        case totalRatings = "totalRatings"
        case averageRating = "averageRating"
        case userPreviousRating = "userPreviousRating"
        case userPreviousComment = "userPreviousComment"
        case distance = "distance"
        case token = "token"
        case brochure_profile
        case distance_in_km
        case  service_provider_category_name
    }
}
struct FincasysTeamResponse: Codable {
    let availbleTime: String!
    let fincasysAlternateNo: String!
    let fincasysMobile: String!
    let message: String!
    let fincasysTeam: [FincasysTeamModel]!
    let fincasysWebsite: String!
    let fincasysEmail: String!
    let status: String!
    enum CodingKeys: String, CodingKey {
        case availbleTime = "availble_time"
        case fincasysAlternateNo = "fincasys_alternate_no"
        case fincasysMobile = "fincasys_mobile"
        case message = "message"
        case fincasysTeam = "fincasys_team"
        case fincasysWebsite = "fincasys_website"
        case fincasysEmail = "fincasys_email"
        case status = "status"
    }
}
// MARK: - FincasysTeam
struct FincasysTeamModel: Codable {
    let teamDesignation: String!
    let fincasysTeamID: String!
    let teamPhoto: String!
    let teamName: String!
    
    enum CodingKeys: String, CodingKey {
        case teamDesignation = "team_designation"
        case fincasysTeamID = "fincasys_team_id"
        case teamPhoto = "team_photo"
        case teamName = "team_name"
    }
}
// MARK: - SingleSponsorResponse
struct MerchantDetailResponse: Codable {
    let merchantID: String!
    let merchantKey: String!
    let status: String!
    let message: String!
    let saltKey: String!
    let isTestMode: Bool!
    
    enum CodingKeys: String, CodingKey {
        case merchantID = "merchant_id"
        case merchantKey = "merchant_key"
        case status = "status"
        case message = "message"
        case saltKey = "salt_key"
        case isTestMode = "is_test_mode"
    }
}
// MARK: - PatientDatewiseListResponse
struct ComplainCategoryResponse: Codable {
    let status: String!
    let complainCategory: [ComplainCategory]!
    let audioDuration: Int!
    let message: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case complainCategory = "complain_category"
        case audioDuration = "audio_duration"
        case message = "message"
    }
}
// MARK: - ComplainCategory
struct ComplainCategory: Codable {
    let categoryName: String!
    let complaintCategoryID: String!

    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case complaintCategoryID = "complaint_category_id"
    }
}
// MARK: - PatientDatewiseListResponse
struct EmployeeTimeSlotResponse: Codable {
    let message: String!
    let days: [Day]!
    let status: String!
    var is_your_employee: Bool!
    let workingUnits : [String]!
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case days = "days"
        case status = "status"
        case is_your_employee = "is_your_employee"
        case workingUnits = "working_units"
        }
    }
// MARK: - Day
struct Day: Codable {
    var timeslot: [Timeslot]!
    let day: String!

    enum CodingKeys: String, CodingKey {
        case timeslot = "timeslot"
        case day = "day"
    }
}
// MARK: - Timeslot
struct Timeslot: Codable {
    let unitName: String!
    let scheduleInTime: String!
    let empID: String!
    let scheduleID: String!
    let unitID: String!
    let timeSlot: String!
    let timeSlotId: String!
    var availbleStatus: Bool!
    var isCheck  : Bool!
    var already_booked_slot : Bool!
    enum CodingKeys: String, CodingKey {
        case already_booked_slot = "already_booked_slot"
        case unitName = "unit_name"
        case scheduleInTime = "schedule_in_time"
        case empID = "emp_id"
        case scheduleID = "schedule_id"
        case unitID = "unit_id"
        case timeSlot = "time_slot"
        case availbleStatus = "availble_status"
        case timeSlotId = "time_slot_id"
        case isCheck = "isCheck"
    }
}
// MARK: - LostFoundResponse
struct LostFoundResponse: Codable {
    let message: String!
    let lostfound: [Lostfound]!
    let status: String!
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case lostfound = "lostfound"
        case status = "status"
    }
}
// MARK: - Lostfound
struct Lostfound: Codable {
    let lostFoundImage: String!
    let lostFoundDescription: String!
    let societyID: String!
    let userFullName: String!
    let lostFoundDate: String!
    let lostFoundMasterID: String!
    let lostFoundTitle: String!
    let userProfilePic: String!
    let userID: String!
    let blockName: String!
    let userMobile: String!
    let lostFoundType: String!
    let unitID: String!
    let publicMobile : String!
    let tenantView : String!
    let isUser : Bool!
    enum CodingKeys: String, CodingKey {
        case tenantView = "tenant_view"
        case lostFoundImage = "lost_found_image"
        case lostFoundDescription = "lost_found_description"
        case societyID = "society_id"
        case userFullName = "user_full_name"
        case lostFoundDate = "lost_found_date"
        case lostFoundMasterID = "lost_found_master_id"
        case lostFoundTitle = "lost_found_title"
        case userProfilePic = "user_profile_pic"
        case userID = "user_id"
        case blockName = "block_name"
        case userMobile = "user_mobile"
        case lostFoundType = "lost_found_type"
        case unitID = "unit_id"
        case publicMobile = "public_mobile"
        case isUser = "is_user"
    }
}
// MARK: - MemberParkingResponse
struct MemberParkingResponse: Codable {
    let units: [UnitParkingModel]!
    let message: String!
    let status: String!
    let population: String!
    enum CodingKeys: String, CodingKey {
        case units = "units"
        case message = "message"
        case status = "status"
        case population = "population"
    }
}
// MARK: - Unit
struct UnitParkingModel: Codable {
    let userEmail: String!
    let userMobile: String!
    let unitName: String!
    let unitStatus: String!
    let userFullName: String!
    let userUnitID: String!
    let userBlockID: String!
    let userStatus: String!
    let userFloorID: String!
    let floorID: String!
    let blockName: String!
    let userID: String!
    let societyID: String!
    let unitID: String!
    let myParking: [MemberParkingModel]!
    let userType: String!
    let publicMobile: String!
    let parkingName: String!
    let parkingID: String!
    let societyParkingID: String!
    let vehicleNo: String!
    let parkingType: String!
    let parkingStatus: String!
    let parkingnameview : String!
    let usertypeview : String!
    let socity_parking : String!
    enum CodingKeys: String, CodingKey {
        case socity_parking = "socity_parking"
        case userEmail = "user_email"
        case userMobile = "user_mobile"
        case unitName = "unit_name"
        case unitStatus = "unit_status"
        case userFullName = "user_full_name"
        case userUnitID = "user_unit_id"
        case userBlockID = "user_block_id"
        case userStatus = "user_status"
        case userFloorID = "user_floor_id"
        case floorID = "floor_id"
        case blockName = "block_name"
        case userID = "user_id"
        case societyID = "society_id"
        case unitID = "unit_id"
        case myParking = "myParking"
        case userType = "user_type"
        case publicMobile = "public_mobile"
        
        case parkingName = "parking_name"
        case parkingID = "parking_id"
        case societyParkingID = "society_parking_id"
        case vehicleNo = "vehicle_no"
        case parkingType = "parking_type"
        case parkingStatus = "parking_status"
        case parkingnameview = "parking_name_view"
        case usertypeview = "user_type_view"
    }
}
// MARK: - MyParking
struct MemberParkingModel: Codable {
    let parkingName: String!
    let parkingID: String!
    let societyParkingID: String!
    let blockID: String!
    let floorID: String!
    let vehicleNo: String!
    let unitID: String!
    let parkingType: String!
    let parkingStatus: String!
    enum CodingKeys: String, CodingKey {
        case parkingName = "parking_name"
        case parkingID = "parking_id"
        case societyParkingID = "society_parking_id"
        case blockID = "block_id"
        case floorID = "floor_id"
        case vehicleNo = "vehicle_no"
        case unitID = "unit_id"
        case parkingType = "parking_type"
        case parkingStatus = "parking_status"
    }
}
// MARK: - Welcome
struct PropertyListResponse: Codable {
    let message: String!
    let property: [PropertyModel]!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case property = "property"
        case status = "status"
    }
}
// MARK: - Property
struct PropertyModel: Codable {
    let otherCharges: String!
    let propertyAddressLat: String!
    let propertyCategory: String!
    let seats: String!
    let balcony: String!
    let expectedPrice: String!
    let userId: String!
    let societyId: String!
    let bathroom: String!
    let cityId: String!
    let stateId: String!
    let propertyAddressLog: String!
    let countryId: String!
    let modifyDate: String!
    let noOfFloors: String!
    let furnishing: String!
    let cabins: String!
    let contactNo: String!
    let propertyType: String!
    let propertyHolderName: String!
    let propertyStatus: String!
    let unitId: String!
    let maintence: String!
    let societyName: String!
    let bedroom: String!
    let propertyAreaSuper: String!
    let pujaGhar: String!
    let kitchen: String!
    let propertyAddress: String!
    let propertyPhoto: [PropertyPhotoModel]!
    let propertyFor: String!
    let carParking: String!
    let propertyAreaCarpet: String!
    let rentSaleId: String!
    let availFrom : String!
    let deposit : String!
    let expectedPriceEdit : Int!
    let otherChargesEdit : Int!
    enum CodingKeys: String, CodingKey {
        case deposit = "deposit"
        case availFrom = "avail_from"
        case otherCharges = "other_charges"
        case propertyAddressLat = "property_address_lat"
        case propertyCategory = "property_category"
        case seats = "seats"
        case balcony = "balcony"
        case expectedPrice = "expected_price"
        case userId = "user_id"
        case societyId = "society_id"
        case bathroom = "bathroom"
        case cityId = "city_id"
        case stateId = "state_id"
        case propertyAddressLog = "property_address_log"
        case countryId = "country_id"
        case modifyDate = "modify_date"
        case noOfFloors = "no_of_floors"
        case furnishing = "furnishing"
        case cabins = "cabins"
        case contactNo = "contact_no"
        case propertyType = "property_type"
        case propertyHolderName = "property_holder_name"
        case propertyStatus = "property_status"
        case unitId = "unit_id"
        case maintence = "maintence"
        case societyName = "society_name"
        case bedroom = "bedroom"
        case propertyAreaSuper = "property_area_super"
        case pujaGhar = "puja_ghar"
        case kitchen = "kitchen"
        case propertyAddress = "property_address"
        case propertyPhoto = "property_photo"
        case propertyFor = "property_for"
        case carParking = "car_parking"
        case propertyAreaCarpet = "property_area_carpet"
        case rentSaleId = "rent_sale_id"
        case expectedPriceEdit = "expected_price_edit"
        case otherChargesEdit = "other_charges_edit"
        
    }
}
// MARK: - PropertyPhoto
struct PropertyPhotoModel: Codable {
    let propertyPhoto: String!

    enum CodingKeys: String, CodingKey {
        case propertyPhoto = "property_photo"
    }
}
// MARK: - EmployeeTypeList
struct EmployeeTypeListResponse: Codable {
    let employeeType: [EmployeeTypeModel]!
    let status: String!
    let message: String!

    enum CodingKeys: String, CodingKey {
        case employeeType = "employee_Type"
        case status = "status"
        case message = "message"
    }
}
// MARK: - EmployeeType
struct EmployeeTypeModel: Codable {
    let societyId: String!
    let empTypeId: String!
    let empTypeName: String!
    let empTypeStatus: String!
    let empTypeIcon: String!

    enum CodingKeys: String, CodingKey {
        case societyId = "society_id"
        case empTypeId = "emp_type_id"
        case empTypeName = "emp_type_name"
        case empTypeStatus = "emp_type_status"
        case empTypeIcon = "emp_type_icon"
    }
}
// MARK: - Login
struct LoginResponse: Codable {
    let userID: String!
    var societyID: String!
    var userFullName: String!
    var userFirstName: String!
    var userLastName: String!
    var userMobile: String!
    var userEmail: String!
    let userIDProof: String!
    let userType: String!
    var blockID: String!
    let blockName: String!
    let floorName: String!
    let unitName: String!
    var baseURL: String!
    var floorID: String!
    let unitID: String!
    let unitStatus: String!
    let userStatus: String!
    let memberStatus: String!
    let publicMobile: String!
    let memberDateOfBirth: String!
    let memberDateOfBirthSet:String!
    let facebook: String!
    let instagram: String!
    let linkedin: String!
    let altMobile: String!
    let userProfilePic: String!
    let ownerName: String!
    let ownerEmail: String!
    let ownerMobile: String!
    let societyAddress: String!
    let societyLatitude: String!
    let societyLongitude: String!
    let member: [Member]!
    let emergency: [Emergency]!
    let message: String!
    let status: String!
    let society_name: String!
    let sosAlert: String!
    let visitorApproved: String!
    let tenantView: String!
    let cityName : String!
    let apiKey : String!
    let currency : String!
    let gender : String!
    let isSociety : Bool!
    let labelSettingResident : String!
    let labelSettingApartment : String!
    let accountDeactive : Bool!
    let countryId : String!
    let stateId : String!
    let cityId : String!
    let countryCodeAlt : String!
    let countryCode : String!
    let company_name : String!
    let get_business_data : Bool!
    let designation : String!
    let profile_progress : String!
    let employment_description : String!
    let company_address : String!
    let company_contact_number : String!
    let business_categories_sub : String!
    let professional_other : String!
    let plot_lattitude : String!
    let plot_longitude : String!
    let search_keyword : String!
    let company_website : String!
    let logoutIosDevice : Bool!
    let sanad_date : String?
    let advocate_code : String?
    let middle_name_action : String?
    let user_middle_name: String?
    
    // let added_by: String!

    enum CodingKeys: String, CodingKey {
        case labelSettingApartment = "label_setting_apartment"
        case labelSettingResident = "label_setting_resident"
        case isSociety = "is_society"
        case gender = "gender"
        case currency = "currency"
        case userID = "user_id"
        case societyID = "society_id"
        case userFullName = "user_full_name"
        case userFirstName = "user_first_name"
        case userLastName = "user_last_name"
        case userMobile = "user_mobile"
        case userEmail = "user_email"
        case userIDProof = "user_id_proof"
        case userType = "user_type"
        case blockID = "block_id"
        case blockName = "block_name"
        case floorName = "floor_name"
        case unitName = "unit_name"
        case baseURL = "base_url"
        case floorID = "floor_id"
        case unitID = "unit_id"
        case unitStatus = "unit_status"
        case userStatus = "user_status"
        case memberStatus = "member_status"
        case publicMobile = "public_mobile"
        case memberDateOfBirth = "member_date_of_birth"
        case memberDateOfBirthSet = "member_date_of_birth_set"
        case facebook = "facebook"
        case instagram = "instagram"
        case linkedin = "linkedin"
        case altMobile = "alt_mobile"
        case userProfilePic = "user_profile_pic"
        case ownerName = "owner_name"
        case ownerEmail = "owner_email"
        case ownerMobile = "owner_mobile"
        case societyAddress = "society_address"
        case societyLatitude = "society_latitude"
        case societyLongitude = "society_longitude"
        case member = "member"
        case emergency = "emergency"
        case message = "message"
        case status = "status"
        case society_name = "society_name"
        case sosAlert = "sos_alert"
        case visitorApproved = "visitor_approved"
        case tenantView = "tenant_view"
        case cityName = "city_name"
        case apiKey = "api_key"
        case accountDeactive = "account_deactive"
        case countryId = "country_id"
        case stateId = "state_id"
        case cityId = "city_id"
        case countryCodeAlt = "country_code_alt"
        case countryCode = "country_code"
        case company_name
        case get_business_data
        case designation
        case profile_progress
        case employment_description
        case company_address
        case company_contact_number
        case business_categories_sub
        case professional_other
        case plot_lattitude
        case plot_longitude
        case search_keyword
        case company_website
        case logoutIosDevice
        case sanad_date
        case advocate_code
        case middle_name_action
        case user_middle_name
        // case added_by = "added_by"
    }
}


// MARK: - Member

struct Member: Codable {
    let userID: String!
    let userFirstName: String!
    let userLastName: String!
    let userMobile: String!
    let memberDateOfBirth: String!
    let memberAge: String!
    let memberRelationName: String!
    let userStatus: String!
    let memberStatus: String!
    let userProfilePic : String!
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userFirstName = "user_first_name"
        case userLastName = "user_last_name"
        case userMobile = "user_mobile"
        case memberDateOfBirth = "member_date_of_birth"
        case memberAge = "member_age"
        case memberRelationName = "member_relation_name"
        case userStatus = "user_status"
        case memberStatus = "member_status"
        case userProfilePic = "user_profile_pic"
    }
}
struct Emergency : Codable {
    let relation:String! //"relation" : "Dad",
    let emergencyContact_id:String! //"emergencyContact_id" : "14",
    let person_name:String! //"person_name" : "Ankit Rana",
    let relation_id:String!  //"relation_id" : null,
    let person_mobile:String!  //"person_mobile" : "989898688"
}
struct GetReminderResponse: Codable {
    var message: String!
    var status: String!
    var reminder: [GetReminderListModel]!
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
    }
}
struct GetReminderListModel: Codable {
    var reminder_date_view: String! //" : "01 Jan 1970 05:30 AM",
    var reminder_text: String! //" : "add",
    var society_id: String! //" : "75",
    var reminder_date: String! //" : "1970-01-01 05:30:00",
    var reminder_me: Bool! //" : true,
    var reminder_id: String! //" : "17",
    let user_id: String! //" : "90"

    enum CodingKeys : String, CodingKey {
        case society_id = "society_id"
        case user_id = "user_id"
        case reminder_date_view = "reminder_date_view"
        case reminder_text = "reminder_text"
        case reminder_date = "reminder_date"
        case reminder_me = "reminder_me"
        case reminder_id = "reminder_id"
    }
}


// MARK :

struct MultiUnitResponse: Codable {
    
    let status: String!
    let message: String!
    let units: [LoginResponse]!
    let reminder:[GetReminderListModel]!
    let hideChat: Bool!
    let hideMyActivity: Bool!
    let hideTimeline: Bool!
    let tenant_agreement_over : Bool?
    let countryCodeAlt : String!
    let countryCode : String!
    let countryid : String!
    let is_package_expire : Bool!
    let expire_title_sub : String!
    let association_type : String!
    let expire_title_main : String!
    let package : [PackageModel]!
    let is_force_dailog : Bool!
    
    let VPNCheck: Bool?
    let vehicle_photo_required:String?
    let rc_book_photo_required:String?
    let membership_expire_date: String?
    let membership_joining_date: String?
    let building_name: String?
    let state_id: String?
    let unit_name: String?
    let city_id: String?
    let sanad_date: String?
    let membership_joining_date_without_format: String?
    let show_service_provider_timeline_seprate:String?

    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case units = "units"
        case reminder = "reminder"
        case hideChat = "hide_chat"
        case hideMyActivity = "hide_myactivity"
        case hideTimeline = "hide_timeline"
        case tenant_agreement_over = "tenant_agreement_over"
        case countryCodeAlt = "country_code_alt"
        case countryCode = "country_code"
        case countryid = "country_id"
        case is_package_expire
        case expire_title_sub
        case association_type
        case expire_title_main
        case package
        case is_force_dailog
        
        case VPNCheck
        case rc_book_photo_required = "rc_book_photo_required"
        case vehicle_photo_required = "vehicle_photo_required"
        case membership_expire_date
        case membership_joining_date
        case building_name
        case state_id
        case unit_name
        case city_id
        case sanad_date
        case membership_joining_date_without_format
        case show_service_provider_timeline_seprate
    }
}


// MARK : OccupationResponse :

struct OccupationResponse: Codable {
    
    let status: String!
    let message: String!
    let occupation: [OccupationModel]!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case occupation = "occupation"
    }
}

// MARK :  Occupation :

struct OccupationModel: Codable {
    
    let employmentType: String!
    let blockName: String!
    let businessCategoriesSub: String!
    let unitName: String!
    let userPhone: String!
    let userProfilePic: String!
    let userId: String!
    let employmentDescription: String!
    let companyContactNumber: String!
    let designation: String!
    let userFullName: String!
    let floorName: String!
    let userEmail: String!
    let companyAddress: String!
    let businessCategories: String!
    let companyName: String!
    let searchKeyword: String!
    
    enum CodingKeys: String, CodingKey {
        case employmentType = "employment_type"
        case blockName = "block_name"
        case businessCategoriesSub = "business_categories_sub"
        case unitName = "unit_name"
        case userPhone = "user_phone"
        case userProfilePic = "user_profile_pic"
        case userId = "user_id"
        case employmentDescription = "employment_description"
        case companyContactNumber = "company_contact_number"
        case designation = "designation"
        case userFullName = "user_full_name"
        case floorName = "floor_name"
        case userEmail = "user_email"
        case companyAddress = "company_address"
        case businessCategories = "business_categories"
        case companyName = "company_name"
        case searchKeyword = "search_keyword"
    }
}

// MARK : ProfessionCategory

struct ProfessionCategoryResponse: Codable {
    let message: String!
    let status: String!
    let category: [ProfessionCategory]!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case category = "category"
    }
}

// MARK :  Category

struct ProfessionCategory: Codable {
    
    let categoryId: String!
    let subCategory: [ProfessionType]!
    let categoryIndustry: String!

    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case subCategory = "sub_category"
        case categoryIndustry = "category_industry"
    }
}

// MARK :  SubCategory :

struct ProfessionType: Codable {
    let categoryName: String!

    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
    }
}

// MARK :  PenaltyListResponse: 

//struct PenaltyListResponse: Codable {
//    var penalty: [PenaltyModel]!
//    var message: String!
//    var status: String!
//
//    enum CodingKeys: String, CodingKey {
//        case penalty = "penalty"
//        case message = "message"
//        case status = "status"
//    }
//}
//
//// MARK: - Penalty
//struct PenaltyModel: Codable {
//    var penaltyId: String!
//    var societyId: String!
//    var balancesheetId: String!
//    var unitId: String!
//    var userId: String!
//    var penaltyName: String!
//    var penaltyDate: String!
//    var penaltyAmount: String!
//    var penaltyPhoto: String!
//    var paidStatus: String!
//
//    enum CodingKeys: String, CodingKey {
//        case penaltyId = "penalty_id"
//        case societyId = "society_id"
//        case balancesheetId = "balancesheet_id"
//        case unitId = "unit_id"
//        case userId = "user_id"
//        case penaltyName = "penalty_name"
//        case penaltyDate = "penalty_date"
//        case penaltyAmount = "penalty_amount"
//        case penaltyPhoto = "penalty_photo"
//        case paidStatus = "paid_status"
//    }
//}
// MARK: - PenaltyListResponse
struct PenaltyListResponse: Codable {
    let message: String!
    let penalty: [PenaltyModel]!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case penalty = "penalty"
        case status = "status"
    }
}

// MARK: - Penalty
struct PenaltyModel: Codable {
    var igst_lbl_view:String!
    var cgst_lbl_view:String!
    var sgst_lbl_view:String!
    var tax_slab:String!
    let igst_amount_view:String!
    let cgst_amount_view:String!
    let sgst_amount_view:String!
    let is_taxble: String!
    let taxble_type:String!
    let payment_request_id:String!
    let penaltyDate: String!
    let gst: String!
    let balancesheetID: String!
    let paidStatus: String!
    let cgstAmount: String!
    let billType: String!
    let penaltyAmount: String!
    let penalty_amount_view: String!
    let unitID: String!
    let penaltyPhoto: String!
    let gstType: String!
    let igstAmount: String!
    let userID: String!
    let penaltyID: String!
    let amountWithoutGst: String!
    let sgstAmount: String!
    let billNo: String!
    let societyID: String!
    let gstSlab: String!
    let penaltyName: String!
    let invoiceUrl : String!
    let isPay : Bool!
    let already_request : Bool!
    let penalty_img: [PenaltyImageModel]!
    enum CodingKeys: String, CodingKey {
        
        case sgst_lbl_view = "sgst_lbl_view"
        case cgst_lbl_view = "cgst_lbl_view"
        case igst_lbl_view = "igst_lbl_view"
        case tax_slab = "tax_slab"
        case igst_amount_view = "igst_amount_view"
        case cgst_amount_view = "cgst_amount_view"
        case sgst_amount_view = "sgst_amount_view"
        case is_taxble = "is_taxble"
        case taxble_type = "taxble_type"
        case penalty_amount_view = "penalty_amount_view"
        case already_request = "already_request"
        case payment_request_id = "payment_request_id"
        case penalty_img = "penalty_img"
        case penaltyDate = "penalty_date"
        case gst = "gst"
        case balancesheetID = "balancesheet_id"
        case paidStatus = "paid_status"
        case cgstAmount = "cgst_amount"
        case billType = "bill_type"
        case penaltyAmount = "penalty_amount"
        case unitID = "unit_id"
        case penaltyPhoto = "penalty_photo"
        case gstType = "gst_type"
        case igstAmount = "igst_amount"
        case userID = "user_id"
        case penaltyID = "penalty_id"
        case amountWithoutGst = "amount_without_gst"
        case sgstAmount = "sgst_amount"
        case billNo = "bill_no"
        case societyID = "society_id"
        case gstSlab = "gst_slab"
        case penaltyName = "penalty_name"
        case invoiceUrl = "invoice_url"
        case isPay = "isPay"
    }
}
struct PenaltyImageModel: Codable {
    
    let penalty_photo: String!
    
    enum CodingKeys: String, CodingKey {
        case penalty_photo = "penalty_photo"
        
    }
    
}
struct SocietyArray : Codable {
    var SocietyDetails : [LoginResponse]!
}

// MARK: - MemberListReponse
struct MemberListResponse: Codable {
    var member: [MemberListModel]!
    var message: String!
    var status: String!

    enum CodingKeys: String, CodingKey {
        case member = "member"
        case message = "message"
        case status = "status"
    }
}
// MARK: - Member
struct MemberListModel: Codable {
    let altMobile: String!
    let unitName: String!
    var userID: String!
    var chatCount: String!
    let unitStatus: String!
    let floorID: String!
    let userLastName: String!
    let unitID: String!
    let userFullName: String!
    var memberSize: String!
    let userMobile: String!
    let userType: String!
    let blockName: String!
    let floorName: String!
    let memberStatus: String!
    var userFirstName: String!
    var chatID: String!
    let flag: String!
    let userStatus: String!
    var userProfilePic: String!
    let publicMobile: String!
    let memberDateOfBirth: String!
    var indexPath:IndexPath!
    let joinStatus: Bool!
    let blockStatus:Bool!
    let msg_data: String!
    let msg_date: String!
    var customDate : Date!
    let gender: String!
    var selectMember: Bool!
    var token: String!
    var user_designation : String!
    var company_name : String!
    var title : String!
    var sub_title : String!
    var sub_title_icon: String!
    var search_keyword : String!
    
    enum CodingKeys: String, CodingKey {
        case altMobile = "alt_mobile"
        case unitName = "unit_name"
        case userID = "user_id"
        case chatCount = "chatCount"
        case unitStatus = "unit_status"
        case floorID = "floor_id"
        case userLastName = "user_last_name"
        case unitID = "unit_id"
        case userFullName = "user_full_name"
        case memberSize = "member_size"
        case userMobile = "user_mobile"
        case userType = "user_type"
        case blockName = "block_name"
        case floorName = "floor_name"
        case memberStatus = "member_status"
        case userFirstName = "user_first_name"
        case chatID = "chat_id"
        case flag = "flag"
        case userStatus = "user_status"
        case userProfilePic = "user_profile_pic"
        case publicMobile = "public_mobile"
        case memberDateOfBirth = "member_date_of_birth"
        case joinStatus = "join_status"
        case blockStatus = "block_status"
        case msg_data = "msg_data"
        case msg_date = "msg_date"
        case  customDate = "testDate"
        case  gender = "gender"
        case  selectMember = "selectMember"
        case  token
        case  user_designation
        case company_name
        case title = "title"
        case sub_title = "sub_title"
        case sub_title_icon = "sub_title_icon"
        case search_keyword = "search_keyword"
    }
}
// MARK: - RemoveImageReponse
struct RemoveImageReponse: Codable {
    let userProfilePic: String!
    let status: String!
    let message: String!

    enum CodingKeys: String, CodingKey {
        case userProfilePic = "user_profile_pic"
        case status = "status"
        case message = "message"
    }
}
struct VisitorTypeResponse: Codable {
    let message: String!
    let status: String!
    let visitorMainType: [VisitorMainType]!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case visitorMainType = "visitor_main_type"
    }
}
// MARK: - VisitorMainType
struct VisitorMainType: Codable {
    let mainTypeImage: String!
    let visitorMainFullImg: String!
    let visitorType: String!
    let visitorMainTypeID: String!
    let mainTypeName: String!
    let visitorSubType: [VisitorSubType]!

    enum CodingKeys: String, CodingKey {
        case mainTypeImage = "main_type_image"
        case visitorMainFullImg = "visitor_main_full_img"
        case visitorType = "visitor_type"
        case visitorMainTypeID = "visitor_main_type_id"
        case mainTypeName = "main_type_name"
        case visitorSubType = "visitor_sub_type"
    }
}
// MARK: - VisitorSubType
struct VisitorSubType: Codable {
    let visitorSubImage: String!
    let visitorSubTypeName: String!
    let visitorSubTypeID: String!

    enum CodingKeys: String, CodingKey {
        case visitorSubImage = "visitor_sub_image"
        case visitorSubTypeName = "visitor_sub_type_name"
        case visitorSubTypeID = "visitor_sub_type_id"
    }
}
struct ParkingStatus : Codable {
    var sBlocks: [ParkingData]!
    var status: String!
    var message: String!

    enum CodingKeys: String, CodingKey {
        case sBlocks = "sBlocks"
        case status = "status"
        case message = "message"
    }
}
// MARK: - SBlock
struct ParkingData : Codable {
    var totalBikeParking: String!
    var notAllocateBikes: String!
    var notAllocateCars: String!
    var socieatyParkingName: String!
    var totalCarParking: String!
    var societyParkingID: String!
    var allocateBikes: String!
    var allocateCars: String!
    var societyParkingStatus: String!
    enum CodingKeys: String, CodingKey {
        case totalBikeParking = "total_bike_parking"
        case notAllocateBikes = "not_allocate_bikes"
        case notAllocateCars = "not_allocate_cars"
        case socieatyParkingName = "socieaty_parking_name"
        case totalCarParking = "total_car_parking"
        case societyParkingID = "society_parking_id"
        case allocateBikes = "allocate_bikes"
        case allocateCars = "allocate_cars"
        case societyParkingStatus = "society_parking_status"
    }
}
struct Parking: Codable {
    var status: String!
    var cars: [CarParking]!
    var message: String!
    var bikes: [BikeParking]!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case cars = "cars"
        case message = "message"
        case bikes = "bikes"
    }
}
// MARK: - Bike
struct BikeParking : Codable {
    var parkingStatus: String!
    var parkingID: String!
    var vehicleNo: String!
    var unitID: String!
    var parkingName: String!

    enum CodingKeys: String, CodingKey {
        case parkingStatus = "parking_status"
        case parkingID = "parking_id"
        case vehicleNo = "vehicle_no"
        case unitID = "unit_id"
        case parkingName = "parking_name"
    }
}
struct CarParking : Codable {
    var parkingStatus: String!
    var parkingID: String!
    var vehicleNo: String!
    var unitID: String!
    var parkingName: String!

    enum CodingKeys: String, CodingKey {
        case parkingStatus = "parking_status"
        case parkingID = "parking_id"
        case vehicleNo = "vehicle_no"
        case unitID = "unit_id"
        case parkingName = "parking_name"
    }
}

struct classifiedResponse: Codable {
    let classifiedCategory: [ClassifiedCategory]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case classifiedCategory = "classified_category"
        case message = "message"
        case status = "status"
    }
}

// MARK: - ClassifiedCategory
struct ClassifiedCategory: Codable {
    let classifiedCategoryID: String!
    let classifiedCategoryName: String!
    let classifiedCategoryImage: String!

    enum CodingKeys: String, CodingKey {
        case classifiedCategoryID = "classified_category_id"
        case classifiedCategoryName = "classified_category_name"
        case classifiedCategoryImage = "classified_category_image"
    }
}

struct SubClassifiedResponse: Codable {
    let classifiedSubCategory: [ClassifiedSubCategory]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case classifiedSubCategory = "classified_sub_category"
        case message = "message"
        case status = "status"
    }
}

// MARK: - ClassifiedSubCategory
struct ClassifiedSubCategory: Codable {
    var classifiedCategoryID: String!
    let classifiedSubCategoryID: String!
    let classifiedSubCategoryName: String!
    let classifiedSubCategoryImage: String!

    enum CodingKeys: String, CodingKey {
        case classifiedCategoryID = "classified_category_id"
        case classifiedSubCategoryID = "classified_sub_category_id"
        case classifiedSubCategoryName = "classified_sub_category_name"
        case classifiedSubCategoryImage = "classified_sub_category_image"
    }
}
struct UserClassifiedResponse: Codable {
    let listedItems: [ListedItem]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case listedItems = "listed_items"
        case message = "message"
        case status = "status"
    }
}

// MARK: - ListedItem
struct ListedItem: Codable {
    let classifiedMasterID: String!
    let userID: String!
    let userName: String!
    let userMobile: String!
    let classifiedAddTitle: String!
    let classifiedDescribeSelling: String!
    let classifiedspecification: String!
    let classifiedBrandName: String!
    let classifiedManufacturingYear: String!
    let classifiedFeatures: String!
    let classifiedExpectedPrice: String!
    let itemAddedDate: String!
    let imageURL: String!
    let images: [String]!
    var classifiedcategoryid: String!
    let classifiedsubcategoryid: String!
    let location : String!
    let product_type : String!
    let classified_category_name : String!
    let user_profile_pic : String!
    let public_mobile : String!
    enum CodingKeys: String, CodingKey {
        case classifiedMasterID = "classified_master_id"
        case userID = "user_id"
        case userName = "user_name"
        case userMobile = "user_mobile"
        case classifiedAddTitle = "classified_add_title"
        case classifiedDescribeSelling = "classified_describe_selling"
        case classifiedspecification = "classified_specification"
        case classifiedBrandName = "classified_brand_name"
        case classifiedManufacturingYear = "classified_manufacturing_year"
        case classifiedFeatures = "classified_features"
        case classifiedExpectedPrice = "classified_expected_price"
        case itemAddedDate = "item_added_date"
        case imageURL = "image_url"
        case images = "images"
        case classifiedcategoryid = "classified_category_id"
        case classifiedsubcategoryid = "classified_sub_category_id"
        case location
        case product_type
        case classified_category_name
        case user_profile_pic
        case public_mobile
    }
}
// MARK: - DailyVisitorResponse
struct DailyVisitorResponse: Codable {
    let message: String!
    let status: String!
    let visitor: [Visitor]!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case visitor = "visitor"
    }
}
// MARK: - Visitor
struct Visitor: Codable {
    var country_code: String!
    var weekDays: String!
    var visitorMobile: String!
    var unitId: String!
    var visitorProfile: String!
    var visitFrom: String!
    var visitorSubTypeId: String!
    var withMask: String!
    var visitingReason: String!
    var visitorName: String!
    var vehicleNumber: String!
    var inTime: String!
    var outTime: String!
    var visitLogo: String!
    var exitDate: String!
    var visitDate: String!
    var visitorId: String!
    var visitorType: String!
    var validTill: String!
    var temperature: String!
    var societyId: String!
    var userId: String!
    var visitorStatusView: String!
    var visitorStatus: String!
    var vistorNumber: String!
    var vehicleNo: String!
    var activeStatus: String!
    enum CodingKeys: String, CodingKey {
        case country_code = "country_code"
        case weekDays = "week_days"
        case visitorMobile = "visitor_mobile"
        case unitId = "unit_id"
        case visitorProfile = "visitor_profile"
        case visitFrom = "visit_from"
        case visitorSubTypeId = "visitor_sub_type_id"
        case withMask = "with_mask"
        case visitingReason = "visiting_reason"
        case visitorName = "visitor_name"
        case vehicleNumber = "vehicle_number"
        case inTime = "in_time"
        case outTime = "out_time"
        case visitLogo = "visit_logo"
        case exitDate = "exitDate"
        case visitDate = "visitDate"
        case visitorId = "visitor_id"
        case visitorType = "visitor_type"
        case validTill = "valid_till"
        case temperature = "temperature"
        case societyId = "society_id"
        case userId = "user_id"
        case visitorStatusView = "visitor_status_view"
        case visitorStatus = "visitor_status"
        case vistorNumber = "vistor_number"
        case vehicleNo = "vehicle_no"
        case activeStatus = "active_status"
    }
}
//parcel reponse
//struct parcelResponse: Codable {
//    let parcel: [Parcel]!
//    let message: String!
//    let status: String!
//
//    enum CodingKeys: String, CodingKey {
//        case parcel = "parcel"
//        case message = "message"
//        case status = "status"
//    }
//}

// MARK: - Parcel
//struct Parcel: Codable {
//    let parcelCollectMasterID: String!
//    let societyID: String!
//    let parcelPhoto: String!
//    let parcelID: String!
//    let unitID: String!
//    let userID: String!
//    let collectedBy: String!
//    let gatekeeperMobile: String!
//    let appovalBy: String!
//    let remark: String!
//    let visitorSubTypeID: String!
//    var parcelStatus: String!
//    let deliveryBoyName: String!
//    let deliveryBoyNumber: String!
//    let deliveryCompany: String!
//    let noOfParcel: String!
//    let passCode: String!
//    let deliveryCompanylogo: String!
//    let parcelCollectedDate: String!
//    let parcelDeliverdDate: String!
//    let qrCode: String!
//    let qrCodeIos: String!
//
//    enum CodingKeys: String, CodingKey {
//        case parcelCollectMasterID = "parcel_collect_master_id"
//        case societyID = "society_id"
//        case parcelPhoto = "parcel_photo"
//        case parcelID = "parcel_id"
//        case unitID = "unit_id"
//        case userID = "user_id"
//        case collectedBy = "collected_by"
//        case gatekeeperMobile = "gatekeeper_mobile"
//        case appovalBy = "appoval_by"
//        case remark = "remark"
//        case visitorSubTypeID = "visitor_sub_type_id"
//        case parcelStatus = "parcel_status"
//        case deliveryBoyName = "delivery_boy_name"
//        case deliveryBoyNumber = "delivery_boy_number"
//        case deliveryCompany = "delivery_company"
//        case noOfParcel = "no_of_parcel"
//        case passCode = "pass_code"
//        case deliveryCompanylogo = "delivery_companylogo"
//        case parcelCollectedDate = "parcel_collected_date"
//        case parcelDeliverdDate = "parcel_deliverd_date"
//        case qrCode = "qr_code"
//        case qrCodeIos = "qr_code_ios"
//    }
//}

// MARK: - EventsResponse
struct parcelResponse: Codable {
    let message: String!
    let parcel: [Parcel]!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case parcel = "parcel"
        case status = "status"
    }
}
// MARK: - Parcel
struct Parcel: Codable {
    let deliverd_by_gatekeeper: String!
    let deliverd_by_gatekeeper_mobile: String!
    
   let collectedBy: String!
    let deliveryCompanylogo: String!
    let userId: String!
    let exitTime: String!
    let visitorStatus: String!
    let visitorSubTypeId: String!
    let qrCode: String!
    let visitorMobile: String!
    let parcelId: String!
    let qrCodeIos: String!
    let deliveryBoyName: String!
    let visitorId: String!
    let visitorName: String!
    let visitorProfile: String!
    let deliveryCompany: String!
    let vistorNumber: String!
    let visitLogo: String!
    let deliveryBoyNumber: String!
    let expectedType: String!
    let passCode: String!

    let visitorType: String!
    let exitDate: String!
    let visitingReason: String!
    let noOfParcel: String!
    let parcelCollectedDate: String!
    let visitTime: String!
    let societyId: String!
    let parcelCollectMasterId: String!
    let visitFrom: String!
    let parcelDeliverdDate: String!
    let visitTimeView: String!
    let vehicleNo: String!
    let parcelStatus: String!
    let gatekeeperMobile: String!
    let unitId: String!
    let leaveParcelAtGate: String!
    let remark: String!
    let visitDate: String!
    let validTillDate: String!
    let appovalBy: String!
    let parcelPhoto: String!
    let passCodeNew : String!
    enum CodingKeys: String, CodingKey {
        case deliverd_by_gatekeeper = "deliverd_by_gatekeeper"
        case deliverd_by_gatekeeper_mobile = "deliverd_by_gatekeeper_mobile"
        case passCodeNew = "pass_code_new"
        case collectedBy = "collected_by"
        case deliveryCompanylogo = "delivery_companylogo"
        case userId = "user_id"
        case exitTime = "exit_time"
        case visitorStatus = "visitor_status"
        case visitorSubTypeId = "visitor_sub_type_id"
        case qrCode = "qr_code"
        case visitorMobile = "visitor_mobile"
        case parcelId = "parcel_id"
        case qrCodeIos = "qr_code_ios"
        case deliveryBoyName = "delivery_boy_name"
        case visitorId = "visitor_id"
        case visitorName = "visitor_name"
        case visitorProfile = "visitor_profile"
        case deliveryCompany = "delivery_company"
        case vistorNumber = "vistor_number"
        case visitLogo = "visit_logo"
        case deliveryBoyNumber = "delivery_boy_number"
        case expectedType = "expected_type"
        case passCode = "pass_code"
        case visitorType = "visitor_type"
        case exitDate = "exit_date"
        case visitingReason = "visiting_reason"
        case noOfParcel = "no_of_parcel"
        case parcelCollectedDate = "parcel_collected_date"
        case visitTime = "visit_time"
        case societyId = "society_id"
        case parcelCollectMasterId = "parcel_collect_master_id"
        case visitFrom = "visit_from"
        case parcelDeliverdDate = "parcel_deliverd_date"
        case visitTimeView = "visit_time_view"
        case vehicleNo = "vehicle_no"
        case parcelStatus = "parcel_status"
        case gatekeeperMobile = "gatekeeper_mobile"
        case unitId = "unit_id"
        case leaveParcelAtGate = "leave_parcel_at_gate"
        case remark = "remark"
        case visitDate = "visit_date"
        case validTillDate = "valid_till_date"
        case appovalBy = "appoval_by"
        case parcelPhoto = "parcel_photo"
    }
}

// MARK: - EventResponse
struct EventResponse: Codable {
    let event: [Event]!
    let eventCompleted: [Event]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case event = "event"
        case eventCompleted = "event_completed"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Event
struct Event: Codable {
    let eventId: String!
    let eventTitle: String!
    let eventImage: String!
    let eventStartDate: String!
    let eventStartDateView: String!
    let eventEndDate: String!
    let eventEndVeiwOnly: String!
    let eventDayOnly: String!
    let eventTimeOnly: String!
    let eventMonthYearOnly: String!
    let noOfDays: String!
    let eventType: String!

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case eventTitle = "event_title"
        case eventImage = "event_image"
        case eventStartDate = "event_start_date"
        case eventStartDateView = "event_start_date_view"
        case eventEndDate = "event_end_date"
        case eventEndVeiwOnly = "event_end_veiw_only"
        case eventDayOnly = "event_day_only"
        case eventTimeOnly = "event_time_only"
        case eventMonthYearOnly = "event_month_year_only"
        case noOfDays = "no_of_days"
        case eventType = "event_type"
    }
}




struct vehicleResponse: Codable {
    let list: [list]!
    
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case list = "list"
    
        case message = "message"
        case status = "status"
    }
}

// MARK: - vehicle
struct list: Codable {
    let societyid: String! //"1",
    let usermobile: String! //"972****088",
    let blockid: String! //"32",
    let user_fullname : String!// "Mariya Pillai",
    let vehicletype : String! //"0",
    let companyname : String!// "", String!
    let vehicle_id: String! //"12",
    let userid: String! //"312",
    let vehicleqrcode: String!// "https:\/\/chart.googleapis.com\/chart?cht=qr&chs=300x300&chl=GJ-01-2545&choe=UTF-8&chld=H.png",
    let publicmobile: String! //"1",
    let vehiclephoto: String! //"https:\/\/dev.myassociation.app\/img\/documents\/Vehicle_1649239939.jpg",
    let rcbook: String!
    let floorid: String! //"156",
    let vehiclenumber: String! //."GJ-01-2545",
    let old_vehiclephoto: String! //"Vehicle_1649239939.jpg",
    let old_rcbook: String!
    let unitid: String! //"640let
    let logo:String!
    let generate_number:String!
    let qrcode_id:String!
    let vehicle_status:String!
    
    

    enum CodingKeys: String, CodingKey {
        case societyid = "society_id" //"1",
        case logo = "logo"
        case usermobile = "user_mobile" //"972****088",
        case blockid = "block_id" //"32",
        case user_fullname  = "user_full_name"// "Mariya Pillai",
        case vehicletype  = "vehicle_type" //"0",
        case companyname  = "company_name"// "", String!
        case vehicle_id = "vehicle_id" //"12",
        case userid = "user_id" //"312",
        case vehicleqrcode = "vehicle_qr_code"// "https:\/\/chart.googleapis.com\/chart?cht=qr&chs=300x300&chl=GJ-01-2545&choe=UTF-8&chld=H.png",
        case publicmobile = "public_mobile" //"1",
        case vehiclephoto = "vehicle_photo" //"https:\/\/dev.myassociation.app\/img\/documents\/Vehicle_1649239939.jpg",
        case rcbook = "rc_book"
        case floorid = "floor_id" //"156",
        case vehiclenumber = "vehicle_number" //."GJ-01-2545",
        case old_vehiclephoto = "old_vehicle_photo" //"Vehicle_1649239939.jpg",
        case old_rcbook = "old_rc_book"
        case unitid = "unit_id" //"640let
        case generate_number = "generate_number"
        case qrcode_id = "qrcode_id"
        case vehicle_status = "vehicle_status"
        
    }
}
// MARK: - CategoriesResponse
struct CategoriesResponse: Codable {
    let status: Int!
    let data: DataClass
    let notificationTrack: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case notificationTrack = "notification_track"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let success: Bool!
    let categoryList: [CategoryList]!

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case categoryList = "category_list"
    }
}

// MARK: - CategoryList
struct CategoryList: Codable {
    let categoryName: String!
    let categoryListDescription: String!
    let shortName: String!
    let displayOrder: Int!
    let categorySlug: String!
    let imageUrl: String!

    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case categoryListDescription = "description"
        case shortName = "short_name"
        case displayOrder = "display_order"
        case categorySlug = "category_slug"
        case imageUrl = "image_url"
    }
}

// MARK: - StoreResponse
struct StoreResponse: Codable {
    let status: Int!
    let data: DataStore
    let notificationTrack: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case notificationTrack = "notification_track"
    }
}

// MARK: - DataStore
struct DataStore: Codable {
    let success: Bool!
    let storeList: [StoreList]!

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case storeList = "store_list"
    }
}

// MARK: - StoreList
struct StoreList: Codable {
    let storeName: String!
    let storeListDescription: String!
    let storeUrl: String!
    let displayOrder: Int!
    let storeSlug: String!
    let isPopularStore: Int!
    let campaignId: String!
    let color1: String!
    let color2: String!
    let storeImageUrl: String!

    enum CodingKeys: String, CodingKey {
        case storeName = "store_name"
        case storeListDescription = "description"
        case storeUrl = "store_url"
        case displayOrder = "display_order"
        case storeSlug = "store_slug"
        case isPopularStore = "is_popular_store"
        case campaignId = "campaign_id"
        case color1 = "color_1"
        case color2 = "color_2"
        case storeImageUrl = "store_image_url"
    }
}

// MARK: - CategoriesOfferResponse
struct CategoriesOfferResponse: Codable {
    let status: Int!
    let data: OfferClass
    let notificationTrack: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case notificationTrack = "notification_track"
    }
}

// MARK: - OfferClass
struct OfferClass: Codable {
    let success: Bool!
    let offersList: [OffersList]!

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case offersList = "offers_list"
    }
}

// MARK: - OffersList
struct OffersList: Codable {
    let offerId: Int!
    let offerName: String!
    let offersListDescription: String!
    let categoryId: Int!
    let offerType: String!
    let offerTypeid: Int!
    let couponCode: String!
    let offerUrl: String!
    let startDate: String!
    let endDate: String!
    let appTags: String!
    let storeName: String!
    let storeImageUrl: String!

    enum CodingKeys: String, CodingKey {

        case offerId = "offer_id"
        case offerName = "offer_name"
        case offersListDescription = "description"
        case categoryId = "category_id"
        case offerType = "offer_type"
        case offerTypeid = "offer_typeid"
        case couponCode = "coupon_code"
        case offerUrl = "offer_url"
        case startDate = "start_date"
        case endDate = "end_date"
        case appTags = "app_tags"
        case storeName = "store_name"
        case storeImageUrl = "store_image_url"
    }
}

enum OfferType: String, Codable {
    case coupon = "coupon"
    case deal = "deal"
}


// MARK: - StoreOfferResponse
struct StoreOfferResponse: Codable {
    let status: Int!
    let data: StoreClass
    let notificationTrack: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case notificationTrack = "notification_track"
    }
}

// MARK: - DataClass
struct StoreClass: Codable {
    let success: Bool!
    let offersList: [StoreOfferList]!

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case offersList = "offers_list"
    }
}

// MARK: - StoreList
struct StoreOfferList: Codable {
    let offerId: Int!
    let offerName: String!
    let offersListDescription: String!
    let categoryId: Int!
    let categoryName: String!
    let offerType: String!
    let offerTypeid: Int!
    let couponCode: String!
    let offerUrl: String!
    let startDate: String!
    let endDate: String!
    let tags: String!
    let storeName: String!
    let storeImageUrl: String!

    enum CodingKeys: String, CodingKey {
        case offerId = "offer_id"
        case offerName = "offer_name"
        case offersListDescription = "description"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case offerType = "offer_type"
        case offerTypeid = "offer_typeid"
        case couponCode = "coupon_code"
        case offerUrl = "offer_url"
        case startDate = "start_date"
        case endDate = "end_date"
        case tags = "tags"
        case storeName = "store_name"
        case storeImageUrl = "store_image_url"
    }
}

enum CouponCode: String, Codable {
    case couponCode = ""
    case empty = " "
}

//enum OfferType: String, Codable {
//    case deal = "deal"
//}

enum StoreName: String, Codable {
    case flipkart = "Flipkart"
}



// MARK: - MyEventResponse
struct MyEventResponse: Codable {
    let event: [MyEvent]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case event = "event"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Event
struct MyEvent: Codable {
    let eventId: String!
    let eventAttendId: String!
    let eventTitle: String!
    let eventImage: String!
    let eventDate: String!
    let eventDayOnly: String!
    let eventMonthYearOnly: String!
    let eventType: String!
    let eventDayName: String!
    let eventTime: String!
    let eventLocation: String!
    let adultBooked: String!
    let childBooked: String!
    let guestBooked: String!
    let recivedAmount: String!
    let bookingId: String!
    let eventExpire : Bool!
    let invoiceUrl: String!
    
    enum CodingKeys: String, CodingKey {
        case eventExpire = "event_expire"
        case eventId = "event_id"
        case eventAttendId = "event_attend_id"
        case eventTitle = "event_title"
        case eventImage = "event_image"
        case eventDate = "event_date"
        case eventDayOnly = "event_day_only"
        case eventMonthYearOnly = "event_month_year_only"
        case eventType = "event_type"
        case eventDayName = "event_day_name"
        case eventTime = "event_time"
        case eventLocation = "event_location"
        case adultBooked = "adult_booked"
        case childBooked = "child_booked"
        case guestBooked = "guest_booked"
        case recivedAmount = "recived_amount"
        case bookingId = "booking_id"
        case invoiceUrl = "invoice_url"
    }
}
// MARK: - SurveyQuestionReponse
struct SurveyQuestionReponse: Codable {
    let survey: [SurveyQuestion]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case survey = "survey"
        case message = "message"
        case status = "status"
    }
}

// MARK: - Survey
struct SurveyQuestion: Codable {
    let surveyQuestionId: String!
    let surveyQuestion: String!
    var questionOption: [QuestionOption]!
    let surveyId: String!
    let questionImage: String!
  
    enum CodingKeys: String, CodingKey {
        case surveyQuestionId = "survey_question_id"
        case surveyQuestion = "survey_question"
        case questionOption = "question_option"
        case surveyId = "survey_id"
        case questionImage = "question_image"
        
    }
}

// MARK: - QuestionOption
struct QuestionOption: Codable {
    let surveyOptionName: String!
    let surveyOptionId: String!
    var isChack : Bool!
    enum CodingKeys: String, CodingKey {
        case surveyOptionName = "survey_option_name"
        case surveyOptionId = "survey_option_id"
        case isChack = "isChack"
    }
}
// MARK: - EventDetailsResponse
struct EventDetailsResponse: Codable {
    let event: [EventDetailList]!
    let message: String!
    let status: String!

    enum CodingKeys: String, CodingKey {
        case event = "event"
        case message = "message"
        case status = "status"
    }
}
// MARK: - Event
struct EventDetailList: Codable {
    let hideStatus: String!
    let eventId: String!
    let eventTitle: String!
    let eventImage: String!
    let eventUpcomingCompleted: String!
    let eventDescription: String!
    let eventStartDate: String!
    let eventStartDateView: String!
    let eventEndDate: String!
    let eventLocation: String!
    let eventType: String!
    let bookingOpen: String!
    let eventDays: [EventDay]!
    let gallery: [GalleryModel]!

    enum CodingKeys: String, CodingKey {
        case hideStatus = "hide_status"
        case eventId = "event_id"
        case eventTitle = "event_title"
        case eventImage = "event_image"
        case eventUpcomingCompleted = "event_upcoming_completed"
        case eventDescription = "event_description"
        case eventStartDate = "event_start_date"
        case eventStartDateView = "event_start_date_view"
        case eventEndDate = "event_end_date"
        case eventLocation = "event_location"
        case eventType = "event_type"
        case bookingOpen = "booking_open"
        case eventDays = "event_days"
        case gallery = "gallery"
    }
}
// MARK: - EventDay
struct EventDay: Codable {
    let is_taxble:String!
    let taxble_type:String!
    
    let igst_lbl_view:String!
    let cgst_lbl_view:String!
    let sgst_lbl_view:String!
    
    let tax_slab:String!
    let soldOut : Bool!
    let eventTime : String!
    let dayBookingOpen: Bool!
    let eventsDayId: String!
    let eventId: String!
    let eventDayName: String!
    let eventDate: String!
    let eventType: String!
    let balancesheetId: String!
    let adultChargeView: String!
    let childChargeView: String!
    let guestChargeView: String!
    
    let adultCharge: String!
    let childCharge: String!
    let guestCharge: String!
    let maximumPassAdult: String!
    let maximumPassChildren: String!
    let maximumPassGuests: String!
    let billType: String!
    let gst: String!
    let gstType: String!
    let gstSlab: String!
    let adultBooked: String!
    let childBooked: String!
    let guestBooked: String!
    let remainingPassAdult: String!
    let remainingPassChildren: String!
    let remainingPassGuests: String!
    let totalBooked: String!
    let isPay : Bool!
    let eventlocation: String!
    enum CodingKeys: String, CodingKey {
        case taxble_type = "taxble_type"
        case is_taxble = "is_taxble"
        case igst_lbl_view = "igst_lbl_view"
        case cgst_lbl_view = "cgst_lbl_view"
        case sgst_lbl_view = "sgst_lbl_view"
        case tax_slab = "tax_slab"
        case adultChargeView = "adult_charge_view"
        case childChargeView = "child_charge_view"
        case guestChargeView = "guest_charge_view"
        case soldOut = "sold_out"
        case eventTime = "event_time"
        case dayBookingOpen = "day_booking_open"
        case eventsDayId = "events_day_id"
        case eventId = "event_id"
        case eventDayName = "event_day_name"
        case eventDate = "event_date"
        case eventType = "event_type"
        case balancesheetId = "balancesheet_id"
        case adultCharge = "adult_charge"
        case childCharge = "child_charge"
        case guestCharge = "guest_charge"
        case maximumPassAdult = "maximum_pass_adult"
        case maximumPassChildren = "maximum_pass_children"
        case maximumPassGuests = "maximum_pass_guests"
        case billType = "bill_type"
        case gst = "gst"
        case gstType = "gst_type"
        case gstSlab = "gst_slab"
        case adultBooked = "adult_booked"
        case childBooked = "child_booked"
        case guestBooked = "guest_booked"
        case eventlocation = "event_location"
        case remainingPassAdult = "remaining_pass_adult"
        case remainingPassChildren = "remaining_pass_children"
        case remainingPassGuests = "remaining_pass_guests"
        case totalBooked = "total_booked"
        case isPay = "isPay"
    }
}


// MARK: - SurveyQuestionReponse
struct StoreOfferReponse: Codable {
    var notificationTrack: String!
    var status: Int!
    var data: StoreOfferMainReponse!

    enum CodingKeys: String, CodingKey {
        case notificationTrack = "notification_track"
        case status = "status"
        case data = "data"
    }
}

// MARK: - DataClass
struct StoreOfferMainReponse: Codable {
    var offersList: [StoreOfferModel]!
    var success: Bool!

    enum CodingKeys: String, CodingKey {
        case offersList = "offers_list"
        case success = "success"
    }
}

// MARK: - OffersList
struct StoreOfferModel: Codable {
    var startDate: String!
    var offerId: Int!
    var tags: String!
    var storeImageUrl: String!
    var offersListDescription: String!
    var categoryId: Int!
    var offerName: String!
    var categoryName: String!
    var offerTypeid: Int!
    var couponCode: String!
    var offerType: String!
    var storeName: String!
    var offerUrl: String!
    var endDate: String!

    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case offerId = "offer_id"
        case tags = "tags"
        case storeImageUrl = "store_image_url"
        case offersListDescription = "description"
        case categoryId = "category_id"
        case offerName = "offer_name"
        case categoryName = "category_name"
        case offerTypeid = "offer_typeid"
        case couponCode = "coupon_code"
        case offerType = "offer_type"
        case storeName = "store_name"
        case offerUrl = "offer_url"
        case endDate = "end_date"
    }
}
// MARK: - SurveyQuestionReponse
struct CategoryOfferResponse: Codable {
    var notificationTrack: String!
    var status: Int!
    var data: CategoryOfferMainResponse!

    enum CodingKeys: String, CodingKey {
        case notificationTrack = "notification_track"
        case status = "status"
        case data = "data"
    }
}

// MARK: - DataClass
struct CategoryOfferMainResponse: Codable {
    var offersList: [CategoryOfferModel]!
    var success: Bool!

    enum CodingKeys: String, CodingKey {
        case offersList = "offers_list"
        case success = "success"
    }
}

// MARK: - OffersList
struct CategoryOfferModel: Codable {
    var couponCode: String!
    var storeName: String!
    var storeImageUrl: String!
    var appTags: String!
    var endDate: String!
    var offerUrl: String!
    var offerTypeid: Int!
    var categoryId: Int!
    var offerType: String!
    var startDate: String!
    var offersListDescription: String!
    var offerName: String!
    var offerId: Int!
    let categoryName : String!
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case couponCode = "coupon_code"
        case storeName = "store_name"
        case storeImageUrl = "store_image_url"
        case appTags = "app_tags"
        case endDate = "end_date"
        case offerUrl = "offer_url"
        case offerTypeid = "offer_typeid"
        case categoryId = "category_id"
        case offerType = "offer_type"
        case startDate = "start_date"
        case offersListDescription = "description"
        case offerName = "offer_name"
        case offerId = "offer_id"
    }
}
// MARK: - CustomerListReponse
struct CustomerListResponse: Codable {
    var customer: [CustomerListModel]!
    var totalAdvance : String!
    var totalDue : String!
    var status: String!
    var message: String!

    enum CodingKeys: String, CodingKey {
        case totalAdvance = "totalAdvance"
        case totalDue = "totalDue"
        case customer = "customer"
        case status = "status"
        case message = "message"
    }
}


// MARK: - Customer List Model
struct CustomerListModel: Codable {
    var viewMsg: String!
    var customerMobile: String!
    var customerName: String!
    var customerAddress: String!
    var societyId: String!
    var dueDate: String!
    var dueAmount: String!
    var finbookCustomerId: String!
    var isDue: Bool!
    var userId: String!
    var paymentReminderMsg : String!

    enum CodingKeys: String, CodingKey {
        case paymentReminderMsg = "paymentReminderMsg"
        case viewMsg = "viewMsg"
        case customerMobile = "customer_mobile"
        case customerName = "customer_name"
        case customerAddress = "customer_address"
        case societyId = "society_id"
        case dueDate = "due_date"
        case dueAmount = "due_amount"
        case finbookCustomerId = "finbook_customer_id"
        case isDue = "is_due"
        case userId = "user_id"
    }
}
// MARK: - CustomerTransactionResponse
struct CustomerTransactionResponse: Codable {
    var status: String!
    var isDue: Bool!
    var totalDebitAmount: Int!
    var totalCreditAmount: String!
    var message: String!
    var viewMsg: String!
    var tansaction: [CustomerTansactionModel]!
    var dueBlanace: String!
    var due_date : String!
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case isDue = "is_due"
        case totalDebitAmount = "totalDebitAmount"
        case totalCreditAmount = "totalCreditAmount"
        case message = "message"
        case viewMsg = "viewMsg"
        case tansaction = "tansaction"
        case dueBlanace = "dueBlanace"
        case due_date
    }
}

// MARK: - CustomerTansactionModel
struct CustomerTansactionModel: Codable {
    var msgDateView: String!
    var isDate: Bool!
    var msgDate: String!
    var billPhoto: [BillPhotoModel]!
    var activeStatus: String!
    var debitAmount: String!
    var remaningAmount: String!
    var createdDate: String!
    var addedOn: String!
    var userId: String!
    var remark: String!
    var societyId: String!
    var finbookCustomerId: String!
    var finbookPassbookId: String!
    var creditAmount: String!
    var credit_amount_view: String!
    var debit_amount_view: String!
    var deletedDate : String!
    var customerName : String!
    enum CodingKeys: String, CodingKey {
        case credit_amount_view = "credit_amount_view"
        case debit_amount_view = "debit_amount_view"
        case deletedDate = "deleted_date"
        case msgDateView = "msg_date_view"
        case isDate = "isDate"
        case msgDate = "msg_date"
        case billPhoto = "bill_photo"
        case activeStatus = "active_status"
        case debitAmount = "debit_amount"
        case remaningAmount = "remaning_amount"
        case createdDate = "created_date"
        case addedOn = "added_on"
        case userId = "user_id"
        case remark = "remark"
        case societyId = "society_id"
        case finbookCustomerId = "finbook_customer_id"
        case finbookPassbookId = "finbook_passbook_id"
        case creditAmount = "credit_amount"
        case customerName = "customer_name"
    }
}
// MARK: - BillPhoto
struct BillPhotoModel: Codable {
    var finbookBillPhotoId: String!
    var billPhoto: String!
    var finbookPassbookId: String!
    var tutorialVideo: String!

    enum CodingKeys: String, CodingKey {
        case finbookBillPhotoId = "finbook_bill_photo_id"
        case billPhoto = "bill_photo"
        case finbookPassbookId = "finbook_passbook_id"
        case tutorialVideo = "tutorial_video"
    }
}
struct FinbookReportResponse: Codable {
    var status: String!
    var totalCreditAmount: String!
    var tansaction: [FinbookReportModel]!
    var viewMsg: String!
    var message: String!
    var totalDebitAmount: String!
    var isDue: Bool!
    var dueBlanace: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalCreditAmount = "totalCreditAmount"
        case tansaction = "tansaction"
        case viewMsg = "viewMsg"
        case message = "message"
        case totalDebitAmount = "totalDebitAmount"
        case isDue = "is_due"
        case dueBlanace = "dueBlanace"
    }
}

// MARK: - Tansaction
struct FinbookReportModel: Codable {
    var remaningAmount: String!
    var activeStatus: String!
    var createdDate: String!
    var finbookCustomerId: String!
    var customerName: String!
    var remark: String!
    var deletedDate: String!
    var addedOn: String!
    var societyId: String!
    var creditAmount: String!
    var creditAmountView: String!
    var debitAmount: String!
    var debitAmountView: String!
    var billPhoto: [BillPhotoModel]!
    var finbookPassbookId: String!
    var userId: String!

    enum CodingKeys: String, CodingKey {
        case remaningAmount = "remaning_amount"
        case activeStatus = "active_status"
        case createdDate = "created_date"
        case finbookCustomerId = "finbook_customer_id"
        case customerName = "customer_name"
        case remark = "remark"
        case deletedDate = "deleted_date"
        case addedOn = "added_on"
        case societyId = "society_id"
        case creditAmount = "credit_amount"
        case debitAmount = "debit_amount"
        case billPhoto = "bill_photo"
        case finbookPassbookId = "finbook_passbook_id"
        case userId = "user_id"
        case creditAmountView = "credit_amount_view"
        case debitAmountView = "debit_amount_view"
    }
}

// MARK: - discsussion list response
struct DiscussionListResponse: Codable {
    var message: String!
    var status: String!
    var discussionMute : String!
    var discussion: [DiscussionListModel]!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case discussion = "discussion"
        case discussionMute = "discussion_mute"
    }
}

// MARK: - Discussion
struct DiscussionListModel: Codable {
    var comment: [CommentListModel]!
    var discussionForumTitle: String!
    var totalComents: String!
    var createdBy: String!
    var discussionForumDescription: String!
    var muteStatus: Bool!
    var discussionFile : String!
    var discussionPhoto: String!
    var userProfile: String!
    var createdDate: String!
    var createdUnit: String!
    var discussionForumId: String!
    var discussionForumFor: String!
    var userId: String!

    enum CodingKeys: String, CodingKey {
        case discussionFile = "discussion_file"
        case comment = "comment"
        case discussionForumTitle = "discussion_forum_title"
        case totalComents = "total_coments"
        case createdBy = "created_by"
        case discussionForumDescription = "discussion_forum_description"
        case muteStatus = "mute_status"
        case discussionPhoto = "discussion_photo"
        case userProfile = "user_profile"
        case createdDate = "created_date"
        case createdUnit = "created_unit"
        case discussionForumId = "discussion_forum_id"
        case discussionForumFor = "discussion_forum_for"
        case userId = "user_id"
    }
}
// MARK: - CommentListModel
struct CommentListModel: Codable {
    var subComment: [CommentListModel]!
    var commentId: String!
    var commentCreatedDate: String!
    var userId: String!
    var blockName: String!
    var commentMessaage: String!
    var userProfile: String!
    var createdBy: String!
    var prentCommentId: String!
    var commentattachment: String!

    enum CodingKeys: String, CodingKey {
        case subComment = "sub_comment"
        case commentId = "comment_id"
        case commentCreatedDate = "comment_created_date"
        case userId = "user_id"
        case blockName = "block_name"
        case commentMessaage = "comment_messaage"
        case userProfile = "user_profile"
        case createdBy = "created_by"
        case prentCommentId = "prent_comment_id"
        case commentattachment = "comment_attachment"
        
    }
}
// MARK: - SurveyQuestionReponse
struct ChildSecurityListReponse: Codable {
    var message: String!
    var status: String!
    var child: [ChildSecurityListModel]!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case child = "child"
    }
}

// MARK: - Child
struct ChildSecurityListModel: Codable {
    var childName: String!
    var childSecurityId: String!
    var childPhotoOld: String!
    var securityStatus: String!
    var unitId: String!
    var userId: String!
    var societyId: String!
    var securityStatusView: String!
    var returnTim: String!
    var duration: String!
    var validTill: String!
    var exitTime: String!
    var childPhoto: String!
    var rejected_date: String!

    enum CodingKeys: String, CodingKey {
        case childName = "child_name"
        case childSecurityId = "child_security_id"
        case childPhotoOld = "child_photo_old"
        case securityStatus = "security_status"
        case unitId = "unit_id"
        case userId = "user_id"
        case societyId = "society_id"
        case securityStatusView = "security_status_view"
        case returnTim = "return_tim"
        case duration = "duration"
        case validTill = "valid_till"
        case exitTime = "exit_time"
        case childPhoto = "child_photo"
        case rejected_date = "rejected_date"
    }
}
// MARK: - SurveyQuestionReponse
struct UserActivityResponse: Codable {
    var message: String!
    var status: String!
    var logname: [UserActivityModel]!

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case logname = "logname"
    }
}

// MARK: - Logname
struct UserActivityModel: Codable {
    var logName: String!
    var userId: String!
    var logTime: String!
    var logImage : String!
    var logId: String!

    enum CodingKeys: String, CodingKey {
        case logImage = "log_image"
        case logName = "log_name"
        case userId = "user_id"
        case logTime = "log_time"
        case logId = "log_id"
    }
}
// MARK: - BillModel
struct ComplainDetailResponse: Codable {
    var complaintCategory: String!
    var message: String!
    var track: [Track]!
    var audioDuration: Int!
    var complainStatusArray: [complainStatusModel]!
    var status: String!

    enum CodingKeys: String, CodingKey {
        case complaintCategory = "complaint_category"
        case message = "message"
        case track = "track"
        case audioDuration = "audio_duration"
        case complainStatusArray = "complain_status_array"
        case status = "status"
    }
}

// MARK: - ComplainStatusArray
struct complainStatusModel: Codable {
    var status: String!
    var value: String!

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case value = "value"
    }
}

// MARK: - Track
struct Track: Codable {
    var isDate: Bool!
    var msgDate: String!
    var msgDateView: String!
    var complainsTrackId: String!
    var complainsTrackMsg: String!
    var complainId: String!
    var complaintVoiceOld: String!
    var adminId: String!
    var complainsTrackBy: String!
    var adminName: String!
    var complainsTrackDateTime: String!
    var complainPhotoOld: String!
    var complainsTrackImg: String!
    var complaintCategory: String!
    var complaintStatusView: String!
    var complainsTrackVoice: String!
    var isPlayAudio : Bool! = false
    var duration : String!
    var currentTime : String!
    var complainStatus : String!

    
    enum CodingKeys: String, CodingKey {
        case isDate = "isDate"
        case msgDate = "msg_date"
        case msgDateView = "msg_date_view"
        case complainsTrackId = "complains_track_id"
        case complainsTrackMsg = "complains_track_msg"
        case complainId = "complain_id"
        case complaintVoiceOld = "complaint_voice_old"
        case adminId = "admin_id"
        case complainsTrackBy = "complains_track_by"
        case adminName = "admin_name"
        case complainsTrackDateTime = "complains_track_date_time"
        case complainPhotoOld = "complain_photo_old"
        case complainsTrackImg = "complains_track_img"
        case complaintCategory = "complaint_category"
        case complaintStatusView = "complaint_status_view"
        case complainsTrackVoice = "complains_track_voice"
        case complainStatus = "complain_status"
        
    }
}


//for firebase chat member model
struct MemberModelChat :Codable{
    var  userChatId : String! //
    var  userId : String! //
    var  userMobile : String! //
    var  userProfile : String! //
    var  publicMobile : String! //
    var  userBlockName : String! //
    var  userType : String! //
    var  online : Bool! //
    var  lastSeen : String! //
    var  gender : String! //
    var  userName : String! //
    var  userToken : String! //
     
}



struct  PackageModel : Codable {
    
    let package_amount : String?
    let balancesheet_id : String?
    let package_id : String?
    let package_name : String?
    let no_of_months : String?
    
//    payPacakge
//    payPacakge
    

    
}
