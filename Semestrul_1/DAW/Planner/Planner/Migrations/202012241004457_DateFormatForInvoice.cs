namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DateFormatForInvoice : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Invoices", "DataEmitere", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Invoices", "DataScadenta", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Invoices", "DataScadenta", c => c.String(nullable: false));
            AlterColumn("dbo.Invoices", "DataEmitere", c => c.String(nullable: false));
        }
    }
}
