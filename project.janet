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

(declare-project
  :name "joy-example-auth"
  :description "Joy Example Auth"
  :author "Levi Schuck"
  :license "MIT"
  :url "https://github.com/LeviSchuck/joy-example-auth"
  :repo "git+https://github.com/LeviSchuck/joy-example-auth"
  :dependencies [
    "https://github.com/joy-framework/joy"
    "https://github.com/janet-lang/sqlite3"
    ]
  )

(phony "server" []
  (if (= "development" (os/getenv "JOY_ENV"))
      # TODO check if entr exists
    (os/shell "find . -name '*.janet' | entr janet main.janet")
    (os/shell "janet main.janet")))

(declare-executable
  :name "auth"
  :entry "main.janet"
  )
