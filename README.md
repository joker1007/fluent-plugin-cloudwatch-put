# fluent-plugin-cloudwatch-put

[Fluentd](http://fluentd.org/) output plugin to do something.

TODO: write description for you plugin.

## Installation

### RubyGems

```
$ gem install fluent-plugin-cloudwatch-put
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-cloudwatch-put"
```

And then execute:

```
$ bundle
```

## Plugin helpers

* inject

* See also: Fluent::Plugin::Output

## Configuration

```
<match cloudwatch.metric_name>
  @type cloudwatch_put

  <buffer tag, key1>
    path cloudwatch.*.buffer

    flush_interval 1m
  </buffer>

  aws_key_id "#{ENV["AWS_ACCESS_KEY_ID"]}"
  aws_sec_key "#{ENV["AWS_SECRET_ACCESS_KEY"]}"

  region ap-northeast-1

  namespace "Dummy/Namespace"
  metric_name ${tag[1]}
  unit Count
  value_key value

  use_statistic_sets

  <dimensions>
    name method
    value ${key1}
  </dimensions>
</match>
```

### namespace (string) (required)

CloudWatch metric namespace (support placeholder)

### metric_name (string) (required)

CloudWatch metric name (support placeholder)

### unit (string) (required)

CloudWatch metric unit (support placeholder)

### value_key (string) (required)

Use this key as metric value

### storage_resolution (integer) (optional)

Cloudwatch storage resolution

Default value: `60`.

### use_statistic_sets (bool) (optional)

If this is true, aggregates record chunk before put metric


### \<dimensions\> section (required) (multiple)

#### name (string) (required)

Dimension name (support placeholder)

#### key (string) (optional)

Use this key as dimension value. If use_statistic_sets is true, this param is not supported. Use `value`

#### value (string) (optional)

Use static value as dimension value (support placeholder)


### \<buffer\> section (optional) (multiple)

#### chunk_limit_size (optional)

Default value: `30720`.

#### chunk_limit_records (optional)

Default value: `20`.

## Configuration for Authentication

### aws_key_id (string) (optional)

AWS access key id

### aws_sec_key (string) (optional)

AWS secret key.

### region (string) (optional)

region name

Default value: `us-east-1`.

### proxy_uri (string) (optional)

URI of proxy environment

### \<assume_role_credentials\> section (optional) (single)

#### role_arn (string) (required)

The Amazon Resource Name (ARN) of the role to assume

#### role_session_name (string) (required)

An identifier for the assumed role session

#### policy (string) (optional)

An IAM policy in JSON format

#### duration_seconds (integer) (optional)

The duration, in seconds, of the role session (900-3600)

#### external_id (string) (optional)

A unique identifier that is used by third parties when assuming roles in their customers' accounts.

### \<instance_profile_credentials\> section (optional) (single)

#### retries (integer) (optional)

Number of times to retry when retrieving credentials

#### ip_address (string) (optional)

IP address (default:169.254.169.254)

#### port (integer) (optional)

Port number (default:80)

#### http_open_timeout (float) (optional)

Number of seconds to wait for the connection to open

#### http_read_timeout (float) (optional)

Number of seconds to wait for one block to be read

### \<shared_credentials\> section (optional) (single)

#### path (string) (optional)

Path to the shared file. (default: $HOME/.aws/credentials)

#### profile_name (string) (optional)

Profile name. Default to 'default' or ENV['AWS_PROFILE']

## Copyright

* Copyright(c) 2017- joker1007
* License
  * MIT License
