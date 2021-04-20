class LandmarksController < ApplicationController
  # add controller methods
  get '/landmarks' do
    @landmarks = Landmark.all
    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    erb :'landmarks/new'
  end

  get '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    erb :'landmarks/show'
  end

  get '/landmarks/:id/edit' do
    @landmark = Landmark.find(params[:id])
    erb :'landmarks/edit'
  end

  post '/landmarks' do
    landmark_name = params[:landmark][:name]
    landmark_year = params[:landmark][:year_completed]
    @landmark = Landmark.find_or_create_by(name: landmark_name, year_completed: landmark_year)
    redirect to "landmarks/#{@landmark.id}"
  end

  patch '/landmarks/:id' do
    @landmark = Landmark.find(params[:id])
    landmark_name = params[:landmark][:name]
    landmark_year = params[:landmark][:year_completed]
    @landmark = Landmark.find_or_create_by(name: landmark_name, year_completed: landmark_year)

    redirect to "landmarks/#{@landmark.id}"
  end
end
