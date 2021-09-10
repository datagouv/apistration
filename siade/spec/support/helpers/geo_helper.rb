module GeoHelper
  def self.non_existent(type)
    {
      region: '00',
      commune: '12345'
    }[type]
  end

  def self.valid(type)
    {
      communes: %w[
        76322
        76681
        75056
      ],
      regions: %w[
        28
        01
        11
      ]
    }[type]
  end
end
