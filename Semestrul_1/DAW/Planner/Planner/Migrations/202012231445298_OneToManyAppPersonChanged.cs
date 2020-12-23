namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class OneToManyAppPersonChanged : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.Appointments", "PersonRef");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Appointments", "PersonRef", c => c.Int(nullable: false));
        }
    }
}
