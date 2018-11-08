
# Kong Kafka Log Plugin

This plugin publishes request and response logs to a [Kafka](https://kafka.apache.org/) topic.

## Status
Experimental

## Supported Kong Releases
Kong >= 0.14.x 

## Installation
Recommended:
```
$ luarocks install kong-plugin-kafka-log
```
Other:
```
$ git clone https://github.com/yskopets/kong-plugin-kafka-log.git /path/to/kong/plugins/kong-plugin-kafka-log
$ cd /path/to/kong/plugins/kong-plugin-kafka-log
$ luarocks make *.rockspec
```

## Configuration

### Enabling globally

```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=kafka-log" \
    --data "config.bootstrap_servers=localhost:9092" \
    --data "config.topic=kong-log" \
    --data "config.timeout=10000" \
    --data "config.keepalive=60000" \
    --data "config.producer_request_acks=1" \
    --data "config.producer_request_timeout=2000" \
    --data "config.producer_request_limits_messages_per_request=200" \
    --data "config.producer_request_limits_bytes_per_request=1048576" \
    --data "config.producer_request_retries_max_attempts=10" \
    --data "config.producer_request_retries_backoff_timeout=100" \
    --data "config.producer_async=true" \
    --data "config.producer_async_flush_timeout=1000" \
    --data "config.producer_async_buffering_limits_messages_in_memory=50000"
```

### Parameters

Here's a list of all the parameters which can be used in this plugin's configuration:

| Form Parameter | default | description |
| --- 						| --- | --- |
| `name` 					                        |       | The name of the plugin to use, in this case `kafka-log` |
| `config.bootstrap_servers` 	                    |       | List of bootstrap brokers in `host:port` format |
| `config.topic` 			                        |       | Topic to publish to |
| `config.timeout`   <br /> <small>Optional</small> | 10000 | Socket timeout in millis |
| `config.keepalive` <br /> <small>Optional</small> | 60000 | Keepalive timeout in millis |
| `config.producer_request_acks` <br /> <small>Optional</small>                              | 1       | The number of acknowledgments the producer requires the leader to have received before considering a request complete. Allowed values: 0 for no acknowledgments, 1 for only the leader and -1 for the full ISR |
| `config.producer_request_timeout` <br /> <small>Optional</small>                           | 2000    | Time to wait for a Produce response in millis |
| `config.producer_request_limits_messages_per_request` <br /> <small>Optional</small>       | 200     | Maximum number of messages to include into a single Produce request |
| `config.producer_request_limits_bytes_per_request` <br /> <small>Optional</small> 	     | 1048576 | Maximum size of a Produce request in bytes |
| `config.producer_request_retries_max_attempts` <br /> <small>Optional</small> 	         | 10      | Maximum number of retry attempts per single Produce request |
| `config.producer_request_retries_backoff_timeout` <br /> <small>Optional</small>	     	 | 100     | Backoff interval between retry attempts in millis |
| `config.producer_async` <br /> <small>Optional</small>                                     | true    | Flag to enable asynchronous mode |
| `config.producer_async_flush_timeout` <br /> <small>Optional</small>                       | 1000    | Maximum time interval in millis between buffer flushes in in asynchronous mode | 
| `config.producer_async_buffering_limits_messages_in_memory` <br /> <small>Optional</small> | 50000   | Maximum number of messages that can be buffered in memory in asynchronous mode |

## Log Format

Similar to [HTTP Log Plugin](https://docs.konghq.com/hub/kong-inc/http-log#log-format).

## Implementation details

This plugin makes use of [lua-resty-kafka](https://github.com/doujiang24/lua-resty-kafka) client under the hood.   

## Known issues and limitations

Known limitations: 

1. There is no support for TLS
2. There is no support for Authentication
3. There is no support for message compression

## Quickstart

The following guidelines assume that both `Kong` and `Kafka` have been installed on your local machine: 

1. Install `kong-plugin-kafka-log` via `luarocks`:

    ```
    luarocks install kong-plugin-kafka-log
    ```

2. Load the `kong-plugin-kafka-log` in `Kong`:

    ```
    KONG_PLUGINS=bundled,kafka-log bin/kong start
    ```

3. Create `kong-log` topic in your `Kafka` cluster:

    ```
    ${KAFKA_HOME}/bin/kafka-topics.sh --create \
        --zookeeper localhost:2181 \
        --replication-factor 1 \
        --partitions 10 \
        --topic kong-log
    ```

4. Add `kong-plugin-kafka-log` plugin globally:

    ```
    curl -X POST http://localhost:8001/plugins \
        --data "name=kafka-log" \
        --data "config.bootstrap_servers=localhost:9092" \
        --data "config.topic=kong-log"
    ```
    
5. Make sample requests:

    ```
    for i in {1..50} ; do curl http://localhost:8000/request/$i ; done
    ```

6. Verify the contents of `Kafka` topic:

    ```
    ${KAFKA_HOME}/bin/kafka-console-consumer.sh \
        --bootstrap-server localhost:9092 \
        --topic kong-log \
        --partition 0 \
        --from-beginning \
        --timeout-ms 1000
    ```

## Maintainers
[yskopets](https://github.com/yskopets)  
