//
//  FullScreenGraphView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-28.
//

import SwiftUI
import Charts
import HealthKit

struct FullScreenGraphView: View {
    @Environment(GraphModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        List {
            Section {
                Picker("Select Search Type", selection: $model.groupedBy) {
                    ForEach(GroupedBy.allCases) { group in
                        Text(group.rawValue.capitalized).tag(group)
                    }
                }
                .onChange(of: model.groupedBy) {
                    Task {
                        await model.fetchData()
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Chart {
                    ForEach(model.healthData) { data in
                        if let startDate = data.startDate,
                           let value = data.value {
                            LineMark(
                                x: .value("Date", startDate),
                                y: .value("Value", value)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        }
                    }
                }
                .frame(height: 400.0)
            }.listRowBackground(Color.clear)
            
            Section {
                ForEach(model.healthData) { data in
                    let text = model.getFormatedTitleFor(value: data.value)
                    SubtitleRowView(title: text.title, caption: text.caption, subtitle: data.startDate?.dayMonthYearAndHourFormat())
                }
            }
        }
        .navigationTitle(model.formatedHealthMetricTitle())
        .onAppear {
            Task {
                await model.fetchData()
            }
        }
    }
    
    
}

#Preview {
    NavigationStack {
        FullScreenGraphView()
            .environment(GraphModel(hkObjectType: HKQuantityType.quantityType(forIdentifier: .stepCount)!, healthKitManager: HealthKitManager()))
    }
}
