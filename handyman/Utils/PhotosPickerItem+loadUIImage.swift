//
//  PhotosPickerItem+loadUIImage.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/15/25.
//

import PhotosUI
import SwiftUI

extension PhotosPickerItem {
    func loadUIImage() async -> UIImage? {
        if let data = try? await loadTransferable(type: Data.self), let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}
