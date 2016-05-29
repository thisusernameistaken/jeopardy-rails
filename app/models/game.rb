class Game < ActiveRecord::Base
  mount_uploader :gamefile, GamefileUploader
  has_many :questions
  has_many :players

  def initialize(params)
    super
    self.gamecode=generate_code()
  end

  private
  def generate_code
    alpha_num = ('A'..'Z').to_a;
    code = ''
    4.times do
      code += alpha_num[rand(26)]
    end
    return code
  end
end
