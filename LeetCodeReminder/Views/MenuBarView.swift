//
//  MenuBarView.swift
//  LeetCodeReminder
//
//  Created on Feb 15, 2026
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var service: LeetCodeService
    @State private var usernameInput = ""
    @State private var isEditing = false
    
    var body: some View {
        Group {
            if service.userProfile != nil {
                mainContent
            } else {
                onboardingView
            }
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
            
            statsSection
            
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
            
            dailySection
            
            footerSection
        }
        .frame(width: 320)
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack {
                if let image = service.profileImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(String(service.userProfile?.username.prefix(1) ?? "?").uppercased())
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                        )
                }
                
                // Status ring
                Circle()
                    .stroke(statusColor, lineWidth: 2.5)
                    .frame(width: 48, height: 48)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(service.userProfile?.username ?? "")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let ranking = service.userProfile?.ranking {
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.yellow)
                        Text("Rank \(ranking.formatted())")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Status pill
            if let status = service.userStatus {
                Text(status.dailyProblemCompleted ? "Done" : "Pending")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(status.dailyProblemCompleted ? Color.green : Color.red)
                    )
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }
    
    // MARK: - Stats
    private var statsSection: some View {
        HStack(spacing: 10) {
            if let status = service.userStatus {
                statItem(
                    value: "\(status.solvedToday)",
                    label: "Solved Today",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                
                verticalDivider
                
                statItem(
                    value: "\(status.totalSolved)",
                    label: "Total Solved",
                    icon: "chart.bar.fill",
                    color: .blue
                )
                
                verticalDivider
                
                statItem(
                    value: "\(status.streak)",
                    label: "Day Streak",
                    icon: "flame.fill",
                    color: .orange
                )
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }
    
    private func statItem(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var verticalDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.06))
            .frame(width: 1, height: 50)
    }
    
    // MARK: - Daily Problem
    private var dailySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let daily = service.dailyProblem {
                HStack {
                    Text("DAILY CHALLENGE")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                        .tracking(0.5)
                    
                    Spacer()
                    
                    difficultyBadge(daily.question.difficulty)
                }
                
                Text(daily.question.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(action: {
                    if let url = URL(string: "https://leetcode.com/problems/\(daily.question.titleSlug)/") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10, weight: .bold))
                        Text("Open in Browser")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                (service.userStatus?.dailyProblemCompleted ?? false)
                                    ? Color.green.opacity(0.8)
                                    : Color.blue.opacity(0.8)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }
    
    private func difficultyBadge(_ difficulty: String) -> some View {
        Text(difficulty)
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .foregroundColor(difficultyColor(difficulty))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(difficultyColor(difficulty).opacity(0.15))
            )
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
    
    // MARK: - Footer
    private var footerSection: some View {
        HStack(spacing: 0) {
            footerButton(icon: "arrow.clockwise", label: "Refresh") {
                service.fetchAllData()
            }
            
            footerButton(icon: "person.crop.circle", label: "Switch User") {
                isEditing = true
            }
            
            footerButton(icon: "xmark.circle", label: "Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 10)
        .sheet(isPresented: $isEditing) {
            onboardingView
        }
    }
    
    private func footerButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(label)
                    .font(.system(size: 9))
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Status Color
    private var statusColor: Color {
        guard let status = service.userStatus else { return .gray }
        return status.dailyProblemCompleted ? .green : .red
    }
    
    // MARK: - Onboarding
    private var onboardingView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 36))
                .foregroundColor(.blue)
            
            Text("LeetCode Reminder")
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            Text("Enter your LeetCode username")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            TextField("username", text: $usernameInput)
                .textFieldStyle(.roundedBorder)
                .frame(width: 200)
                .onSubmit {
                    guard !usernameInput.isEmpty else { return }
                    service.saveUsername(usernameInput)
                    isEditing = false
                }
            
            Button(action: {
                guard !usernameInput.isEmpty else { return }
                service.saveUsername(usernameInput)
                isEditing = false
            }) {
                Text("Connect")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(usernameInput.isEmpty ? Color.gray : Color.blue)
                    )
            }
            .buttonStyle(.plain)
            .disabled(usernameInput.isEmpty)
            
            Spacer()
        }
        .frame(width: 320, height: 300)
    }
}

#Preview {
    MenuBarView(service: LeetCodeService())
        .frame(width: 320)
}
