//
//  LeetCodeModels.swift
//  LeetCodeReminder
//
//  Created on Feb 15, 2026
//

import Foundation

struct UserProfile: Codable {
    let username: String
    let avatar: String
    let ranking: Int?
    
    struct SubmitStats: Codable {
        let totalSubmissionNum: [SubmissionCount]
    }
    
    struct SubmissionCount: Codable {
        let difficulty: String
        let count: Int
        let submissions: Int
    }
    
    let submitStats: SubmitStats?
}

struct DailyProblem: Codable {
    let date: String
    let question: Question
    
    struct Question: Codable {
        let questionId: String
        let title: String
        let titleSlug: String
        let difficulty: String
    }
}

struct UserStatus: Codable {
    let solvedToday: Int
    let totalSolved: Int
    let dailyProblemCompleted: Bool
    let streak: Int
}

struct RecentSubmission: Codable {
    let title: String
    let titleSlug: String
    let timestamp: String
    let statusDisplay: String
    let lang: String
}
