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
            'id', parties.id,
            'name', parties.name,
            'description', parties.description,
            'starts_at', parties.starts_at,
            'ends_at', parties.ends_at,
            'sweepstakes', s.json_agg
          )
        )
      FROM parties
      LEFT JOIN (
        SELECT
            party_id,
            json_agg(
               json_build_object(
                'name', name
               )
            )
        FROM sweepstakes
        GROUP BY party_id
        ) s ON s.party_id = parties.id
    SQL
  end

  def serialize_to_json
    ActiveRecord::Base.connection.exec_query(Arel.sql(base_sql))
      .rows&.first&.first
  end
end
