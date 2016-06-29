Pod::Spec.new do |s|
  s.name      = 'PullToRefresh'
  s.version   = '2.0.0'
  s.summary   = 'Simple and highly customizable pull to refresh view.'
  s.homepage  = 'https://github.com/soffes/sspulltorefresh'
  s.author    = { 'Sam Soffes' => 'sam@soff.es' }
  s.source    = { :git => 'https://github.com/soffes/sspulltorefresh.git', :tag => "v#{s.version}" }
  s.license   = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.source_files = 'Sources/*.swift'
  s.description = 'PullToRefresh is a simple and highly customizable pull to refresh view. It lets you implement a content view separate so you don\'t have to hack up the pulling logic everything you want to customize the appearance.'
  s.platform = :ios, '7.0'
end
