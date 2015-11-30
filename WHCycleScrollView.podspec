
Pod::Spec.new do |s|



  s.name         = "WHCycleScrollView"
  s.version      = "1.0.0"
  s.summary      = "A cycle scrollView"

  s.description  = <<-DESC
  			A cycle scrollView,Support web image and local image together
                   DESC
  s.homepage     = "https://github.com/kiwh77/WHCycleScrollView"
  s.license      = "MIT"
  s.author             = { "kiwh77" => "308801737@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/kiwh77/WHCycleScrollView.git", :tag => "1.0.0"}
  s.source_files  =  "WHCycleScrollView/WHCycleScrollView/WHCycleScrollView.{h,m}"
  # s.exclude_files = "WHCycleScrollView/WHCycleScrollView/WHCycleScrollView.{h,m}"

  s.requires_arc = true

  s.dependency "SDWebImage", "~> 3.7.3"

end
