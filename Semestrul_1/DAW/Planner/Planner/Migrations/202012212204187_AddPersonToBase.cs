namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPersonToBase : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.ShoppingListProduct", newName: "ShoppingListProducts");
            RenameColumn(table: "dbo.ShoppingListProducts", name: "ShoppingListRefId", newName: "ShoppingList_ShoppingListId");
            RenameColumn(table: "dbo.ShoppingListProducts", name: "ProductRefId", newName: "Product_ProductId");
            RenameIndex(table: "dbo.ShoppingListProducts", name: "IX_ShoppingListRefId", newName: "IX_ShoppingList_ShoppingListId");
            RenameIndex(table: "dbo.ShoppingListProducts", name: "IX_ProductRefId", newName: "IX_Product_ProductId");
        }
        
        public override void Down()
        {
            RenameIndex(table: "dbo.ShoppingListProducts", name: "IX_Product_ProductId", newName: "IX_ProductRefId");
            RenameIndex(table: "dbo.ShoppingListProducts", name: "IX_ShoppingList_ShoppingListId", newName: "IX_ShoppingListRefId");
            RenameColumn(table: "dbo.ShoppingListProducts", name: "Product_ProductId", newName: "ProductRefId");
            RenameColumn(table: "dbo.ShoppingListProducts", name: "ShoppingList_ShoppingListId", newName: "ShoppingListRefId");
            RenameTable(name: "dbo.ShoppingListProducts", newName: "ShoppingListProduct");
        }
    }
}
