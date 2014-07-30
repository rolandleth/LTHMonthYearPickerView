Pod::Spec.new do |s|
  s.name         = "LTHMonthYearPickerView"
  s.version      = "1.3.4"
  s.summary      = "Path 2.0 menu using CoreAnimation :)."
  s.homepage     = "https://github.com/rolandleth/LTHMonthYearPickerView"
  s.license      = 'MIT'
  s.source       = { :git => "https://github.com/rolandleth/LTHMonthYearPickerView.git" }
  s.platform     = :ios
  s.compiler_flags = '-fobjc-arc'
  s.default_subspec = 'ARC'

  s.subspec 'ARC' do |arc|
    arc.source_files = 'LTHMonthYearPickerView/*.{h,m}'
    arc.requires_arc = true
    arc.compiler_flags = ' -fobjc-arc'
  end
end