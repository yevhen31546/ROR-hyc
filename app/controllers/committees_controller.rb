class CommitteesController < ApplicationController
  resource_controller

  def index
    @committees = Committee.order('name asc')
  end
end
