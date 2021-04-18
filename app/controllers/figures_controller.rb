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
    @landmark = Landmark.find_or_create_by(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed])
    @title = Title.find_or_create_by(name: params[:title][:name])
    @figure.landmarks << @landmark
    @figure.titles << @title

    p_landmark_ids = params[:figure][:landmark_ids]
    if p_landmark_ids.size > 0
      p_landmark_ids.each do |landmark|
        p_landmark_id = landmark.to_i
        p_landmark = Landmark.find(p_landmark_id)
        @figure.landmarks << p_landmark
      end
    end

    p_title_ids = params[:figure][:title_ids]
    if p_title_ids.size > 0
      p_title_ids.each do |title|
        p_title_id = title.to_i
        p_title = Title.find(p_title_id)
        @figure.figure_titles.build(title: p_title)
      end
    end
    @figure.save
    redirect to "figures/#{@figure.id}"
  end

  patch '/figures/:id' do
    binding.pry
    redirect "figures/#{@figure.id}"
  end
end
