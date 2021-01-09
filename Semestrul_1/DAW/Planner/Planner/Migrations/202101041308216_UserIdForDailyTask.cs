namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UserIdForDailyTask : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.DailyTasks", "UserId", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.DailyTasks", "UserId");
        }
    }
}
