module GeoHelper
  def self.non_existent(type)
    {
      region:  '00',
      commune: '12345'
    }[type]
  end

  def self.valid(type)
    {
      communes: [
        '76322',
        '76681',
        '75056'
      ],
      regions:  [
        '28',
        '01',
        '11'
      ]
    }[type]
  end
end
