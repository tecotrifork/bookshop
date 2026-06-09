using {
  cuid,
  managed,
} from '@sap/cds/common';

namespace sap.capire.bookshop;

entity Books : cuid, managed {
  title       : String(111) not null;
  stock       : Integer default 0;
  price       : Decimal(9,2);
  author      : Association to Authors;
}

entity Authors : cuid, managed {
  name        : String(111);
  books       : Association to many Books on books.author = $self;
}

entity Genres : cuid {
  name     : String(111);
  parent   : Association to Genres;
  children : Composition of many Genres on children.parent = $self;
}


