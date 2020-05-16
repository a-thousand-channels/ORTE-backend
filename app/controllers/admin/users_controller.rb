# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :set_admin_user, only: %i[show edit update destroy]

  def create
    @admin_user = User.new(admin_user_params)

    respond_to do |format|
      if @admin_user.save!
        format.html { redirect_to admin_users_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @admin_user }
      else
        format.html { render :new }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit
    @groups = if current_user.admin?
                Group.all
              else
                Group.by_user(current_user)
              end
  end

  def index
    @admin_users = User.by_group(current_user).order(:email).page params[:page]
  end

  def new
    @admin_user = User.new
    @groups = if current_user.admin?
                Group.all
              else
                Group.by_user(current_user)
              end
  end

  def show; end

  def update
    sanitized_params = admin_user_params
    sanitized_params.delete(:password) if sanitized_params[:password].blank?

    respond_to do |format|
      if @admin_user.update(sanitized_params)
        format.html { redirect_to admin_users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_user }
      else
        format.html { render :edit }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_user
    @admin_user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_user_params
    permitted_attributes = %i[email password group_id]
    permitted_attributes << :role if current_user.try(:admin?)
    params.require(:admin_user).permit(permitted_attributes)
  end
end
