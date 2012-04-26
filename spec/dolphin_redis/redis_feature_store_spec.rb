require 'redis'
require 'dolphin_redis/redis_feature_store'

describe DolphinRedis::RedisFeatureStore do

  let(:redis_opts) do
    {
      :host => 'localhost',
      :port => 12345,
      :store_key => 'my_features'
    }
  end

  let(:redis) { mock(:redis) }

  subject { described_class.new(redis_opts) }

  before do
    Redis.stub(:new).and_return(redis)
  end

  it "should create a redis instance with the correct options" do
    Redis.should_receive(:new).with(redis_opts)
    subject
  end

  it "should pickup the key for the features hash" do
    subject.store_key.should == "my_features"
  end

  context "with no store_key attribute" do
    before do
      redis_opts.delete(:store_key)
    end

    it "should select 'dolphin_features' as the default key" do
      subject.store_key.should == 'dolphin_features'
    end
  end

  context "when I try to retrieve a single feature" do
    before do
      redis.stub(:hget).with('my_features', 'feat').and_return('enabled')
    end

    it "should tell me that the feature is disabled" do
      subject['feat'].should == 'enabled'
    end

    context "if it fails to contact the redis instance" do
      before do
        redis.stub(:hget).with('my_features', 'feat').and_raise("Unable to connect to server")
      end

      it "should tell me that the feature is disabled" do
        subject['feat'].should == 'disabled'
      end
    end
  end

  context "when I try to retrieve all features" do
    let(:all_features) { {'feat1' => 'disabled', 'feat2' => 'enabled'} }
    before do
      redis.stub(:hgetall).with('my_features').and_return(all_features)
    end

    it "should return me all features that are available" do
      subject.features.should == all_features
    end

    context "if it fails to contact the redis instance" do
      before do
        redis.stub(:hgetall).with('my_features').and_raise("Unable to connect to server")
      end

      it "should tell me that the feature is disabled" do
        subject.features.should == {}
      end
    end
  end

  context "when I update a feature" do
    it "should order redis to update the key" do
      redis.should_receive(:hset).with('my_features', 'feat', 'enabled')
      subject.update_feature('feat', 'enabled')
    end
  end

  context "when I delete a feature" do
    it "should order redis to delete the feature" do
      redis.should_receive(:hdel).with('my_features', 'fitur')
      subject.delete_feature('fitur')
    end
  end

  context "when I clear the store" do
    it "should delete the hash in redis" do
      redis.should_receive(:del).with('my_features')
      subject.clear
    end
  end

end
