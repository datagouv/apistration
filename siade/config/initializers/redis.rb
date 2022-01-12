Redis.current = Redis.new(url: ENV['REDIS_DATABASE_URL'] || 'redis://localhost:6379/0')
