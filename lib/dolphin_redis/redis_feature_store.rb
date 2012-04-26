require 'redis'

module DolphinRedis
  class RedisFeatureStore

    def initialize(redis_opts = {})
      @redis = Redis.new(redis_opts)
      @store_key = redis_opts[:store_key] || "dolphin_features"
    end

    attr_reader :redis, :store_key

    def [](feature_name)
      redis.hget(store_key, feature_name.to_s)
    rescue  
      'disabled'
    end

    def features
      redis.hgetall(store_key)
    rescue  
      {}
    end

    def update_feature(feature, flipper)
      redis.hset(store_key, feature.to_s, flipper.to_s)
    end

    def delete_feature(feature_name)
      redis.hdel(store_key, feature_name)
    end

    def clear
      redis.del(store_key)
    end

  end
end
