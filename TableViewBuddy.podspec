Pod::Spec.new do |s|
  s.name         = "TableViewBuddy"
  s.version      = "0.5.0"
  s.summary      = "An easy way to configure the user interface with table view."

  s.homepage     = "https://github.com/hironytic/TableViewBuddy"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Hironori Ichimiya" => "hiron@hironytic.com" }

  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/hironytic/TableViewBuddy.git", :tag => "v#{s.version}" }

  s.source_files = "Pod/Classes/**/*"
  s.private_header_files = "Pod/Classes/internal/*.h"

  s.requires_arc = true
end
