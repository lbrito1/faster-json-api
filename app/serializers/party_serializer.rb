module PartySerializer
  def ruby_to_json
    all.to_json(only: %i(name description starts_at ends_at))
  end
end
