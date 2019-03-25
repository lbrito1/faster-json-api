p = Party.create(
  name: 'My awesome party',
  description: 'Incredible awesomeness',
  starts_at: Time.new(2022, 1, 1, 20, 00),
  ends_at: Time.new(2022, 1, 1, 23, 00)
)

Party.create(
  name: 'My SECOND awesome party',
  description: 'MORE Incredible awesomeness',
  starts_at: Time.new(2023, 1, 1, 20, 00),
  ends_at: Time.new(2023, 1, 1, 23, 00)
)

p.sweepstakes.create(
  name: 'My awesome Sweepstake',
  description: 'Pure incredibleness'
)

p.sweepstakes.create(
  name: 'My second awesome Sweepstake',
  description: 'Purer incredibleness'
)

