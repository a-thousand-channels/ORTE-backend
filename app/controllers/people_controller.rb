# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: %i[edit update destroy]

  # GET /people or /people.json
  def index
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @people = @map.people
  end

  def new
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @person = Person.new
  end

  def edit; end

  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to people_url, notice: 'Person was successfully created.' }
        format.json { render :index, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to people_url, notice: 'Person was successfully updated.' }
        format.json { render :index, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @person.destroy
      respond_to do |format|
        format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to people_url, notice: 'Person could not be destroyed, since its connected to 1 or more annotations.' }
      end
    end
  end

  private

  def set_person
    @map = Map.sorted.by_user(current_user).friendly.find(params[:map_id])
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :info, :map_id)
  end
end
