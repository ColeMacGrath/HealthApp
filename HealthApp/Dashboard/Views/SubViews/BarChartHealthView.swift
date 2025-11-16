//
//  BarChartHealthView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI
import Charts

struct BarChartHealthCard: View {
    let metric: HealthMetric
    let showGoalProgress: Bool
    let goalValue: Double?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: metric.icon)
                    .font(.title3)
                    .foregroundStyle(metric.color)
                
                Spacer()
                
                if let goalValue = goalValue, let currentVal = Double(metric.currentValue.replacingOccurrences(of: ",", with: "")) {
                    Image(systemName: currentVal >= goalValue ? "checkmark.circle.fill" : "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(metric.color)
                }
            }
            
            Text(metric.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(metric.currentValue)
                .font(.title)
                .fontWeight(.bold)
            
            if let subtitle = metric.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if showGoalProgress, let goalValue = goalValue, let currentVal = Double(metric.currentValue.replacingOccurrences(of: ",", with: "")) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(metric.color.opacity(0.2))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(metric.color)
                            .frame(width: geometry.size.width * min(currentVal / goalValue, 1.0))
                    }
                }
                .frame(height: 8)
            } else {
                Chart {
                    ForEach(metric.data) { dataPoint in
                        BarMark(
                            x: .value("Time", dataPoint.date),
                            y: .value("Value", dataPoint.value)
                        )
                        .foregroundStyle(metric.color.opacity(0.3 + (dataPoint.value / (metric.data.map(\.value).max() ?? 1.0)) * 0.7))
                        .cornerRadius(2)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 30)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}
