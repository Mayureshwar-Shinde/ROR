module Api
  module V1
    class UsersController < ApplicationController
      rescue_from ActionController::UnpermittedParameters, with: :raise_error_if_unpermitted_params
      skip_before_action :verify_authenticity_token
      before_action :authenticate_admin!
      before_action :set_user, only: [:show, :update, :destroy]

      api :GET, '/v1/users', 'Index'
      description <<-EOS
        Retrieves a list of users. You can filter the results by providing any combination of the following query parameters:
        - `first_name`: Filter by first name.
        - `last_name`: Filter by last name.
        - `email`: Filter by email.

        Example:
        ```
        'GET /api/v1/users?first_name=John',
        'GET /api/v1/users?first_name=John&last_name=Doe',
        'GET /api/v1/users?email=john@example.com'
        ```
      EOS
      formats ['json']
      param :first_name, String, desc: 'Filter by first name', required: false
      param :last_name, String, desc: 'Filter by last name', required: false
      param :email, String, desc: 'Filter by email', required: false
      returns code: 200, desc: 'Returns a list of users' do
        param :id, :number, desc: 'User ID'
        param :first_name, String, desc: 'User first name'
        param :last_name, String, desc: 'User last name'
        param :email, String, desc: 'User email'
        param :created_at, Date, desc: 'Time of creation'
      end

      # show all users
      def index
        # users = User.all
        users = Api::V1::UsersQuery.new(params).call
        render json: users, each_serializer: UserSerializer
      end

      api :POST, '/v1/users', 'Create'
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
      # user new user
      def create
        outcome = CreateUser.run(user_params)
        if outcome.valid?
          render json: outcome.result, serializer: UserSerializer, status: :created
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      end

      api :GET, '/v1/users/:id', 'Show'
      formats ['json']
      param :id, :number, desc: 'User id', required: true
      returns code: 200, desc: 'Returns the details of a single user' do
        param :id, :number, desc: 'User id'
        param :first_name, String, desc: 'User first name'
        param :last_name, String, desc: 'User last name'
        param :email, String, desc: 'User email'
        param :created_at, Date, desc: 'Time of creation'
      end
      # show a particular user
      def show
        render json: @user, serializer: UserSerializer
      end

      api :PUT, '/v1/users/:id', 'Update'
      formats ['json']
      param :id, :number, desc: 'User id', required: true
      param :user, Hash, desc: 'User information', required: true do
        param :first_name, String, desc: 'User first name', required: false
        param :last_name, String, desc: 'User last name', required: false
        param :age, :number, desc: 'User age', required: false
        param :date_of_birth, String, desc: 'User date of birth', required: false
        param :email, String, desc: 'User email', required: false
        param :password, String, desc: 'User password', required: false
      end
      returns code: 200, desc: 'User updated successfully'
      returns code: 422, desc: 'Unprocessable entity'
      # update a existing user
      def update
        outcome = UpdateUser.run(user_params.merge(user: @user))
        if outcome.valid?
          render json: outcome.result, serializer: UserSerializer, status: :ok
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      end

      api :DELETE, '/v1/users/:id', 'Destroy'
      formats ['json']
      param :id, :number, desc: 'User id', required: true
      returns code: 204, desc: 'User deleted successfully'
      returns code: 422, desc: 'Unprocessable entity'
      # delete a user
      def destroy
        outcome = DeleteUser.run(user: @user)
        if outcome.valid?
          head :no_content
        else
          render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :age, :date_of_birth, :email, :password)
      end

      def raise_error_if_unpermitted_params(exception)
        render json: { error: exception.message }, status: :bad_request
      end
    end
  end
end
