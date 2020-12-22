namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ShoppingProductMigration_2 : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.ShoppingListProducts", newName: "ShoppingListProduct");
            RenameColumn(table: "dbo.ShoppingListProduct", name: "ShoppingList_ShoppingListId", newName: "ShoppingListRefId");
            RenameColumn(table: "dbo.ShoppingListProduct", name: "Product_ProductId", newName: "ProductRefId");
            RenameIndex(table: "dbo.ShoppingListProduct", name: "IX_ShoppingList_ShoppingListId", newName: "IX_ShoppingListRefId");
            RenameIndex(table: "dbo.ShoppingListProduct", name: "IX_Product_ProductId", newName: "IX_ProductRefId");
        }
        
        public override void Down()
        {
            RenameIndex(table: "dbo.ShoppingListProduct", name: "IX_ProductRefId", newName: "IX_Product_ProductId");
            RenameIndex(table: "dbo.ShoppingListProduct", name: "IX_ShoppingListRefId", newName: "IX_ShoppingList_ShoppingListId");
            RenameColumn(table: "dbo.ShoppingListProduct", name: "ProductRefId", newName: "Product_ProductId");
            RenameColumn(table: "dbo.ShoppingListProduct", name: "ShoppingListRefId", newName: "ShoppingList_ShoppingListId");
            RenameTable(name: "dbo.ShoppingListProduct", newName: "ShoppingListProducts");
        }
    }
}
