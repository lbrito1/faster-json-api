class Api::PartiesController < ApplicationController
  def index
    render json: Party.extend(PartySerializer).ruby_to_json
  end
end
