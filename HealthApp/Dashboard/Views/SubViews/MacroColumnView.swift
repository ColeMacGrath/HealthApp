//
//  MacroColumnView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI
import Charts

struct MacroColumn: View {
    let title: String
    let value: String
    let target: String
    let color: Color
    let data: [HealthDataPoint]
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Chart {
                ForEach(data) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.date),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(color)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 30)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(target)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
