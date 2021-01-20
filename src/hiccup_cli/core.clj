(ns hiccup-cli.core
  (:require
   [clojure.string :as string]
   [clojure.walk :as walk]
   [hickory.core :as hickory]
   [clojure.tools.cli :refer [parse-opts]]
   [zprint.core :as zp])
  (:gen-class))

(def cli-options
  [[nil "--html HTML" "HTML"]
   [nil "--html-file FILE" "FILE"]])

(set! *warn-on-reflection* true)

(defn whitespace? [v]
  (and (string? v)
       (re-matches #"(?s)^(\s|\n)*$" v)))

(defn comment? [v]
  (and (string? v)
       (re-matches #"(?s)^(\s|\n)*<!--.*-->(\s|\n)*$" v)))

(defn walk-remove [pred coll]
  (walk/postwalk
   (fn [x]
     (cond
       (and (string? x) (empty? x)) ""
       (pred x) nil
       (string? x) (string/trim x)
       :else x)) coll))

(defn removable? [x]
  (or (= {} x)
      (nil? x)))

(defn walk-remove-nil [coll]
  (walk/postwalk
   (fn [x]
     (if (coll? x)
       (if (vector? x)
         (into [] (remove removable? x)) ;; For some reason (empty x) for a vector breaks
         (into (empty x) (remove removable? x)))
       x))
   coll))

(defn extract-single [parsed]
  (if (= 1 (count parsed))
    (first parsed)
    parsed))

(defn parse [html]
  (->> (hickory/parse-fragment html)
       (map hickory/as-hiccup)
       (walk-remove
        #(or (comment? %)
             (whitespace? %)))
       (walk-remove-nil)
       (extract-single)))

(defn -main [& args]
  (let [{:keys [options arguments errors summary]} (parse-opts args cli-options)]
    (zp/zprint
     (parse (slurp (:html-file options)))
     {:map {:comma? false}
      :color? false
      :style :hiccup})))
