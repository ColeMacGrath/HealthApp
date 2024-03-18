//
//  File.swift
//  HealthApp
//
//  Created by Cordova Garcia Moises Emmanuel on 29/12/23.
//

import Foundation
import SwiftUI
import Charts

struct GenericHealthData: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct LineChart: View {
    var healthRecords: [GenericHealthData]
    
    static var dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    var body: some View {
        Chart(self.healthRecords) { healthData in
            LineMark(x: .value("Month", healthData.date), y: .value("Value", healthData.value))
            
                .interpolationMethod(.cardinal)
        }
        .chartYScale(domain: [self.healthRecords.map { $0.value }.min() ?? 0.0, self.healthRecords.map { $0.value }.max() ?? 0.0])
        .foregroundStyle(.red)
    }
    
    
}


struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart(healthRecords: [])
    }
}
