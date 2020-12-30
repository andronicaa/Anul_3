namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AppointmentDetailsMigration : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Appointments", "Detalii", c => c.String(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Appointments", "Detalii");
        }
    }
}
