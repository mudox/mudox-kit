Pod::Spec.new do |s|
  #
  # Pod Basic Info
  #

  s.name             = 'MudoxKit'
  s.version          = '0.1.0'
  s.summary          = 'My Cocoa (Touch) extension library'

  s.description      = <<-DESC
  My Cocoa (Touch) extension library.
  DESC

  #
  # Author Info
  #

  s.homepage         = 'https://github.com/mudox/mudox-kit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Mudox'
  s.source           = { :git => 'https://github.com/mudox/mudox-kit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  #
  # Pod Payload
  #

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Source/Core/**/*'

    core.dependency 'JacKit'

    core.dependency 'RxSwift'
    core.dependency 'RxCocoa'
    core.dependency 'RxSwiftExt'
  end

  s.subspec 'ActivityCenter' do |ss|
    ss.source_files = 'Source/ActivityCenter/**/*.{swift,h,m}'
    ss.dependency 'RxSwift'
    ss.dependency 'RxCocoa'
  end

  s.subspec 'MBProgressHUD' do |ss|
    ss.source_files = 'Source/MBProgressHUD/**/*.swift'
    ss.dependency 'MBProgressHUD'
    ss.resource_bundle = { 'mbp' => 'Source/MBProgressHUD/mbp.xcassets' }
  end

  s.subspec 'SVProgressHUD' do |ss|
    ss.source_files = 'Source/SVProgressHUD/**/*'
    ss.dependency 'SVProgressHUD'
  end

  s.subspec 'NVActivityIndicatorView' do |ss|
    ss.source_files = 'Source/NVActivityIndicatorView/**/*'
    ss.dependency 'NVActivityIndicatorView'
  end

  s.subspec 'ObjectiveC' do |ss|
    ss.source_files = 'Source/ObjectiveC/**/*'
  end

  s.subspec 'Eureka' do |ss|
    ss.source_files = 'Source/Eureka/**/*'
    ss.dependency 'Eureka'
  end

  s.subspec 'All' do |ss|
    ss.dependency 'MudoxKit/Core'
    ss.dependency 'MudoxKit/ActivityCenter'
    ss.dependency 'MudoxKit/MBProgressHUD'
    ss.dependency 'MudoxKit/SVProgressHUD'
    ss.dependency 'MudoxKit/NVActivityIndicatorView'
    ss.dependency 'MudoxKit/ObjectiveC'
    ss.dependency 'MudoxKit/Eureka'
  end

end
