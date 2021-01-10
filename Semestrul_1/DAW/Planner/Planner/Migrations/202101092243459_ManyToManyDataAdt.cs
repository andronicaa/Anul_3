namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ManyToManyDataAdt : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.ShoppingListProductJoins", "Product_ProductId", "dbo.Products");
            DropForeignKey("dbo.ShoppingListProductJoins", "ShoppingList_ShoppingListId", "dbo.ShoppingLists");
            DropIndex("dbo.ShoppingListProductJoins", new[] { "Product_ProductId" });
            DropIndex("dbo.ShoppingListProductJoins", new[] { "ShoppingList_ShoppingListId" });
            RenameColumn(table: "dbo.ShoppingListProductJoins", name: "Product_ProductId", newName: "ProductId");
            RenameColumn(table: "dbo.ShoppingListProductJoins", name: "ShoppingList_ShoppingListId", newName: "ShoppingListId");
            AlterColumn("dbo.ShoppingListProductJoins", "ProductId", c => c.Int(nullable: false));
            AlterColumn("dbo.ShoppingListProductJoins", "ShoppingListId", c => c.Int(nullable: false));
            CreateIndex("dbo.ShoppingListProductJoins", "ShoppingListId");
            CreateIndex("dbo.ShoppingListProductJoins", "ProductId");
            AddForeignKey("dbo.ShoppingListProductJoins", "ProductId", "dbo.Products", "ProductId", cascadeDelete: true);
            AddForeignKey("dbo.ShoppingListProductJoins", "ShoppingListId", "dbo.ShoppingLists", "ShoppingListId", cascadeDelete: true);
            DropColumn("dbo.ShoppingListProductJoins", "ShoppingListRef");
            DropColumn("dbo.ShoppingListProductJoins", "ProductRef");
        }
        
        public override void Down()
        {
            AddColumn("dbo.ShoppingListProductJoins", "ProductRef", c => c.Int(nullable: false));
            AddColumn("dbo.ShoppingListProductJoins", "ShoppingListRef", c => c.Int(nullable: false));
            DropForeignKey("dbo.ShoppingListProductJoins", "ShoppingListId", "dbo.ShoppingLists");
            DropForeignKey("dbo.ShoppingListProductJoins", "ProductId", "dbo.Products");
            DropIndex("dbo.ShoppingListProductJoins", new[] { "ProductId" });
            DropIndex("dbo.ShoppingListProductJoins", new[] { "ShoppingListId" });
            AlterColumn("dbo.ShoppingListProductJoins", "ShoppingListId", c => c.Int());
            AlterColumn("dbo.ShoppingListProductJoins", "ProductId", c => c.Int());
            RenameColumn(table: "dbo.ShoppingListProductJoins", name: "ShoppingListId", newName: "ShoppingList_ShoppingListId");
            RenameColumn(table: "dbo.ShoppingListProductJoins", name: "ProductId", newName: "Product_ProductId");
            CreateIndex("dbo.ShoppingListProductJoins", "ShoppingList_ShoppingListId");
            CreateIndex("dbo.ShoppingListProductJoins", "Product_ProductId");
            AddForeignKey("dbo.ShoppingListProductJoins", "ShoppingList_ShoppingListId", "dbo.ShoppingLists", "ShoppingListId");
            AddForeignKey("dbo.ShoppingListProductJoins", "Product_ProductId", "dbo.Products", "ProductId");
        }
    }
}
