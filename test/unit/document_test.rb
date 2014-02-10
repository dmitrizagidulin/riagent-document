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
  let(:user_document) { User.new }

  it "has a key" do
    user_document.key.must_be_nil # first initialized
    test_key = 'george'
    user_document.key = test_key
    user_document.key.must_equal test_key
    # Test for the .id alias
    user_document.id.must_equal test_key
  end
  
  it "has model attributes" do
    user_document.attributes.count.must_equal 3  # :username, :email, :language
  end
  
  it "should respond to to_json_document()" do
    assert user_document.respond_to?(:to_json_document)
  end
end