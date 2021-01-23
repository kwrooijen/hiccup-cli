(ns hiccup-cli.core
  (:require
   [clojure.string :as string]
   [clojure.walk :as walk]
   [hickory.core :as hickory]
   [clojure.tools.cli :refer [parse-opts]]
   [zprint.core :as zp])
  (:import [org.jsoup Jsoup]
           [org.jsoup.parser Parser])
  (:gen-class))

(def cli-options
  [[nil "--html HTML" "HTML"]
   [nil "--html-file FILE" "FILE"]])

(set! *warn-on-reflection* true)

(defn- whitespace? [v]
  (and (string? v)
       (re-matches #"(?s)^(\s|\n)*$" v)))

(defn- comment? [v]
  (and (string? v)
       (re-matches #"(?s)^(\s|\n)*<!--.*-->(\s|\n)*$" v)))

(defn- walk-remove [pred coll]
  (walk/postwalk
   (fn [x]
     (cond
       (and (string? x) (empty? x)) ""
       (pred x) nil
       (string? x) (string/trim x)
       :else x))
   coll))

(defn- removable? [x]
  (or (= {} x)
      (nil? x)))

(defn- walk-remove-nil [coll]
  (walk/postwalk
   (fn [x]
     (if (coll? x)
       (if (vector? x)
         (into [] (remove removable? x)) ;; For some reason (empty x) for a vector breaks
         (into (empty x) (remove removable? x)))
       x))
   coll))

(defn- extract-single [parsed]
  (if (= 1 (count parsed))
    (first parsed)
    parsed))

(defn- parse [html]
  (->> (Jsoup/parse html "" (Parser/xmlParser))
       (hickory/as-hiccup)
       (walk-remove
        #(or (comment? %)
             (whitespace? %)))
       (walk-remove-nil)
       (extract-single)))

(defn- print-hiccup [s]
  (zp/zprint s
             {:map {:comma? false}
              :color? false
              :style :hiccup}))

(defn -main [& args]
  (let [{:keys [options _arguments _errors summary]} (parse-opts args cli-options)]
    (cond
      (:html-file options) (-> options :html-file slurp parse print-hiccup)
      (:html options) (-> options :html parse print-hiccup)
      :else (println summary))))
