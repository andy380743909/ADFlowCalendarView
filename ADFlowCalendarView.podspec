#
# Be sure to run `pod lib lint ADFlowCalendarView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'ADFlowCalendarView'
s.version          = '0.2.1'
s.summary          = 'A flexible calendar view with three modes Year mode, Month mode, and Week Mode'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
This maybe the most customizable calendar view with builtin three common display mode,Year mode, Month mode, and Week Mode.It's UICollectionView backed, mimix the classic UITableView Datasource delegate design.You can easily supply you custom Datasouce and delegate to customize the UI, add your additional feature to it.
DESC

s.homepage         = 'http://git.sankuai.com/projects/IOS/repos/adflowcalendarview/browse'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'cuipanjun' => 'cuipanjun@meituan.com' }
s.source           = { :git => 'ssh://git@git.sankuai.com/ios/adflowcalendarview.git', :tag => s.version.to_s }

s.ios.deployment_target = '7.0'

s.source_files = 'ADFlowCalendarView/Classes/**/*'

end
