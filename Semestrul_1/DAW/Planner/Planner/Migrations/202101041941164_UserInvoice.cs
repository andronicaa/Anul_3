namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UserInvoice : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Invoices", "ApplicationUser_Id", "dbo.AspNetUsers");
            DropIndex("dbo.Invoices", new[] { "ApplicationUser_Id" });
            AlterColumn("dbo.Invoices", "UserId", c => c.String(nullable: false));
            DropColumn("dbo.Invoices", "ApplicationUser_Id");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Invoices", "ApplicationUser_Id", c => c.String(nullable: false, maxLength: 128));
            AlterColumn("dbo.Invoices", "UserId", c => c.String());
            CreateIndex("dbo.Invoices", "ApplicationUser_Id");
            AddForeignKey("dbo.Invoices", "ApplicationUser_Id", "dbo.AspNetUsers", "Id", cascadeDelete: true);
        }
    }
}
