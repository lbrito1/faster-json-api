module PartySerializer
  def ruby_to_json
    all.to_json(only: %i(name description starts_at ends_at))
  end

  def postgres_to_json
    serialize_to_json
  end

  private

  def base_sql
    <<-SQL.gsub(/\n/, '')
      SELECT
      json_agg(
        json_build_object(
          'id', id,
          'name', name,
          'description', description,
          'starts_at', starts_at,
          'ends_at', ends_at
        )
      )
      FROM parties
    SQL
  end

  def serialize_to_json
    ActiveRecord::Base.connection.exec_query(Arel.sql(base_sql))
      .rows&.first&.first
  end
end
