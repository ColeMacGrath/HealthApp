//
//  DashboardView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct DashboardView: View {
    @Environment(DashboardViewModel.self) private var dashboardViewModel
    @Environment(TabBarViewModel.self) private var viewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        @Bindable var dashboardViewModel = dashboardViewModel
        @Bindable var viewModel = viewModel
        Group {
            if dashboardViewModel.isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                    Text("Loading health data...")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        if let errorMessage = dashboardViewModel.errorMessage {
                            PermissionsErrorView(message: errorMessage)
                                .padding(.horizontal)
                        }
                        
                        NutritionCard( proteinData: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.proteinData), carbsData: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.carbsData), fatData: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.fatData), totalCalories: dashboardViewModel.formatCalories(dashboardViewModel.totalCaloriesToday), goalCalories: "2,000")
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(Array(healthMetrics.enumerated()), id: \.offset) { _, metric in
                                HealthCard(metric: metric)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Overview")
        .navigationSubtitle("November 15, 2025")
        .toolbar {
            Button(action: {}) {
                Image(.profilePicture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
        }
        .sheet(isPresented: $viewModel.showInputSheet) {
            FoodInputSheet(dishDescription: $viewModel.dishDescription, selectedSuggestions: $viewModel.selectedSuggestions)
                .presentationDetents([.medium], selection: .constant(.medium))
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $dashboardViewModel.showPermissionModal) {
            HealthKitPermissionView(
                status: dashboardViewModel.authorizationStatus,
                onAuthorize: {
                    await dashboardViewModel.requestHealthKitAuthorization()
                },
                onOpenSettings: {
                    dashboardViewModel.openHealthSettings()
                }
            )
        }
        .task {
            dashboardViewModel.checkAuthorizationStatus()
            
            if dashboardViewModel.authorizationStatus.isAuthorized {
                await dashboardViewModel.loadHealthData()
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    await dashboardViewModel.checkAndReloadIfAuthorized()
                }
            }
        }
    }
    
    
    private var healthMetrics: [HealthMetric] {
        [
            HealthMetric(
                title: "Heart Rate",
                icon: "heart.fill",
                color: .red,
                currentValue: dashboardViewModel.formatHeartRate(dashboardViewModel.averageHeartRate),
                subtitle: "Average",
                data: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.heartRateData)
            ),
            HealthMetric(
                title: "Steps",
                icon: "figure.walk",
                color: .green,
                currentValue: dashboardViewModel.formatSteps(dashboardViewModel.totalStepsToday),
                subtitle: "Goal: 10,000",
                data: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.stepsData)
            ),
            HealthMetric(
                title: "Active Energy",
                icon: "flame.fill",
                color: .orange,
                currentValue: dashboardViewModel.formatCalories(dashboardViewModel.activeCaloriesData.last?.value ?? 0),
                subtitle: "Cal",
                data: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.activeCaloriesData)
            ),
            HealthMetric(
                title: "Sleep",
                icon: "bed.double.fill",
                color: .indigo,
                currentValue: dashboardViewModel.formatSleep(dashboardViewModel.lastNightSleep),
                subtitle: "Last night",
                data: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.sleepSessions)
            ),
            HealthMetric(
                title: "Weight",
                icon: "scalemass.fill",
                color: .purple,
                currentValue: dashboardViewModel.formatWeight(dashboardViewModel.weightData.last?.value ?? 0),
                subtitle: "Current",
                data: dashboardViewModel.convertToHealthDataPoint(dashboardViewModel.weightData)
            )
        ]
    }
}

#Preview {
    DashboardView()
        .environment(DashboardViewModel())
        .environment(TabBarViewModel())
}
