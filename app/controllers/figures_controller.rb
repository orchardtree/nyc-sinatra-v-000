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
    #binding.pry
    p_landmark_name = params[:landmark][:name]
    p_landmark_year = params[:landmark][:year_completed]
    if !p_landmark_name.empty?
      @landmark = Landmark.find_or_create_by(name: p_landmark_name, year_completed: p_landmark_year)
      @figure.landmarks << @landmark
    end

    p_title_name = params[:title][:name]
    if !p_title_name.empty?
      @title = Title.find_or_create_by(name: p_title_name)
      add_figure_title = @figure.figure_titles.build(title: @title)
      add_figure_title.save
    end

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
        new_figure_title = @figure.figure_titles.build(title_id: p_title_id)
        new_figure_title.save
      end
    end

    redirect to "figures/#{@figure.id}"
  end

  patch '/figures/:id' do
    binding.pry
    @figure = Figure.find(params[:id])
    @figure.update(name: params[:figure][:name])

    p_landmark_name = params[:landmark][:name]
    p_landmark_year = params[:landmark][:year_completed]
    if !p_landmark_name.empty?
      @landmark = Landmark.find_or_create_by(name: p_landmark_name, year_completed: p_landmark_year)
      @figure.landmarks << @landmark
    end

    p_title_name = params[:title][:name]
    if !p_title_name.empty?
      @title = Title.find_or_create_by(name: p_title_name)
      add_figure_title = @figure.figure_titles.build(title: @title)
      add_figure_title.save
    end

    p_landmarks = params[:figure][:landmark_ids]
    db_landmarks = @figure.landmarks

    p_landmarks.each do |landmark|
      p_landmark = landmark.to_i
      if !db_landmarks.include?(p_landmark)
        db_landmarks << p_landmark
      end
    end
    db_landmarks.each do |landmark|
      db_landmark = landmark.to_s
      if !p_landmarks.include?(db_landmark)
        db_landmarks.delete(landmark)
      end
    end

    p_titles = params[:figure][:title_ids]
    db_titles = @figure.titles

    p_titles.each do |title|
      p_title = title.to_i
      if !db_titles.include?(p_title)
        add_title = Title.find(p_title)
        db_titles.figure_titles.build(title: add_title)
      end
    end
    db_titles.each do |title|
      db_title = title.to_s
      if !p_titles.include?(db_title)
        @figure.figure_titles.find(title_id: db_title)
      end
    end

    redirect to "figures/#{@figure.id}"
  end
end
