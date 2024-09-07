require 'open-uri'
require 'stringio'

module Build
  class DatabaseBuilder

    def reset_data
      User.destroy_all
    end

    def create_users
      default_avatar_path = Rails.root.join('app/assets/images/default_avatar.png')
      (1..10).each do |i|
        @user = FactoryBot.build(:user)
        @user.avatar.attach(
          io: File.open(default_avatar_path),
          filename: 'default_avatar.png',
          content_type: 'image/png'
        )
        @user.save!
      end
      @user = User.last
      @user.first_name='Tom'
      @user.last_name='Cat'
      @user.email='tomcat@gmail.com'
      @user.password='password'
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
