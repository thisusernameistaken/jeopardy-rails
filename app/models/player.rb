class Player < ActiveRecord::Base
  belongs_to :game

  def initialize(params)
    super(params)
    self.score=0
  end
end
