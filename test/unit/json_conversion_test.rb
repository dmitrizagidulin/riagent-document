## ------------------------------------------------------------------- 
## 
## Copyright (c) "2014" Dmitri Zagidulin and Basho Technologies, Inc.
##
## This file is provided to you under the Apache License,
## Version 2.0 (the "License"); you may not use this file
## except in compliance with the License.  You may obtain
## a copy of the License at
##
##   http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing,
## software distributed under the License is distributed on an
## "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
## KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations
## under the License.
##
## -------------------------------------------------------------------

require 'test_helper'

describe "a Riagent::Document" do
  # See test/examples/models/user.rb
  # User class includes the Riagent::Document mixin

  it "can be converted to JSON and back" do
    user = User.new username: 'earl', email: 'earl@desandwich.com'
    json_obj = user.to_json_document
    json_obj.must_be_kind_of String
    
    new_user = User.from_json(json_obj)
    new_user.must_be_kind_of User
    new_user.username.must_equal 'earl'
  end
  
  it "from_json() returns nil if passed in an empty result string" do
    User.from_json(nil).must_be_nil
    User.from_json('').must_be_nil
    User.from_json([].to_json).must_be_nil
  end
end