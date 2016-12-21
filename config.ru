app_dir = File.realdirpath 'app', __dir__
$LOAD_PATH.unshift app_dir
require 'videochat_app'

run VideochatApp
