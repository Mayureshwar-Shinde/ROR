module Build
  class DatabaseBuilder

    def reset_data
      User.destroy_all
    end

    def create_users
      (1..10).each { FactoryBot.create(:user) }
      @user = User.last
      @user.first_name = 'Tom'
      @user.last_name = 'Cat'
      @user.email = 'tomcat@gmail.com'
      @user.save!
    end

    def execute
      reset_data
      create_users
    end

    def run
      execute
    end

  end
end
