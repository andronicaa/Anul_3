namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ShoppingListProductMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Products",
                c => new
                    {
                        ProductId = c.Int(nullable: false, identity: true),
                        Denumire = c.String(),
                        Cantitate = c.String(),
                        Descriere = c.String(),
                    })
                .PrimaryKey(t => t.ProductId);
            
            CreateTable(
                "dbo.ShoppingLists",
                c => new
                    {
                        ShoppingListId = c.Int(nullable: false, identity: true),
                        Titlu = c.String(nullable: false, maxLength: 15),
                    })
                .PrimaryKey(t => t.ShoppingListId);
            
            CreateTable(
                "dbo.ShoppingListProducts",
                c => new
                    {
                        ShoppingList_ShoppingListId = c.Int(nullable: false),
                        Product_ProductId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.ShoppingList_ShoppingListId, t.Product_ProductId })
                .ForeignKey("dbo.ShoppingLists", t => t.ShoppingList_ShoppingListId, cascadeDelete: true)
                .ForeignKey("dbo.Products", t => t.Product_ProductId, cascadeDelete: true)
                .Index(t => t.ShoppingList_ShoppingListId)
                .Index(t => t.Product_ProductId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ShoppingListProducts", "Product_ProductId", "dbo.Products");
            DropForeignKey("dbo.ShoppingListProducts", "ShoppingList_ShoppingListId", "dbo.ShoppingLists");
            DropIndex("dbo.ShoppingListProducts", new[] { "Product_ProductId" });
            DropIndex("dbo.ShoppingListProducts", new[] { "ShoppingList_ShoppingListId" });
            DropTable("dbo.ShoppingListProducts");
            DropTable("dbo.ShoppingLists");
            DropTable("dbo.Products");
        }
    }
}
