//
//  HealthCardView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI
import Charts

struct HealthCard: View {
    let metric: HealthMetric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: metric.icon)
                    .font(.title3)
                    .foregroundStyle(metric.color)
                
                Spacer()
                
                Text(metric.currentValue)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(metric.color)
                
            }
            
            Text(metric.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Chart {
                ForEach(metric.data) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.date),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(metric.color.gradient)
                    
                    AreaMark(
                        x: .value("Time", dataPoint.date),
                        y: .value("Value", dataPoint.value)
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: [
                                metric.color.opacity(0.3),
                                metric.color.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .chartYAxis(.hidden)
            VStack {
                Text(metric.currentValue)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let subtitle = metric.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}
