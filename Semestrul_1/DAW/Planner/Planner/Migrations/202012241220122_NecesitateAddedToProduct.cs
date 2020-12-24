namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class NecesitateAddedToProduct : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Products", "Necesitate", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Products", "Necesitate");
        }
    }
}
