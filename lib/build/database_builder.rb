require 'open-uri'
require 'stringio'

module Build
  class DatabaseBuilder

    def reset_data
      Appointment.destroy_all
      Note.destroy_all
      Communication.destroy_all
      Token.destroy_all
      Case.destroy_all
      User.destroy_all
    end

    def create_case_managers
      default_avatar_path = Rails.root.join('app/assets/images/case_manager_avatar.png')
      (1..10).each do
        FactoryBot.create(:case_manager)
        (1..4).each do
          @case = FactoryBot.build(:case)
          @case.user_id = User.last.id
          @case.save
        end
      end
      User.case_manager.last.update(first_name:'Tom',last_name:'Cat',email:'tomcat@gmail.com')
    end

    def create_dispute_analysts
      default_avatar_path = Rails.root.join('app/assets/images/dispute_analyst_avatar.png')
      (1..10).each { FactoryBot.create(:dispute_analyst) }
      User.dispute_analyst.last.update(first_name:'Jerry',last_name:'Mouse',email:'jerrymouse@gmail.com')
    end

    def execute
      reset_data
      create_case_managers
      create_dispute_analysts
    end

    def run
      execute
    end

  end
end
