using {sap.capire.bookshop as my} from '../db/schema';

@requires: 'authenticated-user'
service CatalogService @(path: '/catalog') {
@restrict: [
    { grant: 'READ' },
    { grant: ['CREATE','UPDATE','DELETE'], to: 'admin' },
      { grant: 'READ', to: 'sales', where: 'createdBy = $user.id' },
  { grant: 'READ', to: 'admin' },
  { grant: 'WRITE', to: 'admin' }
  ]
   entity Books as projection on my.Books;

   @requires: 'admin'
   entity Authors      as projection on my.Authors;

   action submitOrder(book: Books:ID, quantity: Integer)
    returns { stock: Integer };
}
