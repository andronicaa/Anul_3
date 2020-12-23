namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveOneToOneRel : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.People", "User_Id", "dbo.AspNetUsers");
            DropIndex("dbo.People", new[] { "User_Id" });
            AddColumn("dbo.People", "UserId", c => c.String());
            DropColumn("dbo.People", "User_Id");
        }
        
        public override void Down()
        {
            AddColumn("dbo.People", "User_Id", c => c.String(nullable: false, maxLength: 128));
            DropColumn("dbo.People", "UserId");
            CreateIndex("dbo.People", "User_Id");
            AddForeignKey("dbo.People", "User_Id", "dbo.AspNetUsers", "Id");
        }
    }
}
