//
//  ProfileView.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 22.01.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    @FocusState var nameIsFocused: Bool
    
    
    var body: some View {
        VStack(spacing: 20) {
            userAvatar
            
            TextField("Name", text: $viewModel.nameTextField)
                .textFieldStyle(.roundedBorder)
                .focused($nameIsFocused)
            
            profileMenu
            
            Spacer()
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            nameIsFocused = false
        }
        .sheet(isPresented: $viewModel.isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image) {
                viewModel.saveAvatar()
            }
        }
    }
}

// MARK: - Additional views
extension ProfileView {
    private var userAvatar: some View {
        Button(action: {
            viewModel.toggleShowPhotoLibrary()
        }) {
            ZStack {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(100)
                
                if viewModel.imageIsLoading {
                    ProgressView()
                }
            }
        }
    }
    
    private var profileMenu: some View {
        HStack {
            Menu("Diet:") {
                ForEach(viewModel.userDiets, id: \.self) { diet in
                    Button(diet.rawValue) {
                        setDiet(diet)
                    }
                }
            }
            
            Spacer()
            
            Text(viewModel.currentDiet ?? "")
        }
    }
}

// MARK: - Actions
extension ProfileView {
    private func setDiet(_ diet: UserDiet) {
        viewModel.setDiet(diet)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
