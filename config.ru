# Load the environment
require_relative 'config/environment'
require_relative 'json_api'

# for automatically reloading application code
use Rack::Reloader,0

# Run JsonAPI
run JsonApi.new