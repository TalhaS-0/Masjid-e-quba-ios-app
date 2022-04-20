//
//  RootViewControllerFactory.swift
//  Masjid-e-Quba
//
//  Created by Muhammad Shahrukh on 20/04/2022.
//

import Foundation
import UIKit

class RootViewControllerFactory {

  var rootViewController: UIViewController {
    if shouldDisplayOnboardingScreen() {
      return generateOnboardingScreen()
    } else {
      return generateHomeScreen()
    }
  }

  private func shouldDisplayOnboardingScreen() -> Bool {
    // Your logic to decide whether you should display it or not.
      let isFirstTime = UserDefaults.standard.bool(forKey: IS_FIRST_TIME)
      if !isFirstTime{
          return true
      }else{
          return false
      }
  }

  func generateOnboardingScreen() -> UIViewController {
    // Load it from your storyboard
      let Storyboard  = UIStoryboard(name: "Main", bundle: nil)
      let vc = Storyboard.instantiateViewController(withIdentifier: "WelcomeVC")
      return vc
  }

  func generateHomeScreen() -> UIViewController {
    // Load it programmatically
      let Storyboard  = UIStoryboard(name: "Main", bundle: nil)
      let vc = Storyboard.instantiateViewController(withIdentifier: "HomeNC")
      return vc
  }

}
