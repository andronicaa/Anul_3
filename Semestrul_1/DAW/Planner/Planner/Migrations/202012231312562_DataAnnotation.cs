namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DataAnnotation : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.People", "UserId", c => c.String(nullable: false));
            AlterColumn("dbo.People", "UserName", c => c.String(nullable: false));
            AlterColumn("dbo.Products", "Denumire", c => c.String(nullable: false, maxLength: 10));
            AlterColumn("dbo.Products", "Cantitate", c => c.String(nullable: false));
            AlterColumn("dbo.Products", "Descriere", c => c.String(nullable: false, maxLength: 30));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Products", "Descriere", c => c.String());
            AlterColumn("dbo.Products", "Cantitate", c => c.String());
            AlterColumn("dbo.Products", "Denumire", c => c.String());
            AlterColumn("dbo.People", "UserName", c => c.String());
            AlterColumn("dbo.People", "UserId", c => c.String());
        }
    }
}
