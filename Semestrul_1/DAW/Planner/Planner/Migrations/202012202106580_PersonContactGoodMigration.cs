namespace Planner.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PersonContactGoodMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ContactInfoes",
                c => new
                    {
                        ContactInfoId = c.Int(nullable: false),
                        NrTelefon = c.String(nullable: false),
                        Email = c.String(nullable: false),
                        Adresa = c.String(nullable: false),
                        CodPostal = c.String(nullable: false),
                        PersonRef = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.ContactInfoId)
                .ForeignKey("dbo.People", t => t.ContactInfoId)
                .Index(t => t.ContactInfoId);
            
            CreateTable(
                "dbo.People",
                c => new
                    {
                        PersonId = c.Int(nullable: false, identity: true),
                        Nume = c.String(nullable: false),
                        Prenume = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.PersonId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ContactInfoes", "ContactInfoId", "dbo.People");
            DropIndex("dbo.ContactInfoes", new[] { "ContactInfoId" });
            DropTable("dbo.People");
            DropTable("dbo.ContactInfoes");
        }
    }
}
