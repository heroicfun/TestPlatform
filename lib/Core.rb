require_relative 'Helpers/EnumerableHelper'
require_relative 'Menus/ManagerMenu'
require_relative 'Menus/QuestionMenu'
require_relative 'Menus/TestMenu'
require_relative 'Services/QuestionService'
require_relative 'Services/TestService'
require 'yaml'

settings = YAML.load_file('./config.yml')
TestService.init settings['development']