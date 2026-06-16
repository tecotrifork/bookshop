// srv/cat-service.js
module.exports = class CatalogService extends cds.ApplicationService {
  init() {
    const { Books } = this.entities;

    this.before("*", (req) => {
      cds
        .log("access")
        .info(
          "event=" + req.event,
          "tenant=" + req.tenant,
          "user=" + req.user.id,
        );
    });

    // Validate stock can't go negative
    this.before("CREATE", Books, (req) => {
      if (req.data.stock < 0) req.error(400, "Stock cannot be negative");
      if (req.data.price < 10) {
        cds
          .log("orders")
          .error(" Price too low", { price: req.data.price, by: req.user.id });

        req.error(400, "Price must be at least 10");
      }
    });

    // Implement submitOrder
    this.on("submitOrder", async (req) => {
      const { book, quantity } = req.data;
      if (quantity < 1) req.reject(400, "Quantity must be positive");

      const row = await SELECT.one.from(Books).where({ ID: book });
      if (!row) req.reject(404, `Book ${book} not found`);
      if (row.stock < quantity) req.reject(409, `Only ${row.stock} in stock`);

      await UPDATE(Books, book).set({ stock: { "-=": quantity } });
      const updated = await SELECT.one.from(Books).where({ ID: book });
      return { stock: updated.stock };
    });

    this.after("UPDATE", Books, (each, req) => {
      cds.log("orders").info("Book updated", { id: each.ID, by: req.user.id });
    });

    return super.init();
  }
};
