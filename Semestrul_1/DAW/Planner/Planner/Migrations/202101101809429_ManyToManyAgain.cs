namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ManyToManyAgain : DbMigration
    {
        public override void Up()
        {
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
        }
    }
}
