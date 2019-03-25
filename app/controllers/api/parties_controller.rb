class Api::PartiesController < ApplicationController
  def index
    render json: Party.extend(PartySerializer).postgres_to_json
  end
end
