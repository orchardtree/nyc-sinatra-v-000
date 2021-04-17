class FiguresController < ApplicationController
  # add controller methods
  get '/figures' do
    @figures = Figure.all
    erb :'figures/index'
  end

  get '/figures/new' do
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'figures/new'
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'figures/edit'
  end

  post '/figures' do
    @figure = Figure.find_or_create_by(name: params[:figure][:name])
    @landmark = Landmark.find_or_create_by(name: params[:figure][:new_landmark][:name], year_completed: params[:figure][:new_landmark][:year_completed])
    @title = Title.find_or_create_by(name: params[:figure][:new_title][:name])
    @figure.landmarks << @landmark
    @figure.titles << @title
    params[:figure][:landmarks].each do |landmark|
      p_landmark_id = landmark.to_i
      p_landmark = Landmark.find(p_landmark_id)
      @figure.landmarks << p_landmark
    end
    params[:figure][:titles].each do |title|
      p_title_id = title.to_i
      p_title = Title.find(p_title_id)
      @figure.figure_titles.build(title: p_title)
    end
    @figure.save
    redirect to "figures/#{@figure.id}"
  end

  patch '/figures/:id' do
    binding.pry
    redirect "figures/#{@figure.id}"
  end
end
