//
//  AuthService.swift
//  Weather Application
//
//  Created by Дмитрий Пономарев on 24.06.2023.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceProtocol: AnyObject {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}

final class VKAuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId = "51687845"
    private let vkSdk: VKSdk
    weak var delegate: AuthServiceProtocol?
    var token: String? {
        return VKSdk.accessToken().accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    // MARK: - determination of current session
    
    public func wakeUpSession() {
        
        let scope = ["friends,wall"]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
                self.delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
            } else {
                print("auth problems, state \(state) error \(String(describing: error))")
                delegate?.authServiceDidSignInFail()
            }
        }
    }
    
    // MARK: - VKSdkDelegate
    
    public func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    public func vkSdkUserAuthorizationFailed() {
    }
    
    // MARK: VkSdkUIDelegate
    
    public func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(controller)
    }
    
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
    }
}
