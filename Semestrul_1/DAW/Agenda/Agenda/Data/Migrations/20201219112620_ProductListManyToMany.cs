using Microsoft.EntityFrameworkCore.Migrations;

namespace Agenda.Data.Migrations
{
    public partial class ProductListManyToMany : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_ShoppingList",
                table: "ShoppingList");

            migrationBuilder.RenameTable(
                name: "ShoppingList",
                newName: "ShoppingLists");

            migrationBuilder.AlterColumn<string>(
                name: "Titlu",
                table: "ShoppingLists",
                type: "nvarchar(15)",
                maxLength: 15,
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_ShoppingLists",
                table: "ShoppingLists",
                column: "ShoppingListId");

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    ProductId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Denumire = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Cantitate = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Descriere = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.ProductId);
                });

            migrationBuilder.CreateTable(
                name: "ProductShoppingList",
                columns: table => new
                {
                    ProductsProductId = table.Column<int>(type: "int", nullable: false),
                    ShoppingListsShoppingListId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductShoppingList", x => new { x.ProductsProductId, x.ShoppingListsShoppingListId });
                    table.ForeignKey(
                        name: "FK_ProductShoppingList_Products_ProductsProductId",
                        column: x => x.ProductsProductId,
                        principalTable: "Products",
                        principalColumn: "ProductId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ProductShoppingList_ShoppingLists_ShoppingListsShoppingListId",
                        column: x => x.ShoppingListsShoppingListId,
                        principalTable: "ShoppingLists",
                        principalColumn: "ShoppingListId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ProductShoppingList_ShoppingListsShoppingListId",
                table: "ProductShoppingList",
                column: "ShoppingListsShoppingListId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ProductShoppingList");

            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ShoppingLists",
                table: "ShoppingLists");

            migrationBuilder.RenameTable(
                name: "ShoppingLists",
                newName: "ShoppingList");

            migrationBuilder.AlterColumn<string>(
                name: "Titlu",
                table: "ShoppingList",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(15)",
                oldMaxLength: 15);

            migrationBuilder.AddPrimaryKey(
                name: "PK_ShoppingList",
                table: "ShoppingList",
                column: "ShoppingListId");
        }
    }
}
