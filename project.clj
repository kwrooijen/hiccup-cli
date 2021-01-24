(defproject hiccup-cli "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.10.2-rc3"]
                 [org.clojure/clojurescript "1.9.293"]
                 [kwrooijen/hickory "0.7.1"]
                 [org.clojure/tools.cli "1.0.194"]
                 [org.jsoup/jsoup "1.13.1"]
                 [org.clojure/tools.reader "1.3.4"]
                 [zprint "1.1.1"]]
  :plugins [[io.taylorwood/lein-native-image "0.3.1"]]
  :main ^:skip-aot hiccup-cli.core
  :resource-paths ["resources"]
  :source-paths ["src"]
  :native-image {:opts ["--allow-incomplete-classpath"
                        "--enable-url-protocols=http,https"
                        "--initialize-at-build-time"
                        "--no-fallback"
                        "--no-server"
                        "--report-unsupported-elements-at-runtime"
                        "--verbose"
                        "-Dclojure.compiler.direct-linking=true"
                        "-H:+ReportExceptionStackTraces"
                        "-H:EnableURLProtocols=https,http"]}

  :uberjar-name "hiccup-cli-main.jar"

  :jvm-opts ["-Dclojure.compiler.direct-linking=true"]

  :profiles
  {:uberjar {:aot :all
             :jvm-opts ["-Dclojure.compiler.direct-linking=true"]
             :resource-paths ["resources"]}})
