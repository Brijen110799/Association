//
//  ElectionModel.swift
//  Finca
//
//  Created by harsh panchal on 11/08/20.
//  Copyright © 2020 anjali. All rights reserved.
//

import Foundation
// MARK: - BillModel
struct ElectionListReponse: Codable {
    var electionCompleted: [ElectionDataModel]!
    var status: String!
    var message: String!
    var election: [ElectionDataModel]!

    enum CodingKeys: String, CodingKey {
        case electionCompleted = "election_completed"
        case status = "status"
        case message = "message"
        case election = "election"
    }
}

// MARK: - Election
struct ElectionDataModel: Codable {
    var electionName: String!
    var electionCreatedBy: String!
    var electionId: String!
    var electionDescription: String!
    var electionStatus: String!
    var electionStatusView: String!
    var electionDate: String!

    enum CodingKeys: String, CodingKey {
        case electionName = "election_name"
        case electionCreatedBy = "election_created_by"
        case electionId = "election_id"
        case electionDescription = "election_description"
        case electionStatus = "election_status"
        case electionStatusView = "election_status_view"
        case electionDate = "election_date"
    }
}
