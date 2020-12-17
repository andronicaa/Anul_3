using Microsoft.EntityFrameworkCore.Migrations;

namespace Agenda.Data.Migrations
{
    public partial class PersonContact : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContactInfos_Persons_Id",
                table: "ContactInfos");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "Persons",
                newName: "PersonId");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "ContactInfos",
                newName: "PersonRef");

            migrationBuilder.AddColumn<int>(
                name: "ContactInfoId",
                table: "ContactInfos",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos",
                column: "ContactInfoId");

            migrationBuilder.CreateIndex(
                name: "IX_ContactInfos_PersonRef",
                table: "ContactInfos",
                column: "PersonRef",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_ContactInfos_Persons_PersonRef",
                table: "ContactInfos",
                column: "PersonRef",
                principalTable: "Persons",
                principalColumn: "PersonId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ContactInfos_Persons_PersonRef",
                table: "ContactInfos");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos");

            migrationBuilder.DropIndex(
                name: "IX_ContactInfos_PersonRef",
                table: "ContactInfos");

            migrationBuilder.DropColumn(
                name: "ContactInfoId",
                table: "ContactInfos");

            migrationBuilder.RenameColumn(
                name: "PersonId",
                table: "Persons",
                newName: "Id");

            migrationBuilder.RenameColumn(
                name: "PersonRef",
                table: "ContactInfos",
                newName: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ContactInfos",
                table: "ContactInfos",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_ContactInfos_Persons_Id",
                table: "ContactInfos",
                column: "Id",
                principalTable: "Persons",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
