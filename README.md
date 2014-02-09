## riagent-document

Riagent::Document is a Ruby object to JSON document conversion format, for persistence to Riak db.

### Features
 * Convenient model definition language that is familiar to anyone who has worked with Ruby MVC frameworks
 * Support for embedded documents for ease of object composition
 * Serialization to and from JSON (which can be saved in Riak)
 
### Model/Document Definition
Riagent::Document uses [Virtus](https://github.com/solnic/virtus) for document attributes, defaults and coercions.

To turn a Ruby class into a Document, add ```riagent-document``` to your Gemfile,
and ```include``` Riagent::Document in your model class.

```ruby
include 'riagent-document'

# models/user.rb
class User
  include Riagent::Document
  
  attribute :username, String
  attribute :email, String
  attribute :country, String, default: 'USA'
end
```

### Conversion to and from JSON
```ruby
# Documents accept mass attribute assignment in the initializer
user = User.new username: 'Test User', email: 'test@user.com'
user.country = 'Canada'

# Convert to JSON string
user_string = user.to_json_document
# => '{"username":"Test User", "email":"test@user.com", "country":"Canada"}'

# Convert from JSON string back to an object instance
new_user = User.from_json(user_string)
puts new_user.inspect
# => #<User:0x00000102a9aaa8 @username="Test User", @email="test@user.com", ...>
```

### Embedding Documents
You can compose Documents out of complex types. 

For example, if you were implementing an ```AddressBook``` object, you could embed ```Contact``` objects directly, using a Set.

```ruby
class Contact
  include Riagent::Document
  
  attribute :contact_name, String
  attribute :contact_email, String
end

class AddressBook
  include Riagent::Document
  
  attribute :user_key, String
  attribute :contacts, Set[Contact]
end
```

Which would then allow you to serialize the whole composite document:

```ruby
address_book = AddressBook.new user_key: 'test-user123'
c1 = Contact.new contact_name: 'Joe', contact_email: 'joe@test.net'
c2 = Contact.new contact_name: 'Jane', contact_email: 'jane@test.net'
address_book.contacts << c1
address_book.contacts << c2
json_str = address_book.to_json_document
puts json_str
#  '{ "user_key":"test-user123", 
#     "contacts":[
#       {"contact_name":"Joe","contact_email":"joe@test.net"},
#       {"contact_name":"Jane","contact_email":"jane@test.net"}
#     ]
#   }' 
```

And then, of course, re-hydrate the JSON string back into document instances:

```ruby
require 'riak-client'
new_book = AddressBook.from_json(json_str)
puts new_book.inspect
# <AddressBook:0x00000102a38fd8 @user_key="test-user123", 
#   @contacts=#<Set: {#<Contact:0x00000102a38df8 @contact_name="Joe", @contact_email="joe@test.net">, #<Contact:0x00000102a387e0 @contact_name="Jane", @contact_email="jane@test.net">}>, ...>
```

### Persistence
Now that you can convert model objects into JSON strings and back, how do you actually save them to Riak?

You can manually persist them to Riak by using the [Riak Ruby Client](https://github.com/basho/riak-ruby-client):
```ruby
# Get an instance of the model object
user = User.new username: 'Test User', email: 'test@user.com'

# Initialize a Riak client, and save
client = Riak::Client.new
riak_object = client.bucket("users").get_or_new("test-user-123")  # a Riak::RObject for bucket "users" and key "test-user-123"
riak_object.content_type = "application/json"
riak_object.raw_data = user.to_json_document
riak_object.store
```

Or save documents to [Solr](https://github.com/basho/yokozuna/)-indexed collections via the 
[RiakJson Client](https://github.com/basho-labs/riak_json_ruby_client):

```ruby
require 'riak_json'
# Get an instance of the model object
user = User.new username: 'Test User', email: 'test@user.com'

# Insert into a RiakJson collection
client = RiakJson::Client.new
collection = client.collection("users")
collection.insert(user)
```