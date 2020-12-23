namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InvoiceModel : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoices",
                c => new
                    {
                        InvoiceId = c.Int(nullable: false, identity: true),
                        TipFactura = c.String(nullable: false),
                        DataEmitere = c.String(nullable: false),
                        DataScadenta = c.String(nullable: false),
                        TotalPlata = c.Double(nullable: false),
                        Status = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.InvoiceId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Invoices");
        }
    }
}
