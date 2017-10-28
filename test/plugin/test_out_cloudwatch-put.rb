require "helper"
require "fluent/plugin/out_cloudwatch-put.rb"

class CloudWatchPutOutputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  DEFAULT_CONF = %q{
    region ap-northeast-1
    namespace Test
    metric_name MetricName
    unit Count

    <dimensions>
      name dim1
      key key1
    </dimensions>

    <dimensions>
      name dim2
      key key2
    </dimensions>

    value_key key3

    aws_key_id dummy
    aws_sec_key dummy
  }

  test "configure" do
    d = create_driver
    assert { d.instance.buffer.chunk_limit_size == 30 * 1024 }
    assert { d.instance.dimensions.size == 2 }
    assert { d.instance.dimensions[0].name == "dim1" }
    assert { d.instance.dimensions[1].name == "dim2" }
  end

  test "write" do
    d = create_driver
    now = Time.now.to_i

    d.instance.start

    mock(d.instance.cloudwatch).put_metric_data({
      namespace: "Test",
      metric_data: [
        {
          metric_name: "MetricName",
          dimensions: [
            {
              name: "dim1",
              value: "val1",
            },
            {
              name: "dim2",
              value: "val2",
            },
          ],
          timestamp: Time.at(now),
          value: 1.0,
          unit: "Count",
          storage_resolution: 60,
        },
        {
          metric_name: "MetricName",
          dimensions: [
            {
              name: "dim1",
              value: "val1",
            },
            {
              name: "dim2",
              value: "val2",
            },
          ],
          timestamp: Time.at(now),
          value: 2.0,
          unit: "Count",
          storage_resolution: 60,
        },
        {
          metric_name: "MetricName",
          dimensions: [
            {
              name: "dim1",
              value: "val1",
            },
            {
              name: "dim2",
              value: "val2",
            },
          ],
          timestamp: Time.at(now),
          value: 3.0,
          unit: "Count",
          storage_resolution: 60,
        },
      ]
    })

    d.run do
      d.feed('tag', now, {"key1" => "val1", "key2" => "val2", "key3" => 1})
      d.feed('tag', now, {"key1" => "val1", "key2" => "val2", "key3" => 2})
      d.feed('tag', now, {"key1" => "val1", "key2" => "val2", "key3" => 3})
    end
  end

  test "write (use_statistic_sets)" do
    conf = %q{
      region ap-northeast-1
      namespace Test
      metric_name MetricName
      unit Count

      use_statistic_sets

      <dimensions>
        name dim1
        value dim_value1
      </dimensions>

      <dimensions>
        name dim2
        value dim_value2
      </dimensions>

      value_key key3

      aws_key_id dummy
      aws_sec_key dummy
    }
    d = create_driver(conf)
    now = Time.now.to_i

    d.instance.start

    mock(d.instance.cloudwatch).put_metric_data({
      namespace: "Test",
      metric_data: [
        {
          metric_name: "MetricName",
          dimensions: [
            {
              name: "dim1",
              value: "dim_value1",
            },
            {
              name: "dim2",
              value: "dim_value2",
            },
          ],
          timestamp: Time.at(now),
          statistic_values: {
            sample_count: 3,
            sum: 6.0,
            minimum: 1.0,
            maximum: 3.0,
          },
          unit: "Count",
          storage_resolution: 60,
        },
      ]
    })

    d.run do
      d.feed('tag', now, {"key1" => "val1", "key2" => "val2", "key3" => 1})
      d.feed('tag', now, {"key1" => "val1", "key2" => "val2", "key3" => 2})
      d.feed('tag', now, {"key1" => "val1", "key2" => "val2", "key3" => 3})
    end
  end

  private

  def create_driver(conf = DEFAULT_CONF)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::CloudWatchPutOutput).configure(conf)
  end
end
