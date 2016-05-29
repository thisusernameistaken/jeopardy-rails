require 'json'

class SSE
  def initialize(io)
    @io = io
  end

  def write(object)
    @io.write "data: #{JSON.dump(object)}\n\n"
  end

  def close
    @io.close
  end
end

class GameController < ApplicationController
  include ActionController::Live
  def show
    @game = Game.find_by_gamecode(params[:gamecode])
    if !@game
      redirect_to '/play', notice: "No game found with gamecode"
      return
    end
    if @game.is_active==false
      f = Creek::Book.new("public/"+@game.gamefile.to_s)
      f= f.sheets[0]
      rows = f.rows.to_a

      index = 1
      while index < rows.length
        r_info = []
        r = rows[index].each do |k,v|
          r_info << v
        end
        @game.questions.create("answer"=>r_info[0],"question"=>r_info[1],"value"=>r_info[2],"category"=>r_info[3])
        index+=1
      end
    end
    @categories = []
    f = Creek::Book.new("public/"+@game.gamefile.to_s)
    f= f.sheets[0]
    rows = f.rows.to_a
    rows[0].each do |k,v|
      @categories << v
    end
    @questions = @game.questions
  end

  def post
    @game = Game.find_by_gamecode(params[:gamecode])
    if !@game
      redirect_to '/play', notice: "No game found with gamecode"
      return
    end
    @game.num_players=params[:games][:number_of_players]
    @game.is_active = true;
    @game.save
    redirect_to "/load/#{@game.gamecode}"
  end

  def load_players
    @game = Game.find_by_gamecode(params[:gamecode])
    if !@game
      redirect_to '/play', notice: "No game found with gamecode"
      return
    end

    if (@game.players.length == @game.num_players)
      redirect_to "/play/#{@game.gamecode}"
    end

    render '_load'
   # @game.players.create("name"=>"Chris")
    #@game.players.create("name"=>"Alex")
    #redirect_to "/play/#{@game.gamecode}"
  end

  def play
  end

  def join
    @game = Game.find_by_gamecode(params[:add_player][:game_code])
    if !@game
      redirect_to '/play', notice: "No game found with gamecode"
      return
    end
    @game.players.create(player_params)
    if (@game.players.length < @game.num_players)
      redirect_to "/load/#{@game.gamecode}"
    else
      redirect_to "/play/#{@game.gamecode}"
    end
  end


  def update
    @game = Game.find_by_gamecode(params[:gamecode])
    if !@game
      redirect_to '/play', notice: "No game found with gamecode"
      return
    end
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    sse.write(@game.players.length)
  rescue IOError
  ensure
    sse.close
  end

  private
  def player_params
    params.require(:add_player).permit(:name)
  end
end
