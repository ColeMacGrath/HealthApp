//
//  DashboardView.swift
//  HealthApp
//
//  Created by Moisés Córdova on 2024-10-21.
//

import SwiftUI
import Charts
import HealthKit

struct DashboardView: View {
    @Environment(LoginModel.self) private var model
    @State private var showProfileView: Bool = false
    @State private var path = NavigationPath()
    @ObservedObject var viewModel: DashboardModel
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            if viewModel.showSettingsAlert {
                FullScreenMessageView(
                    image: Image(systemName: "heart.fill"),
                    title: "HealthApp has not required permissions",
                    description: "To ensure a correct experience, HealthApp needs access to read information from Apple Health",
                    additionalInfo: "Navigate to Sharing → Apps → HealthApp and enable permissions",
                    buttonText: "Give Permissions",
                    buttonAction: {
                        viewModel.healthKitManager.openHealthApp()
                    }
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        MetricCardView(title: "Steps", value: "\(viewModel.stepsCount ?? 0)", unit: "steps", icon: "figure.walk", color: .purple, action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.quantityType(forIdentifier: .stepCount)) else { return }
                            path.append(wrapper)
                        })
                        MetricCardView(title: "Distance", value: "\((Int((viewModel.distance ?? 0.0) / 1000)))", unit: "km", icon: "ruler.fill", color: .mint, action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)) else { return }
                            path.append(wrapper)
                        })
                    }.padding(.top)
                    
                    LazyVGrid(columns: [GridItem(.flexible())]) {
                        MetricCardView(title: "Heart Rate", value: "\(viewModel.heartRate ?? 0)", unit: "bpm", icon: "heart.fill", color: .red, showGraph: true, data: sampleHeartRateData(), action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.quantityType(forIdentifier: .heartRate)) else { return }
                            path.append(wrapper)
                        })
                    }
                    
                    LazyVGrid(columns: columns) {
                        MetricCardView(title: "Sleep", value: "\(viewModel.sleepHours ?? 0)", unit: "h", icon: "bed.double.fill", color: .orange, showGraph: true, data: sampleSleepData(), action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.categoryType(forIdentifier: .sleepAnalysis)) else { return }
                            path.append(wrapper)
                        })
                        MetricCardView(title: "Weight", value: "\(Int(viewModel.weight ?? 0.0))", unit: "kg", icon: "figure", color: .green, showGraph: true, data: sampleSleepData(), action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.quantityType(forIdentifier: .bodyMass)) else { return }
                            path.append(wrapper)
                        })
                        MetricCardView(title: "Calories Burned", value: "\(viewModel.calories ?? 0)", unit: "kcal", icon: "flame.fill", color: .pink, action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)) else { return }
                            path.append(wrapper)
                        })
                        MetricCardView(title: "Last ingested food", value: "Salad", icon: "fork.knife", color: .indigo, action: {
                            guard let wrapper = HKObjectTypeWrapper.from(HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)) else { return }
                            path.append(wrapper)
                        })
                    }
                    
                }
                .padding(.horizontal)
                .navigationTitle("Allison Doe")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        VStack {
                            Text(Date().monthDayYear)
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showProfileView = true
                        } label: {
                            Image(.profile)
                                .circularImageStyle(color: .cyan)
                                .frame(width: 35)
                        }
                    }
                }
                .navigationDestination(for: HKObjectTypeWrapper.self) { wrapper in
                    if let hkObjectType = wrapper.toHKObjectType() {
                        FullScreenGraphView()
                            .environment(GraphModel(hkObjectType: hkObjectType, healthKitManager: viewModel.healthKitManager))
                    }
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView()
                        .environment(model)
                }
            }
        }.onAppear {
            Task { await viewModel.fetchData() }
        }
        
    }
    
    func sampleHeartRateData() -> [ChartData] {
        [ChartData(value: 60), ChartData(value: 65), ChartData(value: 40), ChartData(value: 92), ChartData(value: 69)]
    }
    
    func sampleSleepData() -> [ChartData] {
        [ChartData(value: 5), ChartData(value: 8), ChartData(value: 7), ChartData(value: 6), ChartData(value: 8)]
    }
    
}

#Preview {
    DashboardView(viewModel: DashboardModel())
        .environment(LoginModel())
}

struct HKObjectTypeWrapper: Codable, Hashable {
    let identifier: String
    let type: ObjectType
    
    enum ObjectType: String, Codable {
        case quantityType
        case categoryType
    }
    
    // Factory method to create a wrapper from HKObjectType
    static func from(_ objectType: HKObjectType?) -> HKObjectTypeWrapper? {
        guard let objectType = objectType else { return nil }
        if let quantityType = objectType as? HKQuantityType {
            return HKObjectTypeWrapper(identifier: quantityType.identifier, type: .quantityType)
        } else if let categoryType = objectType as? HKCategoryType {
            return HKObjectTypeWrapper(identifier: categoryType.identifier, type: .categoryType)
        }
        return nil
    }
    
    // Convert to HKObjectType
    func toHKObjectType() -> HKObjectType? {
        switch type {
        case .quantityType:
            let quantityTypeIdentifier = HKQuantityTypeIdentifier(rawValue: identifier)
            return HKQuantityType.quantityType(forIdentifier: quantityTypeIdentifier)
        case .categoryType:
            let categoryTypeIdentifier = HKCategoryTypeIdentifier(rawValue: identifier)
            return HKCategoryType.categoryType(forIdentifier: categoryTypeIdentifier)
        }
    }
    
    // Convert to HKQuantityTypeIdentifier if possible
    func toHKQuantityTypeIdentifier() -> HKQuantityTypeIdentifier? {
        return type == .quantityType ? HKQuantityTypeIdentifier(rawValue: identifier) : nil
    }
}
