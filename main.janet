# Copyright (c) 2021 Levi Schuck
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

(use joy)

(import ./src/template :as template)
(import ./src/routes/home :as home)
(import ./src/routes/account :as account)
(import ./src/routes/session :as session)

# Routes
(route :get "/" home/index :home/index)
(route :get "/sign-up" account/new :account/new)
(route :post "/accounts" account/create :account/create)
(route :get "/sign-in" session/new :session/new)
(route :post "/sessions" session/create :session/create)
(route :delete "/sessions" session/destroy :session/destroy)
(route :post "/sessions/destroy" session/destroy :session/destroy)

# Middleware
(def app (-> (handler)
             (layout template/app-layout)
             (with-csrf-token)
             (with-session)
             (extra-methods)
             (query-string)
             (body-parser)
             (json-body-parser)
             (server-error)
             (x-headers)
             (static-files)
             (not-found)
             (logger)))

# Server
(defn main [& args]
  # Database must be available for the runtime within main
  (db/connect (env :database-url))
  (let [port (get args 1 (os/getenv "PORT" "9001"))
        host (get args 2 "localhost")]
    (server app port host)))
