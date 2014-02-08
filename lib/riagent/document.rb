## ------------------------------------------------------------------- 
## 
## Copyright (c) "2013" Dmitri Zagidulin and Basho Technologies, Inc.
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

require "riagent/document/version"
require "active_support/concern"
require 'active_support/json'
require 'active_support/core_ext/object/to_json'
require "virtus"
require "virtus/attribute"

module Riagent
  module Document
    extend ActiveSupport::Concern
    
    included do
      include Virtus.model  # Virtus is used to manage document attributes
      
      attr_accessor :key
      alias_method :id, :key  # document.id same as document.key, to maintain Rails idiom
    end
  end
end
