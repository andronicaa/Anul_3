namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class OneToManyAppPersonMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Appointments",
                c => new
                    {
                        AppointmentId = c.Int(nullable: false, identity: true),
                        AppointmentType = c.String(nullable: false),
                        Data = c.String(nullable: false),
                        Adresa = c.String(nullable: false),
                        Persoane = c.String(nullable: false),
                        PersonRef = c.Int(nullable: false),
                        Person_PersonId = c.Int(),
                    })
                .PrimaryKey(t => t.AppointmentId)
                .ForeignKey("dbo.People", t => t.Person_PersonId)
                .Index(t => t.Person_PersonId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Appointments", "Person_PersonId", "dbo.People");
            DropIndex("dbo.Appointments", new[] { "Person_PersonId" });
            DropTable("dbo.Appointments");
        }
    }
}
