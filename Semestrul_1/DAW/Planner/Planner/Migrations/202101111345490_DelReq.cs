namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DelReq : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.People", "UserId", c => c.String());
            AlterColumn("dbo.People", "UserName", c => c.String());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.People", "UserName", c => c.String(nullable: false));
            AlterColumn("dbo.People", "UserId", c => c.String(nullable: false));
        }
    }
}
