namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DropDownListDailyTask : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.DailyTasks", "Prioritate", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.DailyTasks", "Prioritate", c => c.String(nullable: false));
        }
    }
}
