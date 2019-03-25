module PartySerializer
  def ruby_to_json
    Party.left_outer_joins(:sweepstakes).select('
      parties.name AS parties_name,
      parties.description AS parties_desc,
      parties.starts_at,
      parties.ends_at,
      sweepstakes.name AS s_name,
      sweepstakes.description AS s_desc').to_json(only: %(name parties_desc parties_name starts_at ends_at s_desc s_name))
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
            'dates', json_build_object(
              'starts_at', starts_at,
              'ends_at', ends_at
            ),
            'sweepstakes', s.json_agg
          )
        )
      FROM parties
      LEFT JOIN (
        SELECT
            party_id,
            json_agg(
               json_build_object(
                'name', name,
                'description', description
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
