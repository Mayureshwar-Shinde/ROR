module Build
  class DatabaseBuilder
    def reset_data
      Case.destroy_all
      User.destroy_all
    end

    def create_data
      (1..10).each { FactoryBot.create(:case) }
      User.case_manager.last.update(first_name: 'Tom', last_name: 'Cat', email: 'tomcat@gmail.com')
      User.dispute_analyst.last.update(first_name: 'Jerry', last_name: 'Mouse', email: 'jerrymouse@gmail.com')
    end

    def execute
      reset_data
      create_data
    end

    def run
      execute
    end
  end
end
