$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Countdown'

  # You'll need to set your own certificate here to install on a device
  # app.codesign_certificate = <some cert name>

  app.device_family = [:iphone]
  app.icons = ['Icon']
end

task 'spec' do
  # Close the simulator after running specs
  sh "osascript -e 'tell application \"iphone simulator\" to quit'"
end
