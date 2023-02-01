#!/usr/bin/env bb
;; -*- mode: clojure; -*-
(require '[babashka.process :refer [process]])


(defn sh
  [& args]
  (println "+" (str/join " " args))
  (let [{:keys [exit out err]} (apply shell/sh args)]
    (if (not= 0 exit) (throw (Exception. err)) :ok)
    (println out)
    out))


(defn reset-psql
  "Reset PostgreSQL."
  []
  (sh "dropdb" "polaris")
  (sh "createdb" "polaris"))


(->> [reset-psql]
     (map (fn [f]
            (async/thread (try
                            (apply f [])
                            0
                            (catch Exception err
                              (println err)
                              1)))))
     (map #(async/<!! %))
     (apply max)
     System/exit)
