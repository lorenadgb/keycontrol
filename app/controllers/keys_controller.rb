class KeysController < ApplicationController
  before_action :set_key, only: [:show, :edit, :update, :destroy]

  def index
    @keys = Key.all
  end

  def show
  end

  def new
    @key = Key.new
  end

  def edit
  end

  def create
    @key = Key.new(key_params)

    respond_to do |format|
      if @key.save
        format.html { redirect_to @key, notice: 'Key was successfully created.' }
        format.json { render :show, status: :created, location: @key }
      else
        format.html { render :new }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @key.update(key_params)
        format.html { redirect_to @key, notice: 'Key was successfully updated.' }
        format.json { render :show, status: :ok, location: @key }
      else
        format.html { render :edit }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @key.destroy
    respond_to do |format|
      format.html { redirect_to keys_url, notice: 'Key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_key
      @key = Key.find(params[:id])
    end

    def key_params
      params.require(:key).permit(:code, :description)
    end
end