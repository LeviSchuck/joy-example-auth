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

(import joy :prefix "")
(import joy/db)
(import cipher)


(def params
  (params :account
    (validates [:email :password] :required true)
    (permit [:email :password])))

(defn new [request]
  (let [account (get request :account {})
        errors (get request :errors {})]
    [ [:h1 "Sign Up"]
      (form-for [request :account/create]
        (label :email "email")
        (email-field account :email)
        (when errors [:div {:class "red"} (get errors :email)])

        (label :password "password")
        (password-field account :password)
        (when errors [:div {:class "red"} (get errors :password)])

        (submit "Create Account"))
      ]
      
      ))


(defn hash-password [dict]
  (let [{:password password} dict
        key (env :password-key)
        new-password (cipher/hash-password key password)]
    (merge dict {:password new-password})))

# TODO If the user already exists, have an error
# It currently fails if you try to register twice.
(defn create [request]
  (let [result (as-> request _
                     (params _)
                     (hash-password _)
                     (db/insert _)
                     (rescue-from :params _))
        [errors account] result
        account (select-keys account [:id :email :public-id])]

    (if errors
      (new (put request :errors errors))
      (-> (redirect-to :home/index)
          (put :session {:account account})))))
