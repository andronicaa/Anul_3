using Microsoft.EntityFrameworkCore.Migrations;

namespace Agenda.Data.Migrations
{
    public partial class GoodPersonMigration : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContactInfos_Persons_PersonId",
                table: "ContactInfos");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos");

            migrationBuilder.DropIndex(
                name: "IX_ContactInfos_PersonId",
                table: "ContactInfos");

            migrationBuilder.DropColumn(
                name: "Adresa",
                table: "Persons");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "ContactInfos");

            migrationBuilder.RenameColumn(
                name: "PersonId",
                table: "ContactInfos",
                newName: "ContactInfoId");

            migrationBuilder.AddColumn<string>(
                name: "Adresa",
                table: "ContactInfos",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "CodPostal",
                table: "ContactInfos",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos",
                column: "ContactInfoId");

            migrationBuilder.AddForeignKey(
                name: "FK_ContactInfos_Persons_ContactInfoId",
                table: "ContactInfos",
                column: "ContactInfoId",
                principalTable: "Persons",
                principalColumn: "PersonId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContactInfos_Persons_ContactInfoId",
                table: "ContactInfos");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos");

            migrationBuilder.DropColumn(
                name: "Adresa",
                table: "ContactInfos");

            migrationBuilder.DropColumn(
                name: "CodPostal",
                table: "ContactInfos");

            migrationBuilder.RenameColumn(
                name: "ContactInfoId",
                table: "ContactInfos",
                newName: "PersonId");

            migrationBuilder.AddColumn<string>(
                name: "Adresa",
                table: "Persons",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "ContactInfos",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos",
                column: "Id");

            migrationBuilder.CreateIndex(
                name: "IX_ContactInfos_PersonId",
                table: "ContactInfos",
                column: "PersonId");

            migrationBuilder.AddForeignKey(
                name: "FK_ContactInfos_Persons_PersonId",
                table: "ContactInfos",
                column: "PersonId",
                principalTable: "Persons",
                principalColumn: "PersonId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
