require 'benchmark'

class SerializationBenchmark
  attr_accessor :parties

  def create_parties(n_parties:)
    ActiveRecord::Base.transaction do
      @parties = (1..n_parties).map do |i|
        Party.create!(
          name: "My awesome party #{i}",
          description: "Incredible awesomeness #{i}",
          starts_at: Time.new(2022, 1, 1, 20, 00) + i.days,
          ends_at: Time.new(2022, 1, 1, 23, 00) + i.days
        )
      end
    end

    puts "Created #{n_parties} parties..."
  end

  def call
    # disable logger
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    puts 'Creating records...'
    create_parties(n_parties: 1_000)

    Party.extend(PartySerializer)

    Benchmark.bm(7) do |x|
      x.report("ruby") { Party.ruby_to_json }
    end

  ensure
    puts 'Cleaning records...'
    @parties.each(&:delete)
    ActiveRecord::Base.logger = old_logger
  end
end
