//
//  EditBookView.swift
//  CRUD SwiftData
//
//  Created by Israel Manzo on 2/8/25.
//

import SwiftUI

struct EditBookView: View {
    @State var status: Status = .onShelf
    @State var rating: Int?
    @State var title = ""
    @State var author = ""
    @State var summary = ""
    @State var dateAdded: Date = .distantPast
    @State var dateStarted: Date = .distantPast
    @State var dateCompleted: Date = .distantPast
    var body: some View {
        HStack {
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr)
                        .tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Date added")
                }
                if  status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, displayedComponents: .date)
                    } label: {
                        Text("Date started")
                    }
                }
                
                if  status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, displayedComponents: .date)
                    } label: {
                        Text("Date completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if newValue == .onShelf {
                    dateStarted = .distantPast
                    dateCompleted = .distantPast
                } else if newValue == .inProgress && oldValue == .completed {
                    dateCompleted = .distantPast
                } else if newValue == .inProgress && oldValue == .onShelf {
                    dateStarted = .now
                } else if newValue == .completed && oldValue == .onShelf {
                    dateCompleted = .now
                    dateStarted = dateAdded
                } else {
                    dateCompleted = .now
                }
            }
            Divider()
        }
    }
}

#Preview {
    EditBookView()
}
