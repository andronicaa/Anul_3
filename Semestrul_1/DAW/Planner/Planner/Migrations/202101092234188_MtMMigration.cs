namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MtMMigration : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.ShoppingListProducts", "ShoppingList_ShoppingListId", "dbo.ShoppingLists");
            DropForeignKey("dbo.ShoppingListProducts", "Product_ProductId", "dbo.Products");
            DropForeignKey("dbo.ShoppingListProductJoins", "ProductId", "dbo.Products");
            DropIndex("dbo.ShoppingListProductJoins", new[] { "ProductId" });
            DropIndex("dbo.ShoppingListProducts", new[] { "ShoppingList_ShoppingListId" });
            DropIndex("dbo.ShoppingListProducts", new[] { "Product_ProductId" });
            RenameColumn(table: "dbo.ShoppingListProductJoins", name: "ProductId", newName: "Product_ProductId");
            DropPrimaryKey("dbo.ShoppingListProductJoins");
            DropColumn("dbo.ShoppingListProductJoins", "ShoppingListId");
            AddColumn("dbo.ShoppingListProductJoins", "Id", c => c.Int(nullable: false, identity: true));
            AddPrimaryKey("dbo.ShoppingListProductJoins", "Id");
            AddColumn("dbo.ShoppingListProductJoins", "ShoppingListRef", c => c.Int(nullable: false));
            AddColumn("dbo.ShoppingListProductJoins", "ProductRef", c => c.Int(nullable: false));
            AlterColumn("dbo.ShoppingListProductJoins", "Product_ProductId", c => c.Int());
            CreateIndex("dbo.ShoppingListProductJoins", "Product_ProductId");
            AddForeignKey("dbo.ShoppingListProductJoins", "Product_ProductId", "dbo.Products", "ProductId");
            DropTable("dbo.ShoppingListProducts");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.ShoppingListProducts",
                c => new
                    {
                        ShoppingList_ShoppingListId = c.Int(nullable: false),
                        Product_ProductId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.ShoppingList_ShoppingListId, t.Product_ProductId });
            
            AddColumn("dbo.ShoppingListProductJoins", "ShoppingListId", c => c.Int(nullable: false, identity: true));
            DropForeignKey("dbo.ShoppingListProductJoins", "Product_ProductId", "dbo.Products");
            DropIndex("dbo.ShoppingListProductJoins", new[] { "Product_ProductId" });
            DropPrimaryKey("dbo.ShoppingListProductJoins");
            AlterColumn("dbo.ShoppingListProductJoins", "Product_ProductId", c => c.Int(nullable: false));
            DropColumn("dbo.ShoppingListProductJoins", "ProductRef");
            DropColumn("dbo.ShoppingListProductJoins", "ShoppingListRef");
            DropColumn("dbo.ShoppingListProductJoins", "Id");
            AddPrimaryKey("dbo.ShoppingListProductJoins", "ShoppingListId");
            RenameColumn(table: "dbo.ShoppingListProductJoins", name: "Product_ProductId", newName: "ProductId");
            CreateIndex("dbo.ShoppingListProducts", "Product_ProductId");
            CreateIndex("dbo.ShoppingListProducts", "ShoppingList_ShoppingListId");
            CreateIndex("dbo.ShoppingListProductJoins", "ProductId");
            AddForeignKey("dbo.ShoppingListProductJoins", "ProductId", "dbo.Products", "ProductId", cascadeDelete: true);
            AddForeignKey("dbo.ShoppingListProducts", "Product_ProductId", "dbo.Products", "ProductId", cascadeDelete: true);
            AddForeignKey("dbo.ShoppingListProducts", "ShoppingList_ShoppingListId", "dbo.ShoppingLists", "ShoppingListId", cascadeDelete: true);
        }
    }
}
