package = "kong-plugin-kafka-log"
version = "0.0.1-0"
source = {
   url = "git://github.com/yskopets/kong-plugin-kafka-log",
   tag = "0.0.1"
}
description = {
   summary = "This plugin sends request and response logs to Kafka.",
   homepage = "https://github.com/yskopets/kong-plugin-kafka-log",
   license = "Apache 2.0"
}
dependencies = {
   "lua >= 5.1",
   "lua-resty-kafka >= 0.06"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.kafka-log.handler"] = "kong/plugins/kafka-log/handler.lua",
      ["kong.plugins.kafka-log.schema"] = "kong/plugins/kafka-log/schema.lua",

      ["kong.plugins.kafka-log.types"] = "kong/plugins/kafka-log/types.lua",
      ["kong.plugins.kafka-log.producers"] = "kong/plugins/kafka-log/producers.lua",
   }
}
