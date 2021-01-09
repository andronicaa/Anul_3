namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UserIdAddedToInvoice : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoices", "ApplicationUser_Id", c => c.String(nullable: false, maxLength: 128));
            CreateIndex("dbo.Invoices", "ApplicationUser_Id");
            AddForeignKey("dbo.Invoices", "ApplicationUser_Id", "dbo.AspNetUsers", "Id", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Invoices", "ApplicationUser_Id", "dbo.AspNetUsers");
            DropIndex("dbo.Invoices", new[] { "ApplicationUser_Id" });
            DropColumn("dbo.Invoices", "ApplicationUser_Id");
        }
    }
}
