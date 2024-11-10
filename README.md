# BodyParty
BodyParty helps you convert XPath-like notations into structured XML or Hash formats. It parses paths with attributes and values, allowing for output that matches nodes regardless of the number of parents or sibling nodes.

This gem can be especially useful for interacting with APIs to generate requests from data-driven sources.

BodyParty is built on top of the fast XML parser [OX gem](https://github.com/ohler55/ox), which is implemented in C for speed.

## Installation

```bash
gem install body_party --pre
```

## Usage

```ruby
require 'body_party'

array = [
  "user/id?=1001",
  "user/first_name?=anas",
  "user/last_name?=tammam",
  "user/tags[@id=10]/name?=bella",
  "user/tags[@id=11]/name?=jullie"
]

BodyParty::Document.generate(xpaths: array, type: :hash)
=>
{
  :user => {
    :id => "1001",
    :first_name => "anas",
    :last_name => "tammam",
    :tags => [
      { :id => "10", :name => "bella" },
      { :id => "11", :name => "jullie" }
    ]
  }
}


BodyParty::Document.generate(xpaths: array, type: :xml)
=>
<?xml version="1.0" encoding="UTF-8"?>
<user>
  <id>1001</id>
  <first_name>anas</first_name>
  <last_name>tammam</last_name>
  <tags id="10">
    <name>bella</name>
  </tags>
  <tags id="11">
    <name>jullie</name>
  </tags>
</user
```

## Options
- xpaths: An array of strings representing each XPath. Each path can contain nodes separated by / and attributes in the format [@attr=value], such as pii/user[@id=10 @active=true].

- type: Specifies the output format, either :hash or :xml.

## More examples

```ruby
array = [
  'pii/first_name?=john',
  'pii/last_name?=doe'
]
BodyParty::Document.generate(xpaths: array, type: :hash)

# => :hash
{
  pii: {
      first_name: 'john',
      last_name: 'doe'
    }
}

BodyParty::Document.generate(xpaths: array, type: :xml)
# =>
<?xml version="1.0" encoding="UTF-8"?>
<pii>
  <first_name>john</first_name>
  <last_name>doe</last_name>
</pii>
```

```ruby
array = [
  'pii[@guest_id=96]/first_name?=john',
  'pii[@guest_id=96]/last_name?=doe'
]
BodyParty::Document.generate(xpaths: array, type: :hash)

# =>

{
  pii: {
    guest_id: '96',
    first_name: 'john',
    last_name: 'doe'
  }
}

BodyParty::Document.generate(xpaths: array, type: :xml)

# =>

<?xml version="1.0" encoding="UTF-8"?>
<pii guest_id="96">
  <first_name>john</first_name>
  <last_name>doe</last_name>
</pii>
```

```ruby
array = [
  'person[@id=1 @db_id=847503]/name?=John Doe',
  'person[@id=1 @db_id=847503]/age?=30',
  'person[@id=1 @db_id=847503]/city?=New York',
  'person[@id=1 @db_id=847503]/occupation?=Engineer',
  'person[@id=1 @db_id=847503]/email?=johndoe@example.com',
  'person[@id=1 @db_id=847503]/isActive?=true',
  'company/name?=Tech Solutions Inc.',
  'company/industry?=Software',
  'company/location?=San Francisco',
  'company/employees?=500',
  'company[@id=10 @debt=false @running=true]/name?=Tech Solutions Inc 2',
  'company[@id=10 @debt=false @running=true]/industry?=Sass',
  'company[@id=10 @debt=false @running=true]/location?=New york',
  'company[@id=10 @debt=false @running=true]/employees?=1000'
]

BodyParty::Document.generate(xpaths: array, type: :hash)

# =>
{
  :person => {
    :id => "1",
    :db_id => "847503",
    :name => "John Doe",
    :age => "30",
    :city => "New York",
    :occupation => "Engineer",
    :email => "johndoe@example.com",
    :isActive => "true"
  },
  :company => [{
    :name => "Tech Solutions Inc.",
    :industry => "Software",
    :location => "San Francisco",
    :employees => "500"
  },
  {
    :id => "10",
    :debt => "false",
    :running => "true"
    :name => "Tech Solutions Inc 2",
    :industry => "Sass",
    :location => "New york",
    :employees => "1000"
  }]
}

BodyParty::Document.generate(xpaths: array, type: :xml)

# =>
<?xml version="1.0" encoding="UTF-8"?>
<person id="1" db_id="847503">
  <name>John Doe</name>
  <age>30</age>
  <city>New York</city>
  <occupation>Engineer</occupation>
  <email>johndoe@example.com</email>
  <isActive>true</isActive>
</person>
<company>
  <name>Tech Solutions Inc.</name>
  <industry>Software</industry>
  <location>San Francisco</location>
  <employees>500</employees>
</company>
<company id="10" debt="false" running="true">
  <name>Tech Solutions Inc 2</name>
  <industry>Sass</industry>
  <location>New york</location>
  <employees>1000</employees>
</company>
```
## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
