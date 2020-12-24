namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddMultipleCustomValidation : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Appointments", "Data", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Appointments", "Data", c => c.String(nullable: false));
        }
    }
}
