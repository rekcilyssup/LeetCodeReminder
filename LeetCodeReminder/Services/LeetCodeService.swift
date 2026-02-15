//
//  LeetCodeService.swift
//  LeetCodeReminder
//
//  Created on Feb 15, 2026
//

import Foundation
import AppKit

class LeetCodeService: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var dailyProblem: DailyProblem?
    @Published var userStatus: UserStatus?
    @Published var profileImage: NSImage?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var username: String
    private let graphQLEndpoint = "https://leetcode.com/graphql"
    
    init(username: String = "") {
        self.username = username
        loadUsername()
    }
    
    private func loadUsername() {
        if let savedUsername = UserDefaults.standard.string(forKey: "leetcode_username") {
            self.username = savedUsername
        }
    }
    
    func saveUsername(_ username: String) {
        self.username = username
        UserDefaults.standard.set(username, forKey: "leetcode_username")
        fetchAllData()
    }
    
    func fetchAllData() {
        guard !username.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        let group = DispatchGroup()
        
        group.enter()
        fetchUserProfile { group.leave() }
        
        group.enter()
        fetchDailyProblem { group.leave() }
        
        group.enter()
        fetchUserStatus { group.leave() }
        
        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
    
    private func fetchUserProfile(completion: @escaping () -> Void) {
        let query = """
        {
            matchedUser(username: "\(username)") {
                username
                profile {
                    userAvatar
                    ranking
                }
                submitStatsGlobal {
                    acSubmissionNum {
                        difficulty
                        count
                        submissions
                    }
                }
            }
        }
        """
        
        executeGraphQLQuery(query: query) { (result: Result<GraphQLResponse<UserProfileData>, Error>) in
            switch result {
            case .success(let response):
                if let userData = response.data.matchedUser {
                    let profile = UserProfile(
                        username: userData.username,
                        avatar: userData.profile.userAvatar,
                        ranking: userData.profile.ranking,
                        submitStats: UserProfile.SubmitStats(
                            totalSubmissionNum: userData.submitStatsGlobal.acSubmissionNum.map {
                                UserProfile.SubmissionCount(
                                    difficulty: $0.difficulty,
                                    count: $0.count,
                                    submissions: $0.submissions
                                )
                            }
                        )
                    )
                    
                    DispatchQueue.main.async {
                        self.userProfile = profile
                        self.downloadProfileImage(from: userData.profile.userAvatar)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
            completion()
        }
    }
    
    private func fetchDailyProblem(completion: @escaping () -> Void) {
        let query = """
        {
            activeDailyCodingChallengeQuestion {
                date
                link
                question {
                    questionId
                    title
                    titleSlug
                    difficulty
                }
            }
        }
        """
        
        executeGraphQLQuery(query: query) { (result: Result<GraphQLResponse<DailyProblemData>, Error>) in
            switch result {
            case .success(let response):
                if let challenge = response.data.activeDailyCodingChallengeQuestion {
                    let problem = DailyProblem(
                        date: challenge.date,
                        question: DailyProblem.Question(
                            questionId: challenge.question.questionId,
                            title: challenge.question.title,
                            titleSlug: challenge.question.titleSlug,
                            difficulty: challenge.question.difficulty
                        )
                    )
                    
                    DispatchQueue.main.async {
                        self.dailyProblem = problem
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
            completion()
        }
    }
    
    private func fetchUserStatus(completion: @escaping () -> Void) {
        let query = """
        {
            matchedUser(username: "\(username)") {
                submitStatsGlobal {
                    acSubmissionNum {
                        difficulty
                        count
                    }
                }
                userCalendar {
                    streak
                    activeYears
                }
            }
            recentSubmissionList(username: "\(username)") {
                title
                titleSlug
                timestamp
                statusDisplay
                lang
            }
        }
        """
        
        executeGraphQLQuery(query: query) { (result: Result<GraphQLResponse<UserStatusData>, Error>) in
            switch result {
            case .success(let response):
                let totalSolved = response.data.matchedUser?.submitStatsGlobal.acSubmissionNum
                    .first(where: { $0.difficulty == "All" })?.count ?? 0
                
                let today = Date()
                let todaySubmissions = response.data.recentSubmissionList?.filter { submission in
                    guard let timestamp = Double(submission.timestamp),
                          submission.statusDisplay == "Accepted" else { return false }
                    let submissionDate = Date(timeIntervalSince1970: timestamp)
                    return Calendar.current.isDate(submissionDate, inSameDayAs: today)
                } ?? []
                
                let dailyCompleted = todaySubmissions.contains { submission in
                    submission.titleSlug == self.dailyProblem?.question.titleSlug
                }
                
                let status = UserStatus(
                    solvedToday: Set(todaySubmissions.map { $0.titleSlug }).count,
                    totalSolved: totalSolved,
                    dailyProblemCompleted: dailyCompleted,
                    streak: response.data.matchedUser?.userCalendar.streak ?? 0
                )
                
                DispatchQueue.main.async {
                    self.userStatus = status
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
            completion()
        }
    }
    
    private func downloadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = NSImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }.resume()
    }
    
    private func executeGraphQLQuery<T: Decodable>(query: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: graphQLEndpoint) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - GraphQL Response Models
struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T
}

struct UserProfileData: Decodable {
    let matchedUser: MatchedUser?
    
    struct MatchedUser: Decodable {
        let username: String
        let profile: Profile
        let submitStatsGlobal: SubmitStats
        
        struct Profile: Decodable {
            let userAvatar: String
            let ranking: Int?
        }
        
        struct SubmitStats: Decodable {
            let acSubmissionNum: [AcSubmission]
            
            struct AcSubmission: Decodable {
                let difficulty: String
                let count: Int
                let submissions: Int
            }
        }
    }
}

struct DailyProblemData: Decodable {
    let activeDailyCodingChallengeQuestion: ActiveDaily?
    
    struct ActiveDaily: Decodable {
        let date: String
        let link: String
        let question: Question
        
        struct Question: Decodable {
            let questionId: String
            let title: String
            let titleSlug: String
            let difficulty: String
        }
    }
}

struct UserStatusData: Decodable {
    let matchedUser: MatchedUser?
    let recentSubmissionList: [RecentSubmission]?
    
    struct MatchedUser: Decodable {
        let submitStatsGlobal: SubmitStats
        let userCalendar: UserCalendar
        
        struct SubmitStats: Decodable {
            let acSubmissionNum: [AcSubmission]
            
            struct AcSubmission: Decodable {
                let difficulty: String
                let count: Int
            }
        }
        
        struct UserCalendar: Decodable {
            let streak: Int
            let activeYears: [Int]?
        }
    }
}
