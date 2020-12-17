using Microsoft.EntityFrameworkCore.Migrations;

namespace Agenda.Data.Migrations
{
    public partial class DropDownTaskM : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "ShoppingListType",
                table: "ShoppingList",
                newName: "Titlu");

            migrationBuilder.AlterColumn<int>(
                name: "Prioritate",
                table: "DailyTasks",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Titlu",
                table: "ShoppingList",
                newName: "ShoppingListType");

            migrationBuilder.AlterColumn<string>(
                name: "Prioritate",
                table: "DailyTasks",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");
        }
    }
}
