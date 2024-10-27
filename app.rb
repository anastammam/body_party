require 'xpath'
require './lib/xml/doc'
require './lib/xml/node'
require 'debug'


# puts BodyParty::Xml::Doc.generate(xpaths:
#   [
#     "library/books/book[@id=1]/title?=The Great Gatsby",
#     "library/books/book[@id=1]/author?=F. Scott Fitzgerald",
#     "library/books/book[@id=1]/year?=1925",
#     "library/books/book[@id=1]/genres/genre?=Fiction",
#     "library/books/book[@id=1]/genres/genre?=Classic",
#     "library/books/book[@id=2]/title?=To Kill a Mockingbird",
#     "library/books/book[@id=2]/author?=Harper Lee",
#     "library/books/book[@id=2]/year?=1960",
#     "library/books/book[@id=2]/genres/genre?=Fiction",
#     "library/books/book[@id=2]/genres/genre?=Drama",
#     "library/members/member[@id=101]/name?=Emily Johnson",
#     "library/members/member[@id=101]/joinDate?=2022-01-15",
#     "library/members/member[@id=101]/borrowedBooks/bookId?=1",
#     "library/members/member[@id=101]/borrowedBooks/bookId?=2",
#     "library/members/member[@id=102]/name?=Michael Brown",
#     "library/members/member[@id=102]/joinDate?=2023-03-10",
#     "library/members/member[@id=102]/borrowedBooks/bookId?=2"
#   ]
# )
