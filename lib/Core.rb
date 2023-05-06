require 'yaml'

require_relative 'Helpers/Dependencies'
require_relative 'Classes/Dependencies'
require_relative 'Services/Dependencies'
require_relative 'Menus/Dependencies'

settings = YAML.load_file('./config.yml')['development']
TestService.init settings
RunTestMenu.init settings
