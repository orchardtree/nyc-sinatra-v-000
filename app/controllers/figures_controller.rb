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
    #New figure
    @figure = Figure.find_or_create_by(name: params[:figure][:name])

    #New landmark
    landmark_name = params[:landmark][:name]
    landmark_year = params[:landmark][:year_completed]
    if !landmark_name.empty?
      @landmark = Landmark.find_or_create_by(name: landmark_name, year_completed: landmark_year)
      @figure.landmarks << @landmark
    end

    #New title
    p_title_name = params[:title][:name]
    if !p_title_name.empty?
      @title = Title.find_or_create_by(name: p_title_name)
      add_figure_title = @figure.figure_titles.build(title: @title)
      add_figure_title.save
    end

    #New landmarks (checkboxes)
    p_landmark_ids = params[:figure][:landmark_ids]
    if p_landmark_ids != nil
      p_landmark_ids.each do |landmark|
        p_landmark_id = landmark.to_i
        p_landmark = Landmark.find(p_landmark_id)
        @figure.landmarks << p_landmark
      end
    end

    #New titles (checkboxes)
    p_title_ids = params[:figure][:title_ids]

    if p_title_ids != nil
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

    @figure = Figure.find(params[:id])

    #Update figure name
    @figure.update(name: params[:figure][:name])

    #Update landmarks (checkboxes) if selections are made
    landmark_edits = params[:figure][:landmark_ids]
    landmarks = @figure.landmarks

    #Remove (checkbox)
    if landmarks != nil
      landmarks.each do |landmark|
        str_landmark_id = landmark.id.to_s
        if landmark_edits != nil
           if !landmark_edits.include?(str_landmark_id)
             landmark.update(figure_id: nil)
           end
        else
          landmark.update(figure_id: nil)
        end
      end
    end

    #Add (checkbox)
    if landmark_edits != nil
      landmark_edits.each do |landmark_edit|
        proposed_edit = landmark_edit.to_i
        if !landmarks.where(id: proposed_edit).exists?
          landmarks << Landmark.find(proposed_edit)
        end
      end
    end

    #Add landmark name and year if provided
    p_landmark_name = params[:landmark][:name]
    p_landmark_year = params[:landmark][:year_completed]
    if !p_landmark_name.empty?
      new_landmark_name = Landmark.find_or_create_by(name: p_landmark_name, year_completed: p_landmark_year)
      @figure.landmarks << new_landmark_name
    end

    #Update titles (checkboxes)
    title_edits = params[:figure][:title_ids]
    titles = @figure.titles

    #Remove (checkbox)
    if titles != nil
      titles.each do |title|
        str_title_id = title.id.to_s
        if title_edits != nil
           if !title_edits.include?(str_title_id)
             old_figure_title = @figure.figure_titles.find_by(title_id: title.id)
             old_figure_title.destroy
           end
        else
          old_figure_title = @figure.figure_titles.find_by(title_id: title.id)
          old_figure_title.destroy
        end
      end
    end

    #Add (checkbox)
    if title_edits != nil
      title_edits.each do |title_edit|
        proposed_edit = title_edit.to_i
        if !titles.where(id: proposed_edit).exists?
          @figure.titles << Title.find(proposed_edit)
        end
      end
    end

    #Add title name and year if provided
    p_title_name = params[:title][:name]
    if !p_title_name.empty?
      title = Title.find_or_create_by(name: p_title_name)
      new_title_name = @figure.figure_titles.build(title: title)
      new_title_name.save
    end

    #Redirect
    redirect to "figures/#{@figure.id}"
  end
end
