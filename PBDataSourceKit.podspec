#
# Data source kit
#

Pod::Spec.new do |s|
  s.name             = "PBDataSourceKit"
  s.version          = "0.1.0"
  s.summary          = "PBDataSourceKit."

  s.description      = <<-DESC
  Abstract data provider for UITableView and UICollectionView 
                       DESC

  s.homepage         = "https://github.com/pblondin/PBDataSourceKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Philippe Blondin" => "info@philippeblondin.ca" }
  s.source           = { :git => "https://github.com/pblondin/PBDataSourceKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/PhilippeBlondin'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PBDataSourceKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'MagicalRecord'

  s.framework    = 'CoreData'
  s.prefix_header_contents = <<-EOS
    #import <CoreData/CoreData.h>
    #import <MagicalRecord/MagicalRecord.h>
EOS

end
