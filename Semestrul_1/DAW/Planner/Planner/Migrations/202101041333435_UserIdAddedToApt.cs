namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UserIdAddedToApt : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Appointments", "User_Id", c => c.String(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Appointments", "User_Id");
        }
    }
}
