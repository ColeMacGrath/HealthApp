//
//  MetricCardView.swift
//  HealthAppUI
//
//  Created by Moisés Córdova on 2024-11-03.
//

import SwiftUI
import Charts

struct MetricCardView: View {
    var title: String
    var value: String
    var unit: String?
    var icon: String
    var color: Color
    var showGraph: Bool = false
    var data: [ChartData] = []
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action){
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.tertiarySystemGroupedBackground))
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(color)
                        Text(title)
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    HStack {
                        Text(value)
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        if let unit {
                            Text(unit)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if showGraph && !data.isEmpty {
                        Chart(data.indices, id: \.self) { index in
                            LineMark(
                                x: .value("Index", index),
                                y: .value("Value", data[index].value)
                            )
                            .foregroundStyle(color)
                        }
                        .chartYScale(domain: [0, data.map { $0.value }.max() ?? 100])
                        
                    }
                    
                }
                .padding()
            }
        }
    }
}


#Preview {
    MetricCardView(title: "Title", value: "100", icon: "", color: .red, action: {})
}
