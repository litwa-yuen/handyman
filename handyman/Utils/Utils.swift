//
//  Utils.swift
//  handyman
//
//  Created by Lit Wa Yuen on 11/13/25.
//
import UIKit

final class Utils {
    
    static let shared = Utils()
    
    private init() {}
    
    @MainActor
    func getTopViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        
        let root = windowScene?
            .windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController
        
        let controller = controller ?? root
        
        if let nav = controller as? UINavigationController {
            return getTopViewController(controller: nav.visibleViewController)
        }
        
        if let tab = controller as? UITabBarController,
           let selected = tab.selectedViewController {
            return getTopViewController(controller: selected)
        }
        
        if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        
        return controller
        
    }
}
