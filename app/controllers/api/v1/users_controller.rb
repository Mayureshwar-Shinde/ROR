module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      # API documentation using apipie
      def_param_group :user_attributes do
        param :id, :number, desc: 'User ID'
        param :first_name, String, desc: 'User first name'
        param :last_name, String, desc: 'User last name'
        param :email, String, desc: 'User email'
        param :created_at, Date, desc: 'Time of creation'
      end

      api :GET, '/api/v1/users', 'Index'
      description 'Retrieves a list of users'
      formats ['json']
      returns code: 200, desc: 'Returns a list of users' do
        param_group :user_attributes
      end
      # show all users
      def index
        @users = User.all
        render json: @users, each_serializer: UserSerializer
      end

      api :POST, '/api/v1/users', 'Create'
      formats ['json']
      param :user, Hash, desc: 'User information', required: true do
        param :first_name, String, desc: 'User first name', required: true
        param :last_name, String, desc: 'User last name', required: true
        param :age, :number, desc: 'User age', required: true
        param :date_of_birth, String, desc: 'User date of birth', required: true
        param :email, String, desc: 'User email', required: true
        param :password, String, desc: 'User password', required: true
      end
      returns code: 201, desc: 'User created successfully'
      returns code: 422, desc: 'Unprocessable entity'
      # create new user
      def create
        outcome = CreateUser.run(params.fetch(:user, {}))
        if outcome.valid?
          render json: outcome.result, serializer: UserSerializer, status: :created
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      end

      api :GET, '/api/v1/users/:id', 'Show'
      formats ['json']
      param :id, :number, desc: 'User id', required: true
      returns code: 200, desc: 'Returns the details of a single user' do
        param_group :user_attributes
      end
      returns code: 404, desc: 'User not found'
      # show a particular user
      def show
        @user = User.find_by(id: params[:id])
        if @user
          render json: @user, serializer: UserSerializer
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      api :PUT, '/api/v1/users/:id', 'Update'
      formats ['json']
      param :id, :number, desc: 'User id', required: true
      param :user, Hash, desc: 'User information', required: true do
        param :first_name, String, desc: 'User first name'
        param :last_name, String, desc: 'User last name'
        param :age, :number, desc: 'User age'
        param :date_of_birth, String, desc: 'User date of birth'
        param :email, String, desc: 'User email'
        param :password, String, desc: 'User password'
      end
      returns code: 200, desc: 'User updated successfully'
      returns code: 422, desc: 'Unprocessable entity'
      # update a existing user
      def update
        @user = User.find_by(id: params[:id])
        outcome = UpdateUser.run(params.fetch(:user, {}).merge(user: @user))
        if outcome.valid?
          render json: @user, status: :ok
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      end

    end
  end
end
