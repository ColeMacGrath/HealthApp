//
//  AddFoodView.swift
//  HealthApp
//
//  Created by Moises Cordova on 11/15/2025.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(AddFoodViewModel.self) private var addFoodViewModel
    
    var body: some View {
        @Bindable var addFoodViewModel = addFoodViewModel
        
        ZStack {
            VStack {
                if let selectedImage = addFoodViewModel.selectedImage {
                    VStack(spacing: 16) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 4)
                        
                        HStack(spacing: 16) {
                            Button(role: .destructive) {
                                addFoodViewModel.selectedImage = nil
                            } label: {
                                Label("Remove", systemImage: "trash")
                                    .font(.subheadline)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.red.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Button {
                                Task {
                                    await addFoodViewModel.processFoodImage()
                                }
                            } label: {
                                Label("Analyze Food", systemImage: "sparkles")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.blue.gradient)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding()
                } else {
                    ContentUnavailableView {
                        Label("No Photo Selected", systemImage: "photo.badge.plus")
                    } description: {
                        Text("Add a photo of your meal to get started")
                    }
                }
                
                Spacer()
                
                HStack {
                    TextField("Add notes about the meal...", text: $addFoodViewModel.messageText, axis: .vertical)
                        .lineLimit(1...6)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        }
                    
                    Button {
                        addFoodViewModel.showImageSourceMenu = true
                    } label: {
                        Image(systemName: addFoodViewModel.selectedImage == nil ? "plus.circle.fill" : "photo.badge.plus.fill")
                            .font(.title)
                            .foregroundStyle(addFoodViewModel.selectedImage == nil ? .blue : .green)
                    }
                }
                .padding()
            }
            
            if addFoodViewModel.isProcessing {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        
                        Text(addFoodViewModel.processingMessage)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(40)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    }
                }
            }
        }
        .navigationTitle("Add Meal")
        .sheet(isPresented: $addFoodViewModel.showImageSourceMenu) {
            ImageSourceMenuView(
                showMenu: $addFoodViewModel.showImageSourceMenu,
                showCamera: $addFoodViewModel.showCamera,
                showPhotos: $addFoodViewModel.showPhotos
            )
            .presentationDetents([.fraction(0.25)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $addFoodViewModel.showCamera) {
            CameraView(selectedImage: $addFoodViewModel.selectedImage)
        }
        .sheet(isPresented: $addFoodViewModel.showPhotos) {
            PhotosPickerView(selectedImage: $addFoodViewModel.selectedImage)
        }
        .sheet(isPresented: $addFoodViewModel.showResults) {
            if let nutritionData = addFoodViewModel.nutritionData {
                NutritionResultsView(
                    nutritionData: nutritionData,
                    onSave: {
                        await addFoodViewModel.saveToHealthKit()
                        addFoodViewModel.showResults = false
                        addFoodViewModel.resetForNewEntry()
                    },
                    onCancel: {
                        addFoodViewModel.showResults = false
                    }
                )
            }
        }
        .alert("Error", isPresented: $addFoodViewModel.showError) {
            Button("OK") {
                addFoodViewModel.showError = false
            }
        } message: {
            Text(addFoodViewModel.errorMessage)
        }
    }
}

#Preview {
    NavigationStack {
        AddFoodView()
            .environment(AddFoodViewModel())
    }
}

