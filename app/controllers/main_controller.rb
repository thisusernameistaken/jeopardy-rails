class MainController < ApplicationController
  def home
  end

  def upload
    if !params.include? "gf"  #false doesnt work for some reason
      redirect_to '/', notice: "Please Upload Game File!"
      return
    end
    @game = Game.new(game_params)
    @game.is_active=0
    if @game.save
      redirect_to "/play/#{@game.gamecode}", notice: "Game File Uploaded! Game ID is #{@game.gamecode}"
    else
      redirect_to '/', notice: "Game File Not Uploaded! File must be a XLS File!"
    end
  end

  private
  def game_params
    params.require(:gf).permit(:gamefile)
  end
end
