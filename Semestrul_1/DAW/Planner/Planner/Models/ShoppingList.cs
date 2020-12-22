using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class ShoppingList
    {
        public int ShoppingListId { get; set; }

        [Required(ErrorMessage = "Camp obligatoriu")]
        [StringLength(15, ErrorMessage = "Titlul trebuie sa fie de lungime cuprinsa intre 4 si 15.", MinimumLength = 4)]
        public string Titlu { get; set; }

        // o lista de cumparaturi poate sa aiba mai multe produse si un produs poate sa apartina mai multor liste

        // many-to-many relation
        public ICollection<Product> Products { get; set; }
    }
}