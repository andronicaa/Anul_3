namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class JoinTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ShoppingListProductJoins",
                c => new
                    {
                        ShoppingListId = c.Int(nullable: false, identity: true),
                        ProductId = c.Int(nullable: false),
                        ShoppingList_ShoppingListId = c.Int(),
                    })
                .PrimaryKey(t => t.ShoppingListId)
                .ForeignKey("dbo.Products", t => t.ProductId, cascadeDelete: true)
                .ForeignKey("dbo.ShoppingLists", t => t.ShoppingList_ShoppingListId)
                .Index(t => t.ProductId)
                .Index(t => t.ShoppingList_ShoppingListId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ShoppingListProductJoins", "ShoppingList_ShoppingListId", "dbo.ShoppingLists");
            DropForeignKey("dbo.ShoppingListProductJoins", "ProductId", "dbo.Products");
            DropIndex("dbo.ShoppingListProductJoins", new[] { "ShoppingList_ShoppingListId" });
            DropIndex("dbo.ShoppingListProductJoins", new[] { "ProductId" });
            DropTable("dbo.ShoppingListProductJoins");
        }
    }
}
