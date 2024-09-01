module Build

  class DatabaseBuilder

    def reset_data
      User.destroy_all
    end

    def create_users
      (1..10).each { FactoryBot.create(:user) }
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
