require 'benchmark'
require 'csv'

class SerializationBenchmark
  attr_accessor :parties

  def create_parties(n_parties:)
    ActiveRecord::Base.transaction do
      @parties = (1..n_parties).map do |i|
        p = Party.create!(
          name: "My awesome party #{i}",
          description: "Incredible awesomeness #{i}",
          starts_at: Time.new(2022, 1, 1, 20, 00) + i.days,
          ends_at: Time.new(2022, 1, 1, 23, 00) + i.days
        )

        if i % 2 == 0
          p.sweepstakes.create(
            name: 'My awesome Sweepstake',
            description: 'Pure incredibleness'
          )

          p.sweepstakes.create(
            name: 'My second awesome Sweepstake',
            description: 'Purer incredibleness'
          )
        end

        p
      end
    end

    puts "Created #{n_parties} parties..."
  end

  def call
    # disable logger
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    Party.extend(PartySerializer)
    granularity = 1_000
    max = 10_000

    csv_string = CSV.generate do |csv|
      csv << ['size', 'ruby-real', 'ruby-total', 'postgres-real', 'postgres-total']
      (100..max).step(granularity) do |n|
        puts "Creating #{n} records..."
        create_parties(n_parties: n)

        result = Benchmark.bm(7) do |x|
          x.report("ruby") { Party.ruby_to_json }
          x.report("postgres") { Party.postgres_to_json }
        end

        csv << [n, result[0].real, result[0].total, result[1].real, result[1].total]

        puts 'Cleaning records...'
        @parties.each(&:delete)
      end
    end

    File.write("./lib/output/benchmark_result_#{max}.csv", csv_string)

  ensure
    puts 'Cleaning records...'
    @parties&.each(&:delete)
    ActiveRecord::Base.logger = old_logger
  end
end
