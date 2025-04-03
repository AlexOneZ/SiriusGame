//
//  CreateEventView.swift
//  SiriusProject
//
//  Created by Илья Лебедев on 03.04.2025.
//

import MapKit
import SwiftUI

struct CreateEventView: View {
    enum Field {
        case title
        case description
        case location
        case rules
    }

    @ObservedObject var viewModel: CreateEventViewModel

    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showMapPicker = false
    @FocusState private var focusedField: Field?

//    @State var canSubmit: Bool {title.isEmpty || description.isEmpty || adress.isEmpty || rules.isEmpty}

    init(viewModel: CreateEventViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("Добавтье состязание")
                        .font(.title)
                        .bold()

                    Spacer()

                    Group {
                        TextField("Диспиплина", text: $viewModel.title)
                            .focused($focusedField, equals: .title)
                            .submitLabel(.next)
                        TextField("Описание", text: $viewModel.description, axis: .vertical)
                            .focused($focusedField, equals: .description)
                            .submitLabel(.next)
                            .multilineTextAlignment(.leading)
                            .submitLabel(.next)
                        TextField("Локация", text: $viewModel.adress)
                            .focused($focusedField, equals: .location)
                            .submitLabel(.next)
                        TextField("Правила игры", text: $viewModel.rules, axis: .vertical)
                            .focused($focusedField, equals: .rules)
                            .submitLabel(.done)
                        Text("Координаты: \(viewModel.location.latitude), \(viewModel.location.longitude)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .onSubmit {
                        switch focusedField {
                        case .title:
                            focusedField = .description
                        case .description:
                            focusedField = .location
                        case .location:
                            focusedField = .rules
                        default:
                            print("Creating account…")
                        }
                    }

                    MapPickerView {
                        location in
                        viewModel.location = location
                        showMapPicker = true
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .cornerRadius(20)
                }
            }
            Spacer()

            Button {
                viewModel.addEvent()
            } label: {
                Text("Создать событие")
                    .frame(maxWidth: .infinity)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .background(viewModel.canSubmit ? Color(.siriusBlue) : Color(.systemGray5))
                    .cornerRadius(20)
            }
            .disabled(!viewModel.canSubmit)
        }
        .padding()
    }
}
