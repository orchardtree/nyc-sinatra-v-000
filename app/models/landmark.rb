class Landmark < ActiveRecord::Base
  # add relationships here
  belongs_to :figure
  has_many :figure_titles, through: :figures
  has_many :titles, through: :figure_titles
end
