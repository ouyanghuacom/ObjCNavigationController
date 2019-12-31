Pod::Spec.new do |spec|
    spec.name     = 'ObjCNavigationController'
    spec.version  = '1.0.0'
    spec.license  = 'MIT'
    spec.summary  = 'Preferable navigation controller for me'
    spec.homepage = 'https://github.com/ouyanghuacom/ObjCNavigationController'
    spec.author   = { 'ouyanghuacom' => 'ouyanghua.com@gmail.com' }
    spec.source   = { :git => 'https://github.com/ouyanghuacom/ObjCNavigationController.git',:tag => "#{spec.version}" }
    spec.description = 'Preferable navigation controller for me.'
    spec.requires_arc = true
    spec.source_files = 'ObjCNavigationController/*.{h,m}'
    spec.ios.frameworks = 'UIKit'
    spec.ios.deployment_target = '8.0'
end