require 'dolphin_redis/redis_feature_store'

module DolphinRedis

  def self.feature_store(opts = {})
    RedisFeatureStore.new(opts)
  end

end
