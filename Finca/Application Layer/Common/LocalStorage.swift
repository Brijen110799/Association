//
//  LocalStorage.swift
//  Finca
//
//  Created by Silverwing Technologies on 17/03/21.
//  Copyright © 2021 anjali. All rights reserved.
//

import Foundation

class LocalStorage: NSObject {
    static let instance = LocalStorage()
    
    private let keyAppVersion = "appversionlocal"
    private let keyCountryid = "countryid"
    private let ketIsSetBusinessData = "businessData"
    private let keyHideMYActivity = "hideMYActivity"
    private let keyHideAddTeamMember = "hideAddTeamMember"
    private let keyVisitCards = "visitingcards"
    private let Chatuseraccess = "chatuseraccess"
    private let Timelineuseraccess = "timelineaccess"
    private let shareAppContent = "shareappcontent"
     let  planLastShowDate = "planLastShowDate"
    
    private let defaults = UserDefaults.standard
    
    func setCurrentAppVersion(versionCode : String) {
        defaults.setValue(versionCode, forKey: keyAppVersion)
    }
    
    func getCurrentAppVersion() -> String {
        return defaults.string(forKey: keyAppVersion) ?? ""
    }
    
    
    
    func setCountryId(versionCode : String) {
        defaults.setValue(versionCode, forKey: keyCountryid)
    }
    
    func getCountryId() -> String {
        return defaults.string(forKey: keyCountryid) ?? ""
    }
    
    
    func setCompleteProfile(setData  isCheck: Bool) {
        defaults.setValue(isCheck, forKey: ketIsSetBusinessData)
    }
    
    func getCompleteProfile() -> Bool {
        return defaults.bool(forKey: ketIsSetBusinessData) 
    }
    
    
    func setHideMYActivity(setData  isCheck: Bool) {
        defaults.setValue(isCheck, forKey: keyHideMYActivity)
    }
    
    func getHideMYActivity() -> Bool {
        return defaults.bool(forKey: keyHideMYActivity)
    }
    func setHideAddTeamMember(setData  isCheck: Bool) {
        defaults.setValue(isCheck, forKey: keyHideAddTeamMember)
    }
    
    func getHideAddTeamMember() -> Bool {
        return defaults.bool(forKey: keyHideAddTeamMember)
    }
    
    func setVisitingList(setData  data: [CardModel]) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey:keyVisitCards)
        }
    }
    
    func getVisitingList() -> [CardModel] {
        if let data = UserDefaults.standard.data(forKey: keyVisitCards), let decoded = try? JSONDecoder().decode([CardModel].self, from: data){
            return decoded
        }
        return [CardModel]()
    }
    func setChatuseraccess(setdata ischeck:Bool) {
        defaults.setValue(ischeck, forKey: Chatuseraccess)
    }
    
    func getChatuseraccess() -> Bool {
        return defaults.bool(forKey: Chatuseraccess)
    }
    func setTimelineuseraccess(setdata ischeck:Bool){
        defaults.setValue(ischeck, forKey: Timelineuseraccess)
    }
    func getTimelineuseraccess() -> Bool {
        return defaults.bool(forKey: Timelineuseraccess)
    }
    func setShareappcontent(setdata data:String){
        defaults.setValue(data, forKey: shareAppContent)
    }
    func getShareappcontent() -> String {
        return defaults.string(forKey: shareAppContent) ?? ""
    }
    
    func setPlanLastShowDate(setdata data:String){
        defaults.setValue(data, forKey: planLastShowDate)
    }
    func getPlanLastShowDate() -> String {
        return defaults.string(forKey: planLastShowDate) ?? ""
    }
   
    
 
    
}
