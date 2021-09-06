class ExercisesController < ApplicationController
    before_action :authorize, :current_user
    # before_action :authorize, only: [:show, :create, :update, :destroy]

    #----------GET /exercises (exercises#index)------------   
    def index
        if session[:user_id]
            exercises = show_exercises
            render json: exercises, include: [:workout]
        end
    end

    #-----------POST /exercises (exercises#create)------------
    def create
        if session[:user_id]
            exercise = show_exercises.create!(exercise_params)
            render json: exercise, status: :created
        else
            render json: { errors: ['You must be logged in to create a exercise'] }, status: :unauthorized
        end
    end

    #-----------GET /exercises/:id (exercises#show)-------------
    def show
        if session[:user_id]
            exercise = find_exercise
            render json: exercise, include: [:workout]
        end
    end

    #-----------PATCH /exercises/:id (exercises#update)-------------
    def update
        exercise = Exercise.find(params[:id])
        if exercise[:user_id] == session[:user_id]
            exercise.update(name: exercise_params[:name], calories: exercise_params[:calories], duration: exercise_params[:duration])
            render json: exercise, status: :accepted
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end
    end

    #----------DELETE /exercises/:id (exercises#destroy)---------------
    def destroy
        if session[:user_id]
            exercise = find_exercise
            exercise.destroy
            head :no_content
        end
    end

    private

    def show_exercises
        @current_user.exercises
    end

    def find_exercise
        @current_user.exercises.find(params[:id])
    end
    
    def exercise_params
        params.permit(:user_id, :workout_id, :name, :calories, :duration)
    end

    def authorize
        render json: { errors: ['Not authorized'] }, status: :unauthorized unless session.include? :user_id
    end
end
