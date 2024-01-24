//
//  ProfileViewModel.swift
//  RelevantRecipesApp
//
//  Created by Сергеев Александр on 23.01.2024.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    private let fileManager = LocaleFileManager.shared
    
    private let userAvatarName = "userAvatar"
    private let userAvatarFolderName = "user_avatars"
    @Published var isShowPhotoLibrary = false
    @Published var image = UIImage(named: "Person") ?? UIImage()
    @Published var imageIsLoading = true
    
    @AppStorage("userName") var nameTextField = ""
    @AppStorage("userDiet") var currentDiet: String?
    private(set) var userDiets: [UserDiet] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        getUserAvatar()
        createUserDiets()
    }
    
    
    private func getUserAvatar() {
        if let savedImage = fileManager.getImage(imageName: userAvatarName, folderName: userAvatarFolderName) {
            DispatchQueue.main.async { [weak self] in
                self?.image = savedImage
                self?.imageIsLoading = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.imageIsLoading = false
            }
        }
    }
    
    private func createUserDiets() {
        userDiets = UserDiet.allCases.map { $0 }
    }
    
    func saveAvatar() {
        guard !userAvatarName.isEmpty, !userAvatarFolderName.isEmpty else { return }

        fileManager.saveImage(image: image, imageName: userAvatarName, folderName: userAvatarFolderName)
    }
    
    func setDiet(_ diet: UserDiet) {
        currentDiet = diet.rawValue
    }
    
    func toggleShowPhotoLibrary() {
        DispatchQueue.main.async {
            self.isShowPhotoLibrary.toggle()
        }
    }
}
