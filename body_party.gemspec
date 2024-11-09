# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name         = 'body_party'
  s.version      = '0.0.1.pre'
  s.summary      = 'Convert XPath-like notation into structured XML or Hash formats'
  s.description  = "It's easier to generate XML or Hash using xpaths as string"
  s.authors      = ['Anas Tammam']
  s.email        = 'anas.jber@gmail.com'
  s.files        = Dir['lib/*.rb']
  s.homepage     = 'https://github.com/anastammam/body_party'
  s.license      = 'MIT'
  s.add_dependency 'ox', '~> 2.4', '>= 2.4.1'
  s.required_ruby_version = '>= 3.0'
end
