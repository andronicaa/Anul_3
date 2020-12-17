using Microsoft.EntityFrameworkCore.Migrations;

namespace Agenda.Data.Migrations
{
    public partial class GoodMigrationPerson : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContactInfos_Persons_ContactInfoId",
                table: "ContactInfos");

            migrationBuilder.RenameColumn(
                name: "PersonId",
                table: "Persons",
                newName: "Id");

            migrationBuilder.RenameColumn(
                name: "ContactInfoId",
                table: "ContactInfos",
                newName: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ContactInfos_Persons_Id",
                table: "ContactInfos",
                column: "Id",
                principalTable: "Persons",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContactInfos_Persons_Id",
                table: "ContactInfos");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "Persons",
                newName: "PersonId");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "ContactInfos",
                newName: "ContactInfoId");

            migrationBuilder.AddForeignKey(
                name: "FK_ContactInfos_Persons_ContactInfoId",
                table: "ContactInfos",
                column: "ContactInfoId",
                principalTable: "Persons",
                principalColumn: "PersonId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
