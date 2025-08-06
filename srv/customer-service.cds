using {com.logali as logali} from '../db/schema';
using {com.training as training} from '../db/training';

// service CatalogService {
//     entity Products       as projection on logali.materials.Products;
//     entity Suppliers      as projection on logali.sales.Suppliers;
//     entity UnitOfMeasures as projection on logali.materials.UnitOfMeasures;
//     entity Currency       as projection on logali.materials.Currencies;
//     entity DimensionUnit  as projection on logali.materials.DimensionUnits;
//     entity Category       as projection on logali.materials.Categories;
//     entity SalesData      as projection on logali.sales.SalesData;
//     entity Review         as projection on logali.materials.ProductReview;
//     entity Months         as projection on logali.sales.Months;
//     entity Orders         as projection on logali.sales.Orders;
//     entity OrderItem      as projection on logali.sales.OrderItem;
// }

service CatalogService {
    entity Products          as
        select from logali.materials.Products {
            // ID,
            // Name          as ProductName     @mandatory,
            // Description                      @mandatory,
            // ImageUrl,
            // ReleaseDate,
            // DiscontinuedDate,
            // Price                            @mandatory,
            // Height,
            // Width,
            // Depth,
            *,
            Quantity                         @mandatory,
            UnitOfMeasure as ToUnitOfMeasure @mandatory,
            Currency      as ToCurrency,
            Category      as ToCategory      @mandatory,
            Category.Name as Category        @readonly,
            DimensionUnit as ToDimensionUnit,
            SalesDate,
            Supplier,
            Reviews,
        };

    @readonly
    entity Supplier          as
        select from logali.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct,
        };

    @readonly
    entity Reviews           as
        select from logali.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            CreatedAt,
            Product,
        };

    @readonly
    entity SalesData         as
        select from logali.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct,
        };

    @readonly
    entity StockAvailability as
        select from logali.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct,
        };

    @readonly
    entity VH_Categories     as
        select from logali.materials.Categories {
            ID   as Code,
            Name as Text,
        };

    @readonly
    entity VH_Currencies     as
        select from logali.materials.Currencies {
            ID          as Code,
            Description as Text,
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from logali.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text,
        };

    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from logali.materials.DimensionUnits;
}


define service MyService {

    entity SuppliersProduct as
        select from logali.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Supplier.Address
        }
        where
            Supplier.Address.PostalCode = 98074;

    entity SuppliersToSales as
        select
            Supplier.Email,
            Category.Name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from logali.materials.Products;

}
