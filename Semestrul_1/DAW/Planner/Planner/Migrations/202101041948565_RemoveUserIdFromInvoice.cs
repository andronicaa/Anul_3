namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveUserIdFromInvoice : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.Invoices", "UserId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Invoices", "UserId", c => c.String(nullable: false));
        }
    }
}
