//
//  SessionProtocol.swift
//  MeetCos
//
//  Created by apple on 2023/05/10.
//

import Foundation

protocol SessionProtocol {
    var sessionId: Int64 { get set }
    var startedAt: Date? { get set }
    var finishedAt: Date? { get set }
    var willFinishAt: Date? { get set }
    var createdAt: String { get set }
    var updatedAt: String { get set }
    var duration: Double { get set }
    var estimatedCost: Int64 { get set }
    var totalCost: Int64 { get set }
    var groups: Set<Group> { get set }
}
