class QuestionController < ApplicationController

  def show
    @question = Question.find_by_id(params[:id])
  end
end
