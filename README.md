# This is a demo app for OTP login.

# Architecture of the demo app

    * MVVM-C
    The app is structured based on the Model View View Model architectural pattern. And the coordinator pattern is adopted
    to control the application navigation flow and inject dependencies into View controllers.
    * Reactive programming
    The RxSwift framework is used to do the data binding between views and view models.

# 3rd party libraries and frameworks 

The demo project uses CocoaPods to manage the dependencies, please go to the project fonder and run `pod install` to install the dependencies, then open tthe .xcworkspace file to view the project.

## Dependencies:

    * RxSwift
    RxSwift is a reactive programming framework for data binding.
    * RxCocoa
    RxCocoa is part of the RxSwift framework which adds the reactive support for lots of UI classes of the iOS SDK.
    * RxTest
    RxTest is a RxSwift test framework.
    * RxBlocking
    RxTest is another RxSwift test framework.
    * lottie-ios
    Animation library.