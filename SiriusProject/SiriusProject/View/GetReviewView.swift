//
//  GetReviewView.swift
//  SiriusProject
//
//  Created by Алексей Кобяков on 01.04.2025.
//

import SwiftUI

struct GetReviewView: View {
    let event: Event?
    @State private var isPresented: Bool = false
    @State private var showAnimation: Bool = false
    @State private var receivedScore: Int? = nil
    @State private var isShowHandReviewView: Bool = false

    private let log: (String) -> Void

    init(
        event: Event = Event(
            id: 1,
            title: "Title",
            state: .done,
            score: 10,
            address: "",
            description: "Description",
            latitude: 0.0,
            longitude: 0.0
        ),
        log: @escaping (String) -> Void = { message in
            #if DEBUG
                print(message)
            #endif
        }
    ) {
        self.event = event
        self.log = log
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("getscore")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if let event = event {
                        Text(event.title)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 24)

                VStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 60))
                        .symbolEffect(.bounce, value: showAnimation)
                        .foregroundStyle(.blue)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 120, height: 120)
                        )

                    VStack(spacing: 8) {
                        Text("howtogetscore")
                            .font(.headline)

                        Text("askthejudgesetscore")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }

                    if let score = receivedScore {
                        RatingBadge(score: score)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("variant") + Text(" 1:")
                        .font(.headline)
                    InstructionStep(number: 1, text: "askthejudgeopenapp")
                    InstructionStep(number: 2, text: "thejudgewillchoose")
                    InstructionStep(number: 3, text: "expecttoreceiveanestimate")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("variant") + Text(" 2:")
                        .font(.headline)
                    InstructionStep(number: 1, text: "gotojudge")
                    InstructionStep(number: 2, text: "usemanualbutton")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)

                Button("manualinput", systemImage: "person.fill.questionmark") {
                    isShowHandReviewView.toggle()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .cornerRadius(12)
                .padding(.horizontal, 32)
                .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                .padding()
            }
        }
        .sheet(isPresented: $isShowHandReviewView) {
            GetRateView(score: $receivedScore)
        }
        .onOpenURL { url in
            handleIncomingURL(url)
        }
        .onChange(of: receivedScore) {}
        .alert("gradereceived", isPresented: $isPresented) {
            Button("OK", role: .cancel) {
                withAnimation {
                    showAnimation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showAnimation = false
                    }
                }
            }
        } message: {
            if let title = event?.title, let score = receivedScore {
                Text("yourratingfor") + Text(" \(title): \(score)/10")
            }
        }
    }

    private func handleIncomingURL(_ url: URL) {
        guard let idAndScore = url.recieveDeeplinkURL(log: log) else { return }

        receivedScore = idAndScore[1]
        isPresented = true

        let logMessage = """
        Получены данные:
        ID: \(idAndScore[0]),
        Оценка: \(idAndScore[1])
        """
        log(logMessage)
    }
}

// MARK: - Subviews

struct RatingBadge: View {
    let score: Int

    var body: some View {
        Text("\(score)/10")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(score < 5 ? .red : score < 8 ? .orange : .green)
            )
    }
}

struct InstructionStep: View {
    let number: Int
    let text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number).")
                .fontWeight(.bold)
                .foregroundStyle(.blue)

            Text(text)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .font(.subheadline)
    }
}

private extension URL {
    func recieveDeeplinkURL(log: @escaping (String) -> Void = { _ in }) -> [Int]? {
        let infoFromURL = absoluteString
        let parsedInfo = infoFromURL.split(separator: "*")

        guard let id = Int(parsedInfo[1]) else {
            log("ID not converted!")
            return nil
        }
        guard let score = Int(parsedInfo[2]) else {
            log("Score not converted")
            return nil
        }

        return [id, score]
    }
}

#Preview {
    GetReviewView(event: Event(
        id: 1,
        title: "Title",
        state: .done,
        score: 5,
        address: "",
        description: "Description",
        latitude: 0.0,
        longitude: 0.0
    ))
}
