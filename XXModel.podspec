Pod::Spec.new do |s|
  s.name             = 'XXModel'
  s.version          = '1.1.0'
  s.summary          = '超轻量级字典转模型框架.'

  s.description      = <<-DESC
  自用,超轻量级字典转模型框架
                       DESC

  s.homepage         = 'https://github.com/rdxer/XXModel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LXF' => 'rdxer@foxmail.com' }
  s.source           = { :git => 'https://github.com/rdxer/XXModel.git', :tag => s.version.to_s }


  s.ios.deployment_target = '7.0'
  s.source_files = 'XXModel/Classes/XXModel.h'
#  s.public_header_files = 'XXModel/Classes/XXModel.h'


  s.subspec 'XXProperty' do |ss|
    ss.source_files = 'XXModel/Classes/XXProperty/**/*'
#    ss.public_header_files = 'XXModel/Classes/XXProperty/NSObject+XXProperty.h'
  end

  s.subspec 'XXParseModel' do |ss|
    ss.dependency 'JRSwizzle', '~> 1.0'
    ss.dependency 'XXModel/XXProperty'
    ss.source_files = 'XXModel/Classes/XXParseModel/**/*'
# ss.public_header_files = 'XXModel/Classes/XXParseModel/NSObject+XXParseModel.h'
  end

end
