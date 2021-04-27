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
  (params
    (validates [:email :password] :required true)
    (permit [:email :password])))


(defn new [request]
  (let [account (get request :account {})
        errors (get request :errors {})]
    [
      [:h1 "Sign In"]
      (form-for [request :session/create]
        (label :email "Email")
        (email-field account :email)
        (when errors [:div {:class "red"} (get errors :email)])

        (label :password "Password")
        (password-field account :password)
        (when errors [:div {:class "red"} (get errors :password)])

        (submit "Sign In"))
      ]))


(defn password-matches? [hashed plaintext]
  (eprintf "Password %p" plaintext)
  (cipher/verify-password (env :password-key)
                          (get hashed :password)
                          (get plaintext :password)))

(defn create [request]
  (let [[_ account-params] (as-> request _
                                 (do (eprintf "%p" _) _)
                                 (params _)
                                 (do (eprintf "%p" _) _)
                                 (rescue _))
        email (get account-params :email)
        account (-> (db/from :account :where {:email email} :limit 1)
                    (get 0)
                    )]

    (if (and (not (nil? account))
             (password-matches? account account-params))
      (-> (redirect-to :home/index)
          (put :session {:account (select-keys account [:email :id :public-id])}))
      (new (put request :errors {:email "Email or password is incorrect"})))))

(defn destroy [request]
  (-> (redirect-to :home/index)
      (put :session {})))
