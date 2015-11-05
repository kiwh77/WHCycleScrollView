Pod::Spec.new do |s|
  s.name         = "WHCycleScrollView"
  s.version      = "1.0.0"
  s.homepage     = "https://github.com/kiwh77/WHCycleScrollView"
  s.summary      = "A cycle view on iOS"
  s.license      = { :type => 'MIT' }
  s.author       = { "kiwh" => "308801737@qq.com" }
  s.requires_arc = true	
  s.platform = :ios, '7.0'
  s.source       = { :git => "https://github.com/kiwh77/WHCycleScrollView.git", :tag => s.version.to_s }
  s.source_files = 'WHCycleScrollView/**/*'
  s.dependency "SDWebImage", "~> 3.9.3"

end
