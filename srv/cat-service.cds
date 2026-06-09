using {sap.capire.bookshop as my} from '../db/schema';

service CatalogService @(path: '/catalog') {
   @cds.redirection.target entity Books as projection on my.Books;
   entity Authors      as projection on my.Authors;

   action submitOrder(book: Books:ID, quantity: Integer)
    returns { stock: Integer };
}
