class LandmarksController < ApplicationController
  # add controller methods
  get '/landmarks' do
    erb :'landmarks/index'
  end

  get '/landmarks/new' do
    erb :'landmarks/new'
  end

  get '/landmark/:id' do
    @landmark = Landmark.find(params[:id])
    erb :'landmarks/show'
  end
end
