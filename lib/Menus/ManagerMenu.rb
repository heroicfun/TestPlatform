class ManagerMenu
  def self.run
    manager_menu_loop
  end

  private

  def self.manager_menu_loop
    while true
      puts 'Select the command: 1-Create test, 2-Edit test, 3-Run test'
      option = gets.chomp
      case option.to_i
        when 1
          test = Test.new
          puts 'Enter test name:'
          test.name = gets.chomp
          TestMenu.make_test_name_valid test
          TestMenu.run test
        when 2
          begin
            puts 'Awaible tests:'
            test_names = TestService.get_test_names
            display_numbered test_names
            puts 'Select test number:'
            selected_test_index = gets.chomp.to_i - 1
            if selected_test_index > -1 && selected_test_index < test_names.length
              test_name = test_names[selected_test_index]
              test = TestService.load_test test_name
              TestMenu.run test, test_name
            else
              puts 'Invalid value entered!'
            end
          rescue => exception
            puts "An error occurred during test editing! #{exception}"
          else
            puts 'Test edited successfully.'
          end
        when 3
          begin
            puts 'Awaible tests:'
            test_names = TestService.get_test_names
            display_numbered test_names
            puts 'Select test number:'
            selected_test_index = gets.chomp.to_i - 1
            if selected_test_index > -1 && selected_test_index < test_names.length
              test = TestService.load_test test_names[selected_test_index]
              RunTestMenu.run test
              puts 'Test completed successfully.'
            else
              puts 'Invalid value entered!'
            end
          rescue => exception
            puts "An error occurred during test passing! #{exception}"
          end
        else
          puts 'Goodbye!'
          exit 0
      end
    end
  end
end
