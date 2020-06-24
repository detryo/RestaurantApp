# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher', '~> 5.0'
  pod 'CodableFirebase'
end

target 'Restaurant' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Restaurant
  shared_pods
  pod 'Stripe'
  pod 'Alamofire'

end

target 'RestaurantAdmin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RestaurantAdmin
  shared_pods

end
